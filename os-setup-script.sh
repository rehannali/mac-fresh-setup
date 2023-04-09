#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "Starting setup"

# install xcode CLI
sudo xcode-select —-install

# Add initial configuration for M1 MacBook's
if [[ $(uname -m) == 'arm64' ]]; then
    echo "Configuring Settings for M1 MacBook's"
    export PATH="/opt/homebrew/bin:$PATH"
    cd config
    awk '/usr\/local\/sbin/ { print; print "export PATH=\"\/opt\/homebrew\/bin:$PATH\""; next }1' zshrc > zshrc.new
    rm -f zshrc && mv zshrc.new zshrc
    cd ..
    sudo softwareupdate --install-rosetta --agree-to-license
fi

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
sdk i java 8.0.362-amzn
sdk i java 11.0.18-amzn
sdk i java 17.0.6-amzn
sdk u java 17.0.6-amzn
# Ruby

rvm install ruby-2.7
rvm install ruby
rvm use 3.0

sudo gem install cocoapods
sudo gem install cocoapods-keys
# Node
npm i -g localtunnel
npm i -g firebase-tools

# Instatalling python2 with pyenv
pyenv install pypy2.7-7.3.6

# Spaceship config
echo "Configuring spaceship config"
mkdir -p ~/.config/spaceship

echo "Checking if spaceship file is available"
if test -f "~/.config/spaceship/spaceship.zsh"; then
    echo "spaceship file is available and perform back up."
    mv ~/.config/spaceship/spaceship.zsh ~/.config/spaceship/spaceship.zsh.bak
fi

cp -af ./config/spaceship.zsh ~/.config/spaceship/spaceship.zsh

# nvim config
echo "Configuring nvim"
mkdir -p ~/.config/nvim

git clone https://github.com/rehannali/cpow-dotfiles.git

cd cpow-dotfiles

rsync -azhP init.lua ~/.config/nvim/
rsync -azhP lua ~/.config/nvim/

echo "Checking if tmux is available in home directory"
if test -f "~/.tmux.conf"; then
    echo "Found tmux file in home directory and perform back up."
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi

cp -af .tmux.conf ~/.tmux.conf

cd ..
echo "Removing extra config repo folder"
rm -rf cpow-dotfiles

echo "Configuring iterm2 aliases and shell integration"
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

echo "Installing Oh My ZSH ...."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#echo "Installing PowerLevel10K"
#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "Installing Spaceship theme"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo "Installing ZSH Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Installing ZSH 256 Color Plougin"
git clone https://github.com/chrissicool/zsh-256color.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-256color

echo "Installing ZSH Auto Suggestiong plugin"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "Installing ZSH Auto complete plugin"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

echo "Installing fast-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# echo "Installing Flutter"
git clone https://github.com/flutter/flutter.git ~/.flutter -b beta
export PATH="$HOME/.flutter/bin:$PATH"

# echo "Configuring Flutter"
flutter precache

# echo "Flutter Channel"
flutter channel

# echo "Flutter Doctor"
flutter doctor -v

echo "Copying configuration file to Home Directory..."
files="hyper.js p10k.zsh zshrc"

for file in ${files}; do
    echo "perform back up $file if exists"
    if test -f "~/.${file}"; then
        mv ~/.${file} ~/.${file}.bak
    fi
    echo "Copying $file in home directory."
    cp -af ./config/${file} ~/.${file}
done

echo "Macbook setup completed!"
