#! /usr/bin/env bash

function ComfyUI_start() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        options="install"
        abcli_show_usage "ComfyUI start$ABCUL[$options]" \
            "start ComfyUI."
        return
    fi

    if [[ "$abcli_is_sagemaker_system" == true ]]; then
        abcli_log_warning "image terminal command."
        return 1
    fi

    local do_install=$(abcli_option_int "$options" install 0)

    [[ $do_install == 1 ]] &&
        ComfyUI_install "$options"

    conda activate ComfyUI
    [[ $? -ne 0 ]] && return 1

    abcli_eval path=$abcli_path_git/ComfyUI \
        python3 main.py
}
