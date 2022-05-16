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
if [[ "${BREW_INSTALLED}" == 'false' ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    source $HOME/.zshrc
fi

JQ_INSTALLED=$(checkInstalled "jq")
if [[ "${JQ_INSTALLED}" == 'false' ]]; then
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

source $HOME/.zshrc
jq '.postCommandsToRun[]' configuration.json |
    while read -r COMMAND; do

        COMMAND_NO_QUOTES="${COMMAND%\"}"
        COMMAND_NO_QUOTES="${COMMAND_NO_QUOTES#\"}"

        $COMMAND_NO_QUOTES

    done

brew install git
source $HOME/.zshrc

GIT_PATH=$(jq -r '.gitRepoPath' configuration.json)

jq '.gitRepos[]' configuration.json |
    while read -r GIT_REPO; do

        GIT_REPO_NO_QUOTES="${GIT_REPO%\"}"
        GIT_REPO_NO_QUOTES="${GIT_REPO_NO_QUOTES#\"}"

        LEAF=$(basename "$GIT_REPO_NO_QUOTES")
        REPO_NAME=$(sed 's/.git//g' <<<"$LEAF")

        if [[ $GIT_PATH == 'null' ]]; then
            git clone $GIT_REPO_NO_QUOTES
        else
            PATH_TO_CLONE_REPO=${GIT_PATH}/${REPO_NAME}
            git clone $GIT_REPO_NO_QUOTES $PATH_TO_CLONE_REPO
        fi

    done

VSCODE_INSTALLED=$(checkInstalled "code")

if [[ "${VSCODE_INSTALLED}" == 'false' ]]; then
    exit
fi

jq '.vsCodeExtensions[]' configuration.json |
    while read -r EXTENSION; do

        EXTENSION_NO_QUOTES="${EXTENSION%\"}"
        EXTENSION_NO_QUOTES="${EXTENSION_NO_QUOTES#\"}"

        code --install-extension $EXTENSION_NO_QUOTES

    done
