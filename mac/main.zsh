#!/usr/bin/env zsh

function checkInstalled() {

    local BREW_INSTALLED="$(which $1)"

    if echo $BREW_INSTALLED | grep -q "$1 not found"; then
        echo false
    else
        echo true
    fi

}

BREW_INSTALLED=$(checkInstalled "brew")
if echo $BREW_INSTALLED | grep -q "brew not found"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    source $HOME/.zshrc
fi

JQ_INSTALLED=$(checkInstalled "jq")
if [[ -z "${JQ_INSTALLED}" ]]; then
    brew install jq
    source $HOME/.zshrc
fi

jq '.preCommandsToRun[]' configuration.json |
    while read -r COMMAND; do

        COMMAND_NO_QUOTES="${COMMAND%\"}"
        COMMAND_NO_QUOTES="${COMMAND_NO_QUOTES#\"}"

        $COMMAND_NO_QUOTES

    done

SOFTWARE_LIST="configuration.json"
jq -c '.softwareToInstall[]' <$SOFTWARE_LIST |
    while read -r SOFTWARE; do

        SOFTWARE_NAME=$(jq -r '.name' <<<"$SOFTWARE")
        VERSION=$(jq -r '.version' <<<"$SOFTWARE")

        if [[ -z $VERSION || "$VERSION" == "null" ]]; then
            brew install $SOFTWARE_NAME
        else
            brew install ${SOFTWARE_NAME}@${VERSION}
        fi

    done

jq '.postCommandsToRun[]' configuration.json |
    while read -r COMMAND; do

        COMMAND_NO_QUOTES="${COMMAND%\"}"
        COMMAND_NO_QUOTES="${COMMAND_NO_QUOTES#\"}"

        $COMMAND_NO_QUOTES

    done
