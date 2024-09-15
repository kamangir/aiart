#! /usr/bin/env bash

function aiart_generate_image() {
    local options=$1
    local app_name=$(abcli_option "$options" app aiart)

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local args=$(abcli_option "$options" image.args -)
        local args=$(echo $args | tr + "-" | tr @ " ")

        local app_options=""
        [[ "$app_name" == aiart ]] && app_options="app=$(echo $aiart_list_of_apps | tr , \|),"

        local options="$app_options~dryrun,height=<576>,~sign,~tag,width=<768>"
        abcli_show_usage "$app_name generate image$ABCUL[$options]$ABCUL[<image>] [<previous-image>]$ABCUL[\"<prompt>\"]$ABCUL[$args]" \
            "<prompt> -[<previous-image>]-> <image>.png."
        return
    fi

    local app_name=$(abcli_option "$options" app openai_commands)
    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_sign=$(abcli_option_int "$options" sign $(abcli_not $dryrun))
    local do_tag=$(abcli_option_int "$options" tag $(abcli_not $dryrun))

    local filename=$(abcli_clarify_input $2 frame)

    local prev_filename=$(abcli_clarify_input $3)

    local prompt=$4

    [[ -z "$prev_filename" ]] &&
        abcli_log "📘  $i: $prompt" ||
        abcli_log "📖  $i: $prompt"

    mkdir -p $abcli_object_path/raw

    ${app_name}_generate_function \
        "$options" \
        "$filename" \
        "$prev_filename" \
        "$prompt" \
        "${@:5}"
    [[ $? -ne 0 ]] && return 1

    [[ "$dryrun" == 1 ]] && return

    cp -v \
        $abcli_object_path/raw/$filename.png \
        $abcli_object_path/$filename.png

    [[ "$do_tag" == 1 ]] &&
        abcli_tags set \
            $abcli_object_name \
            $app_name

    [[ "$do_sign" == 1 ]] && local footer=$prompt || local footer=""
    python3 -m blue_objects.host \
        add_signature \
        --application $($app_name version) \
        --filename $abcli_object_path/$filename.png \
        --footer "$footer" \
        --word_wrap 1
}
