#! /usr/bin/env bash

function ComfyUI() {
    local options=$1

    if [ $(abcli_option_int "$options" help 0) == 1 ]; then
        options="install,start"
        abcli_show_usage "ComfyUI $options" \
            "start ComfyUI."
        return
    fi

    local do_install=$(abcli_option_int "$options" install 0)
    if [ $do_install == 1 ]; then
        abcli_git_clone https://github.com/comfyanonymous/ComfyUI
        abcli_conda_create \
            ~install_plugin,name=ComfyUI,~recreate
        pushd $abcli_path_git/ComfyUI >/dev/null
        pip3 install -r requirements.txt
        popd >/dev/null
    fi

    conda activate ComfyUI
    [[ $? -ne 0 ]] && return 1

    abcli_log "🪄"
}
