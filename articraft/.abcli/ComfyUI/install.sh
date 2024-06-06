#! /usr/bin/env bash

function ComfyUI_install() {
    local task=$1

    if [[ "$task" == "help" ]]; then
        abcli_show_usage "ComfyUI install" \
            "install ComfyUI."
        return
    fi

    abcli_git_clone https://github.com/comfyanonymous/ComfyUI

    abcli_conda_create \
        ~install_plugin,name=ComfyUI,~recreate

    abcli_plugins install aiart

    pushd $abcli_path_git/ComfyUI >/dev/null

    pip3 install -r requirements.txt

    # https://github.com/ltdrdata/ComfyUI-Manager
    cd custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git

    popd >/dev/null
}
