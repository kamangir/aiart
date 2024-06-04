#! /usr/bin/env bash

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

        aiart_transform "$@"

        ComfyUI "$@"

        return
    fi

    abcli_generic_task \
        plugin=aiart,task=$task \
        "${@:2}"
}

abcli_log $(aiart version --show_icon 1)
