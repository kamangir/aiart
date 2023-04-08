function aiart_publish() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "aiart publish$ABCUL[generator=$AIART_GENERATOR_LIST]" \
            "publish $abcli_object_name."
        return
    fi

    local options=$1
    local generator=$(abcli_option "$options" generator $AIART_DEFAULT_GENERATOR)

    abcli_download

    abcli_publish $abcli_object_name $generator.png
    abcli_publish $abcli_object_name $generator.json

    abcli_tag set $abcli_object_name \
        published,$generator,aiart
}