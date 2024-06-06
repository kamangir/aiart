#! /usr/bin/env bash

function ComfyUI_uninstall() {
    local task=$1

    if [[ "$task" == "help" ]]; then
        abcli_show_usage "ComfyUI uninstall" \
            "uninstall ComfyUI."
        return
    fi

    rm -rfv $abcli_path_git/ComfyUI

    abcli_conda rm ComfyUI
}
