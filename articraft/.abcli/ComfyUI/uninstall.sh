#! /usr/bin/env bash

function ComfyUI_uninstall() {
    local task=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        abcli_show_usage "ComfyUI uninstall" \
            "uninstall ComfyUI."
        return
    fi

    rm -rfv $abcli_path_git/ComfyUI

    abcli_conda rm ComfyUI
}
