#!/usr/bin/env zsh

# Create zsh profile if it doesnt exist
if [ ! -f "$HOME/.zshrc" ]; then
    touch $HOME/.zshrc
fi

BREW_INSTALLED="$(which brew)"

if echo $BREW_INSTALLED | grep -q "brew not found"; then
    # Install Brew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    source $HOME/.zshrc
fi

NVM_IN_PROFILE="$(grep -c "nvm" $HOME/.zshrc)"

if [[ $NVM_IN_PROFILE == 0 ]]; then

    NVM_INSTALLED="$(brew ls --versions nvm)"

    if [[ -z "${NVM_INSTALLED}" ]]; then

        # Install NVM
        brew install nvm
        if [ ! -d "$HOME/.nvm" ]; then
            mkdir ~/.nvm
        fi

        # Add NVM env variables
        echo -e "\n" >> ~/.zshrc
        echo "export NVM_DIR=~/.nvm" >> ~/.zshrc
        echo 'source $(brew --prefix nvm)/nvm.sh' >> ~/.zshrc

        # Reload zsh profile so we have access to NVM
        source $HOME/.zshrc

        # Install Node
        nvm install node

    fi
fi

npm install
npm run start
