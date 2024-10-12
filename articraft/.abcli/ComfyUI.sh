#! /usr/bin/env bash

# https://medium.com/@dminhk/3-easy-steps-to-run-comfyui-on-amazon-sagemaker-notebook-c9bdb226c15e
function ComfyUI() {
    local task=$1

    if [[ "$task" == "help" ]]; then
        ComfyUI_install "$@"
        ComfyUI_start "$@"
        ComfyUI_tunnel "$@"
        ComfyUI_uninstall "$@"
        return
    fi

    local function_name=ComfyUI_$task
    if [[ $(type -t $function_name) == "function" ]]; then
        $function_name "${@:2}"
        return
    fi

    python3 -m articraft.ComfyUI "$@"

}

abcli_source_caller_suffix_path /ComfyUI
