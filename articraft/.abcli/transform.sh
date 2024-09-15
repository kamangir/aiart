#! /usr/bin/env bash

function aiart_transform() {
    local options=$1
    local app_name=$(abcli_option "$options" app aiart)

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local args=$(abcli_option "$options" video.args -)

        local args=$(echo $args | tr + "-" | tr @ " ")
        local options="count=<1>,~dryrun,extension=jpg,~sign,~tag,~upload"
        abcli_show_usage "$app_name transform$ABCUL[$options]$ABCUL[<object-name>]$ABCUL[\"<prompt>\"]$ABCUL[$args]" \
            "<object-name> -<prompt>-> $abcli_object_name."
        return
    fi

    local destination_object=$abcli_object_name

    local count=$(abcli_option_int "$options" count -1)
    local do_upload=$(abcli_option_int "$options" upload 1)
    local do_tag=$(abcli_option_int "$options" tag 1)
    local extension=$(abcli_option "$options" extension jpg)

    local source_object=$(abcli_clarify_object $2 ..)

    local sentence=$3

    abcli_log "blue-stability: transform: $source_object -[\"$sentence\" ${@:4}]-> $destination_object [count:$count]"

    abcli_select $source_object ~trail

    abcli_download

    mkdir -p $ABCLI_OBJECT_ROOT/$destination_object/raw/

    local list_of_images=""
    local i=0
    local filename
    for filename in *.$extension; do
        local list_of_images="$list_of_images ${filename%.*}"

        python3 -m articraft.image \
            convert \
            --source $abcli_object_path/$filename \
            --destination $ABCLI_OBJECT_ROOT/$destination_object/raw/${filename%.*}-source.png \
            ${@:4}

        ((i = i + 1))

        if [ "$count" != -1 ]; then
            if [[ "$i" -ge "$count" ]]; then
                break
            fi
        fi
    done
    abcli_log_list "$list_of_images" \
        --before "transforming" \
        --delim space \
        --after "images(s)"

    abcli_select $destination_object ~trail

    local filename
    for filename in $list_of_images; do
        aiart generate image \
            ~tag,$options \
            $filename \
            $filename-source \
            "$sentence" \
            ${@:4}
    done

    [[ "$do_tag" == 1 ]] &&
        abcli_tags set \
            $destination_object \
            aiart

    [[ "$do_upload" == 1 ]] &&
        abcli_upload
}
