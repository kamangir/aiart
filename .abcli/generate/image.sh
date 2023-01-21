#! /usr/bin/env bash

function aiart_generate_image() {
    local options=$1
    local app_name=$(abcli_option "$options" app openai)

    if [ $(abcli_option_int "$options" help 0) == 1 ] ; then
        local args=$(abcli_option "$options" image.args -)

        local args=$(echo $args | tr + "-" | tr @ " ")
        local options="app=<app-name>,~dryrun,height=<576>,~sign,~tag,width=<768>"
        abcli_show_usage "$app_name generate image$ABCUL[$options]$ABCUL[<image>] [<previous-image>]$ABCUL[\"<sentence>\"]$ABCUL[$args]" \
            "<sentence> -[<previous-image>]-> <image>.png."
        return
    fi

    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_sign=$(abcli_option_int "$options" sign $(abcli_not $dryrun))
    local do_tag=$(abcli_option_int "$options" tag $(abcli_not $dryrun))

    local filename=$(abcli_clarify_input $2 frame)

    local prev_filename=$(abcli_clarify_input $3)

    local sentence=$4

    if [ -z "$prev_filename" ] ; then
        abcli_log "📘  $i: $sentence"
    else
        abcli_log "📖  $i: $sentence"
    fi

    mkdir -p $abcli_object_path/raw

    ${app_name}_generate_function \
        "$options" \
        "$filename" \
        "$prev_filename" \
        "$sentence" \
        ${@:5}
    if [ $? -ne 0 ]; then
        return
    fi

    if [ "$dryrun" == 1 ] ; then
        return
    fi

    cp -v \
        $abcli_object_path/raw/$filename.png \
        $abcli_object_path/$filename.png


    if [ "$do_tag" == 1 ] ; then
        abcli_tag set \
            $abcli_object_name \
            $app_name
    fi

    local footer=""
    if [ "$do_sign" == 1 ] ; then
        local footer=$sentence
    fi
    python3 -m abcli.modules.host \
        add_signature \
        --application $($app_name version) \
        --filename $abcli_object_path/$filename.png \
        --footer "$footer"
}