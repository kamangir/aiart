#! /usr/bin/env bash

function aiart_action_git_before_push() {
    [[ "$(abcli_git get_branch)" != "main" ]] &&
        return 0

    aiart pypi build
}
