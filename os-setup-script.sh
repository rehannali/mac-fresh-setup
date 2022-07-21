#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "Starting setup"

# install xcode CLI
xcode-select —-install

# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
echo "Updating brew using update && upgrade"
brew update && brew upgrade

echo "Executing Brewfile - CLI, CASK, APPSTORE"
brew bundle -v install

echo "Appstore apps upgrade"
mas upgrade

echo "Cleaning up..."
brew cleanup && rm -rf $(brew --cache)

echo "Installing SDK Manager"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "Installing RVM"
curl -sSL https://get.rvm.io | bash -s stable

echo "Installing Additional Software / Utilities and configuration..."
# SDK Manager
sdk i java 8.0.292.hs-adpt
sdk i java 11.0.11.hs-adpt
sdk i java 16.0.1-open
sdk u java 11.0.11.hs-adpt
# Ruby

rvm install ruby-2.6
rvm install ruby-2.7
rvm use 2.7

sudo gem install cocoapods
sudo gem install cocoapods-keys
# Node
npm i -g localtunnel
npm i -g firebase-tools

echo "Installing Oh My ZSH ...."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Changing Shell..."
chsh -s /usr/local/bin/zsh

echo "Installing PowerLevel10K"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Installing ZSH Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing ZSH 256 Color Plougin"
git clone https://github.com/chrissicool/zsh-256color.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-256color

echo "Installing ZSH Auto Suggestiong plugin"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


# echo "Installing Flutter"
# git clone https://github.com/flutter/flutter.git ~/.flutter -b beta
# export PATH="$HOME/.flutter/bin:$PATH"

# echo "Configuring Flutter"
# flutter precache

# echo "Flutter Channel"
# flutter channel

# echo "Flutter Doctor"
# flutter doctor -v

echo "Copying configuration file to Home Directory..."
files="gitconfig hyper.js p10k.zsh zsh_history zshrc"

for file in ${files}; do
    echo "Removing $file if exists"
    if test -f "~/.${file}" then
        rm -f ~/.${file}
    fi
    echo "Copying $file in home directory."
    cp -af ./config/.${file} ~/.${file}
done

echo "Macbook setup completed!"
