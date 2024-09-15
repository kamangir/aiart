#! /usr/bin/env bash

function aiart_generate_video() {
    local options=$1
    local app_name=$(abcli_option "$options" app aiart)

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local args=$(abcli_option "$options" video.args -)
        local args=$(echo $args | tr + "-" | tr @ " ")

        local app_options=""
        [[ "$app_name" == aiart ]] && app_options="app=$(echo $aiart_list_of_apps | tr , \|),"

        local options="$app_options~dryrun,frame_count=16,marker=PART,~publish,~render,resize_to=1280x1024,~sign,slice_by=words|sentences,~upload,url"
        abcli_show_usage "$app_name generate video$ABCUL[$options]$ABCUL<filename.txt|url>$ABCUL[$args]" \
            "<filename.txt>|url -> video.mp4"
        return
    fi

    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_publish=$(abcli_option_int "$options" publish $(abcli_not $dryrun))
    local do_render=$(abcli_option_int "$options" render $(abcli_not $dryrun))
    local do_upload=$(abcli_option_int "$options" upload $(abcli_not $dryrun))
    local frame_count=$(abcli_option_int "$options" frame_count -1)
    local is_url=$(abcli_option_int "$options" url 0)
    local marker=$(abcli_option "$options" marker)
    local slice_by=$(abcli_option "$options" slice_by sentences)

    local input_filename=$2

    abcli_log "$app_name: generate: video: $input_filename -[${@:3}]-> $frame_count frame(s)"

    if [ "$is_url" == 1 ]; then
        local input_filename=$abcli_object_path/script.txt
        curl "$2" --output $input_filename
    fi

    python3 -m articraft.script \
        flatten \
        --filename $input_filename \
        --frame_count $frame_count \
        --slice_by $slice_by \
        --marker "$marker"

    local options=~tag,$options

    local i=0
    local sentence
    local filename=""
    local success=true
    while IFS= read -r sentence; do
        if [ -z "$sentence" ]; then
            local filename=""
            continue
        fi

        local previous_filename=$filename
        local filename=$(python3 -c "print(f'{$i:010d}')")

        $app_name generate image \
            "$options" \
            "$filename" \
            "$previous_filename" \
            "$sentence" \
            ${@:3}

        if [ $? -ne 0 ]; then
            local success=false
            break
        fi

        ((i = i + 1))
    done <"$input_filename"
    if [ "$success" == false ]; then
        return 1
    fi

    if [ "$dryrun" == 0 ]; then
        abcli_tags set \
            $abcli_object_name \
            $app_name
    fi

    if [ "$do_render" == 1 ]; then
        abcli_create_video \
            png,filename=video,fps=5,resize_to=$ABCLI_VIDEO_DEFAULT_SIZE,$options

        if [ -f "video.gif" ]; then
            rm -rv video.gif
        fi

        ffmpeg -i \
            video.mp4 \
            video.gif
    fi

    [[ "$do_upload" == 1 ]] &&
        abcli_upload

    if [ "$do_publish" == 1 ]; then
        abcli_publish prefix=video.gif $abcli_object_name
        abcli_publish suffix=.png $abcli_object_name
    fi
}
