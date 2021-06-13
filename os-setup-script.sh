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
sdk i java 8.0.252.hs-adpt
sdk i java 11.0.7.hs-adpt
sdk i java 14.0.1.hs-adpt
sdk i java 15.0.0.hs-adpt
sdk u java 8.0.252.hs-adpt
# Ruby
rvm install ruby-head
rvm install ruby-2.6.5
rvm use 2.7.0
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

echo "Installing Flutter"
git clone https://github.com/flutter/flutter.git ~/.flutter -b beta

echo "Copying configuration file to Home Directory..."
files="gitconfig hyper.js p10k.zsh zsh_history zshrc"

for file in ${files}; do
    echo "Copying $file in home directory."
    cp -af ./config/.${file} ~/.${file}
done

source ~/.zshrc

echo "Configuring Flutter"
flutter precache

echo "Macbook setup completed!"
