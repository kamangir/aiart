#! /usr/bin/env bash

function aiart() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then

        abcli_show_usage "abcli_quote <message>" \
            "urllib.parse.quote(<message>)."
        abcli_show_usage "abcli_unquote <message>" \
            "urllib.parse.unquote(<message>)."

        aiart_create_html "$@"
        aiart_generate help app=aiart
        aiart_transform "$@"

        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m aiart --help
        fi

        return
    fi

    local function_name=aiart_$task
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == "version" ] ; then
        python3 -m aiart version ${@:2}
        return
    fi

    abcli_log_error "-aiart: $task: command not found."
}