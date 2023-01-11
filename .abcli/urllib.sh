#! /usr/bin/env bash

function abcli_quote() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"
}

function abcli_unquote() {
    python3 -c "import urllib.parse; print(urllib.parse.unquote('$1'))"
}