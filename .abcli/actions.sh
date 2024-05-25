#! /usr/bin/env bash

function aiart_action_git_before_push() {
    aiart pypi build
}
