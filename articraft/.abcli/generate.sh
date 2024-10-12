#! /usr/bin/env bash

export AIART_GENERATOR_LIST="blue_stability|DALL-E|openai_commands"
export AIART_DEFAULT_GENERATOR="DALL-E"

function aiart_generate() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        local options=$2

        aiart_generate_image $task,$options
        aiart_generate_video $task,$options
        aiart_generate_validate $task,$options

        return
    fi

    local function_name="aiart_generate_$1"
    if [[ $(type -t $function_name) == "function" ]]; then
        $function_name "${@:2}"
        return
    fi

    abcli_log_error "-aiart: generate: $task: command not found."
    return 1
}

abcli_source_caller_suffix_path /generate
