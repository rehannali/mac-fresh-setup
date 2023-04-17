#!/bin/bash
# Setup script for setting up a new macos machine

echo "Starting setup"

SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/utils.sh"

trap cleanup EXIT HUP INT TERM

USER=${USER:-$(id -u -n)}
HOME="${HOME:-$(eval echo ~$USER)}"

read -n 1 -p "Are you sure you want to install Xcode CLI if not already? <y/N> :" yn

if [[ $yn =~ [yY] ]]; then
	info "Installing Xcode CLI"
	xcode-select --install
fi

linebreak

read -n 1 -p "Are you wish to continue to proceed setup after xcode CLI installation <y/N> :" ans

if [[ ! $ans =~ [yY] ]]; then
	bail "Exiting remaining installation"
fi

linebreak

# Add initial configuration for M1 MacBook's
if [[ $(uname -m) == 'arm64' ]]; then
    info "Configuring Settings for M1 MacBook's"
    export PATH="/opt/homebrew/bin:$PATH"
    cd $SCRIPT_DIR/config
    awk '/usr\/local\/sbin/ { print; print "export PATH=\"\/opt\/homebrew\/bin:$PATH\""; next }1' zshrc > zshrc.new
    rm -f zshrc && mv zshrc.new zshrc
    cd $SCRIPT_DIR
    sudo softwareupdate --install-rosetta --agree-to-license
fi

# Check for Homebrew to be present, install if it's missing
if ! command -v brew &> /dev/null; then
    info "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
info "Updating brew using update && upgrade"
brew update && brew upgrade

info "Preconfigure Brew tap and initial config"
brew bundle -v install --file $SCRIPT_DIR/PreBrewfile

info "Accept xcode license to continue"
sudo xcodebuild -license accept

info "Executing Brewfile - CLI, CASK, APPSTORE"
brew bundle -v install --file $SCRIPT_DIR/PostBrewfile

info "Appstore apps upgrade"
mas upgrade

info "Brew Cleaning up..."
brew cleanup && rm -rf $(brew --cache)

info "Checking is sdkman exists"

if [[ -d "$HOME/.sdkman" ]]; then
	info "Removing SDK Manager directory"
	rm -rf "$HOME/.sdkman"
fi

info "Installing SDK Manager"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

info "Installing Additional Software / Utilities and configuration..."
# SDK Manager
sdk i java 8.0.362-amzn
sdk i java 11.0.18-amzn
sdk i java 17.0.6-amzn
sdk u java 17.0.6-amzn

info "Checking is rvm exists"

if [[ -d "$HOME/.rvm" ]]; then
	info "Removing rvm directory"
	rm -rf "$HOME/.rvm"
fi

info "Installing RVM"
curl -sSL https://get.rvm.io | bash -s stable

# Ruby
export PATH="$PATH:$HOME/.rvm/bin"
source $HOME/.rvm/scripts/rvm
rvm install ruby-2.7
rvm install ruby
rvm use 3.0

info "Installing Cocoapods and keys"

sudo gem install cocoapods
sudo gem install cocoapods-keys

info "Installing NPM modules"

# Node
npm i -g localtunnel
npm i -g firebase-tools

info "Installing python2 for some cases using pyenv"

# Instatalling python2 with pyenv
pyenv install pypy2.7-7.3.6

# Spaceship config
info "Configuring spaceship theme"
mkdir -p $HOME/.config/spaceship

info "Checking if spaceship file is available"
if [[ -f "$HOME/.config/spaceship/spaceship.zsh" ]]; then
    info "spaceship file is available and perform back up."
    mv $HOME/.config/spaceship/spaceship.zsh $HOME/.config/spaceship/spaceship.zsh.bak
fi

info "Copying spaceship file to config directory."
cp -af $SCRIPT_DIR/config/spaceship.zsh $HOME/.config/spaceship/spaceship.zsh

# nvim config
info "Configuring nvim"
mkdir -p $HOME/.config/nvim

git clone https://github.com/rehannali/cpow-dotfiles.git ${SCRIPT_DIR}/cpow-dotfiles

cd $SCRIPT_DIR/cpow-dotfiles

rsync -azhP init.lua $HOME/.config/nvim/
rsync -azhP lua $HOME/.config/nvim/

info "Checking if tmux is available in home directory"
if [[ -f "$HOME/.tmux.conf" ]]; then
    info "Found tmux file in home directory and perform back up."
    mv $HOME/.tmux.conf $HOME/.tmux.conf.bak
fi

cp -af .tmux.conf $HOME/.tmux.conf

cd $SCRIPT_DIR
info "Removing extra config repo folder"
rm -rf $SCRIPT_DIR/cpow-dotfiles

info "Configuring iterm2 aliases and shell integration"
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

info "Installing Flutter"

info "Checking if flutter directory available"
if [[ -d "$HOME/.flutter" ]]; then
	info "Removing flutter directory"
	rm -rf $HOME/.flutter
fi

git clone https://github.com/flutter/flutter.git $HOME/.flutter -b beta
export PATH="$HOME/.flutter/bin:$PATH"

info "Configuring Flutter"
flutter precache

info "Flutter Channel"
flutter channel

info "Installing Oh My ZSH ...."

if [[ -d "$HOME/.oh-my-zsh" ]]; then
	info "Removing old zsh directory before installation."
	rm -rf "$HOME/.oh-my-zsh"
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#echo "Installing PowerLevel10K"
#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Check if the shell change was successful
if [[ $? -ne 0 ]]; then
  error "Unable to install oh-my-zsh."
else
	info "Installing Spaceship theme"
	git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
	ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"

	info "Installing ZSH Syntax Highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

	info "Installing ZSH 256 Color Plougin"
	git clone https://github.com/chrissicool/zsh-256color.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-256color

	info "Installing ZSH Auto Suggestiong plugin"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

	info "Installing ZSH Auto complete plugin"
	git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

	info "Installing fast-syntax-highlighting"
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
fi

info "Macbook setup completed!"

info "Copying configuration file to Home Directory..."
files="hyper.js p10k.zsh zshrc"

for file in ${files}; do
    info "Checking is $file exists"
    if [[ -f "$HOME/.${file}" ]]; then
			info "Found: $file -- Backing up $file..."
      mv "$HOME/.${file}" "$HOME/.${file}.bak"
    fi
    info "Copying $file to home directory from $SCRIPT_DIR/config directory."
    cp -af "$SCRIPT_DIR/config/${file}" "$HOME/.${file}"
done

source $HOME/.zshrc

info "Flutter Doctor"
flutter doctor -v

ZSH=$(command -v zsh)

info "Checking shell entry in /etc/shells for $ZSH..."

ans=$(cat /etc/shells | grep -c $ZSH)

if [[ $ans -ne 0 ]]; then
	info "Adding shell entry to /etc/shells for $ZSH..."
	echo "$ZSH" | sudo tee -a /etc/shells
fi

info "Changing your shell to $ZSH..."

chsh -s "$ZSH" "$USER"

# Check if the shell change was successful
if [[ $? -ne 0 ]]; then
  error "chsh command unsuccessful. Change your default shell manually."
else
  export SHELL="$ZSH"
  info "Shell successfully changed to '$ZSH'"
fi

info "Cleaning up..."

if [[ -d "$HOME/~" ]]; then
	rm -rf "$HOME/~"
fi
