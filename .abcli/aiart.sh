#! /usr/bin/env bash

function aiart() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m aiart --help
        fi

        return
    fi

    local function_name=aiart_$task
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name ${@:2}
        return
    fi

    if [ "$task" == "version" ] ; then
        abcli_log $(python3 -m aiart version ${@:2})
        return
    fi

    abcli_log_error "-aiart: $task: command not found."
}