#! /usr/bin/env bash

function ComfyUI_tunnel() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        options="username=<comfier>,password=<password>"
        abcli_show_usage "ComfyUI tunnel$ABCUL$options" \
            "tunnel ComfyUI."
        return
    fi

    conda activate ComfyUI
    [[ $? -ne 0 ]] && return 1

    ngrok config add-authtoken $NGROK_AUTHTOKEN
    [[ $? -ne 0 ]] && return 1

    local password=$(abcli_option "$options" password $(abcli_string_random))
    local username=$(abcli_option "$options" username comfier)

    abcli_log "username: $username, password: $password"
    ngrok http http://localhost:8188 \
        --basic-auth "$username:$password"
}
