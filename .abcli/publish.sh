#! /usr/bin/env bash

function aiart_publish() {
    local task=$(abcli_unpack_keyword $1)

    if [ "$task" == "help" ] ; then
        abcli_show_usage "aiart publish$ABCUL[generator=$AIART_GENERATOR_LIST]" \
            "publish $abcli_object_name."
        return
    fi

    local options=$1
    local generator=$AIART_DEFAULT_GENERATOR
    if [ -f "$abcli_object_path/DALL-E.json" ] ; then
        local generator=DALL-E
    fi
    local generator=$(abcli_option "$options" generator $generator)

    abcli_log "aiart: publishing zzz $object_name"

    abcli_download
    abcli_upload

    abcli_publish $abcli_object_name $generator.png
    abcli_publish $abcli_object_name $generator.json

    abcli_tag set $abcli_object_name \
        published,$generator,aiart
}