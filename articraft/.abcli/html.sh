#! /usr/bin/env bash

function aiart_html() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ "$task" == "help" ]; then
        aiart_html ingest_url help
        return
    fi

    if [ "$task" == "ingest_url" ]; then
        local url=$2
        if [[ "$url" == help ]]; then
            local args="[--fake_agent 1]$ABCUL[--verbose 1]"
            abcli_show_usage "aiart html ingest_url$ABCUL<url>$ABCUL$args" \
                "ingest <url>."
            return
        fi

        python3 -m articraft.html \
            ingest_url \
            --url "$url" \
            "${@:3}"
        return
    fi

    abcli_log_error "-abcli: html: $task: command not found."
    return 1
}
