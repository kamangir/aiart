#! /usr/bin/env bash

function ComfyUI_tunnel() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        options="${EOP}username=<comfier>,password=<$COMFYUI_PASSWORD>$EOPE"
        abcli_show_usage "ComfyUI tunnel$ABCUL$options" \
            "tunnel ComfyUI."
        return
    fi

    if [[ "$abcli_is_sagemaker_system" == true ]]; then
        abcli_log_warning "image terminal command."
        return 1
    fi

    conda activate ComfyUI
    [[ $? -ne 0 ]] && return 1

    ngrok config add-authtoken $NGROK_AUTHTOKEN
    [[ $? -ne 0 ]] && return 1

    local password=$(abcli_option "$options" password $COMFYUI_PASSWORD)
    local username=$(abcli_option "$options" username comfier)

    ngrok http http://localhost:8188 \
        --basic-auth "$username:$password"
}
