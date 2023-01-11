#! /usr/bin/env bash

function aiart_generate_image() {
    local options=$1
    local app_name=$(abcli_option "$options" app aiart)

    if [ $(abcli_option_int "$options" help 0) == 1 ] ; then
        abcli_show_usage "$app_name generate image$ABCUL[app=<app-name>,~dryrun,~sign,~tag]$ABCUL[<image>] [<previous-image>]$ABCUL[\"<sentence>\"]$ABCUL[--width 768 --height 576 --seed 42]" \
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

    eval ${app_name}_generate_function \
        "$options" \
        $filename \
        $prev_filename \
        "$sentence"

    if [ "$dryrun" == 1 ] ; then
        return
    fi

    if [ "$do_tag" == 1 ] ; then
        abcli_tag set \
            $abcli_object_name \
            $app_name
    fi

    if [ "$do_sign" == 1 ] ; then
        local footer=$sentence

        if [ -z "$prev_filename" ] ; then
            local footer="* $footer"
        fi
    else
        local footer=""
    fi
    local footer="$footer | ${@:5}"

    python3 -m abcli.modules.host \
        add_signature \
        --application $($app_name version) \
        --filename $abcli_object_path/$filename.png \
        --footer "$footer"
}