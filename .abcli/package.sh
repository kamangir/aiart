function aiart_package() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "aiart package$ABCUL[generator=$AIART_GENERATOR_LIST,publish]" \
            "package $abcli_object_name."
        return
    fi

    local options=$1
    local do_publish=$(abcli_option_int "$options" publish 0)
    local generator=$(abcli_option "$options" generator $AIART_DEFAULT_GENERATOR)

    python3 -m aiart.html \
        create \
        --generator $generator \
        --working_folder $abcli_object_path \
        ${@:2}

    if [ "$do_publish" == 1 ] ; then
        abcli_upload report.html

        abcli_publish \
            $abcli_object_name \
            report.html
        abcli_publish \
            $abcli_object_name \
            $generator.png

        abcli_tag set \
            $abcli_object_name \
            published
    fi

    abcli_tag set \
        $abcli_object_name \
        $generator,aiart
}