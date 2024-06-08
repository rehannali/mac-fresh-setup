#!/bin/bash
# Setup script for setting up a new macos machine

# SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILE_PATH=${SCRIPT_DIR}/dot-config
source "${SCRIPT_DIR}/helpers/utils.sh"
source "${SCRIPT_DIR}/helpers/pre-setup.sh"
source "${SCRIPT_DIR}/helpers/homebrew-setup.sh"
source "${SCRIPT_DIR}/helpers/sdkman-setup.sh"
source "${SCRIPT_DIR}/helpers/ruby-setup.sh"
source "${SCRIPT_DIR}/helpers/additional-setup.sh"
source "${SCRIPT_DIR}/helpers/omz-setup.sh"
source "${SCRIPT_DIR}/helpers/flutter-setup.sh"

trap 'cleanup $?' EXIT HUP INT TERM

info "Starting setup script"

USER=${USER:-$(id -u -n)}
HOME="${HOME:-$(eval echo ~$USER)}"

presetup_execution

process_homebrew_setup

check_command "git"
check_command "rsync"
check_command "curl"
check_command "pyenv"

sdkman_setup

ruby_setup

node_setup

python_setup

omz_setup

configure_dotfiles

configure_iterm

install_flutter

ZSH=$(command -v zsh)

check_and_add_zsh_to_shells
change_shell_to_zsh

if [[ $? -ne 0 ]]; then
  	error "Shell change failed. Please check the error messages above and fix manually."
  	exit 1
fi

info "Cleaning up..."

if [[ -d "${HOME}/~" ]]; then
	rm -rf "${HOME}/~"
fi

info "Macbook setup completed!"

exit 0
