#! /usr/bin/env bash

export aiart_list_of_apps="blue_stability,openai_cli"

function aiart() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        abcli_show_usage "abcli_quote <message>" \
            "urllib.parse.quote(<message>)."
        abcli_show_usage "abcli_unquote <message>" \
            "urllib.parse.unquote(<message>)."

        aiart_generate help app=aiart
        aiart_html help
        aiart_publish "$@"

        local task
        for task in pylint pytest test; do
            aiart $task "$@"
        done

        aiart_transform "$@"

        if [ "$(abcli_keyword_is $2 verbose)" == true ]; then
            python3 -m aiart --help
        fi

        return
    fi

    local function_name=aiart_$task
    if [[ $(type -t $function_name) == "function" ]]; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == "init" ]; then
        abcli_init aiart "${@:2}"
        return
    fi

    if [[ "|pylint|pytest|test|" == *"|$task|"* ]]; then
        abcli_${task} plugin=aiart,$2 \
            "${@:3}"
        return
    fi

    if [ "$task" == "version" ]; then
        python3 -m aiart version "${@:2}"
        return
    fi

    abcli_log_error "-aiart: $task: command not found."
}

abcli_source_path \
    $abcli_path_git/aiart/.abcli/tests
