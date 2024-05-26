#! /usr/bin/env bash

abcli_source_path \
    $abcli_path_git/aiart/.abcli/tests

abcli_log $(aiart version --show_icon 1)
