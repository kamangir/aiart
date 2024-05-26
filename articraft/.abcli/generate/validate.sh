#! /usr/bin/env bash

function aiart_generate_validate() {
    local options=$1
    local app_name=$(abcli_option "$options" app aiart)

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        local app_options=""
        [[ "$app_name" == aiart ]] && app_options="app=$(echo $aiart_list_of_apps | tr , \|),"

        local options="${app_options}dryrun,what=all|image|video"
        abcli_show_usage "$app_name generate validate$ABCUL[$options]" \
            "validate $app_name."
        return
    fi

    local dryrun=$(abcli_option_int "$options" dryrun 0)
    local what=$(abcli_option "$options" what all)

    if [ "$what" == "all" ]; then
        aiart_generate_validate \
            app=$app_name,dryrun=$dryrun,what=image
        aiart_generate_validate \
            app=$app_name,dryrun=$dryrun,what=video
        return
    fi

    if [ "$what" == "image" ]; then
        abcli_select
        $app_name generate image \
            dryrun=$dryrun \
            validation - \
            "an orange carrot walking on Mars."
        return
    fi

    if [ "$what" == "video" ]; then
        abcli_select
        $app_name generate video \
            dryrun=$dryrun,frame_count=3,marker=PART,~publish,~upload,url \
            https://www.gutenberg.org/cache/epub/51833/pg51833.txt \
            "${@:2}"
        return
    fi

    abcli_log_error "-$app_name: generate: validate: $what: command not found."
    return 1
}
