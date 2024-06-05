#!/bin/bash
# Setup script for setting up a new macos machine

echo "Starting setup"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${SCRIPT_DIR}/supported-executable/utils.sh"
source "${SCRIPT_DIR}/supported-executable/pre-setup.sh"
source "${SCRIPT_DIR}/supported-executable/homebrew-installation.sh"
source "${SCRIPT_DIR}/supported-executable/sdkman-setup.sh"
source "${SCRIPT_DIR}/supported-executable/ruby-setup.sh"
source "${SCRIPT_DIR}/supported-executable/additional-setup.sh"
source "${SCRIPT_DIR}/supported-executable/omz-setup.sh"
source "${SCRIPT_DIR}/supported-executable/flutter-setup.sh"

trap 'cleanup $?' EXIT HUP INT TERM

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
	run rm -rf "${HOME}/~"
fi

info "Macbook setup completed!"

exit 0