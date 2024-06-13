
function node_setup {
    info "Installing NPM modules"

    # Node
    run npm i -g localtunnel
    run npm i -g firebase-tools
}

function python_setup {
    info "Installing python2 for some cases using pyenv"

    # Instatalling python2 with pyenv
    run pyenv install pypy2.7-7.3.6
}

function configure_iterm {
    info "Configuring iterm2 aliases and shell integration"
    run curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
}

function configure_dotfiles {
    # nvim config
    info "Configuring nvim"
    run mkdir -p ${HOME}/.config/nvim

    run git clone https://github.com/rehannali/cpow-dotfiles.git ${SCRIPT_DIR}/cpow-dotfiles

    run cd ${SCRIPT_DIR}/cpow-dotfiles

    run rsync -azhP init.lua ${HOME}/.config/nvim/
    run rsync -azhP lua ${HOME}/.config/nvim/

    info "Checking if tmux is available in home directory"
    timestamp=$(date +%Y%m%d)
    if [[ -f "${HOME}/.tmux.conf" ]]; then
        info "Found tmux file in home directory and perform back up."
        run mv ${HOME}/.tmux.conf ${HOME}/.tmux.conf.bak.${timestamp}
    fi

    run cp -af .tmux.conf ${HOME}/.tmux.conf
    run git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

    cd ${SCRIPT_DIR}
    info "Removing extra config repo folder"
    run rm -rf ${SCRIPT_DIR}/cpow-dotfiles
}

# Function to check if Zsh is in /etc/shells
check_and_add_zsh_to_shells() {
    if ! grep -q "$ZSH" /etc/shells; then
        info "Adding shell entry to /etc/shells for $ZSH..."
        run echo "$ZSH" | sudo tee -a /etc/shells || {
            error "Failed to add $ZSH to /etc/shells. Ensure you have sudo access and try again."
            return 1
        }
    fi
}

# Function to change the shell and handle errors
change_shell_to_zsh() {
    if chsh -s "$ZSH" "$USER"; then
        export SHELL="$ZSH"
        info "Shell successfully changed to '$ZSH'"
        return 0
    else
        error "chsh command failed. Change your default shell manually."
        return 1
    fi
}

function place_configuration_files {
    info "Copying configuration file to Home Directory..."
    files="hyper.js p10k.zsh zshrc zshenv gitignore_global gitconfig"
    timestamp=$(date +%Y%m%d)

    for file in ${files}; do
        info "Checking is $file exists"
        if [[ -f "${HOME}/.${file}" ]]; then
    		info "Found: $file -- Backing up $file..."
            run mv "${HOME}/.${file}" "${HOME}/.${file}.bak.${timestamp}"
        fi
        info "Copying $file to home directory from ${SCRIPT_DIR}/config directory."
        run cp -af "${SCRIPT_DIR}/config/${file}" "${HOME}/.${file}"
    done

    run mkdir -p ${HOME}/.config

    run rsync -azhP ${SCRIPT_DIR}/config/.zsh ${HOME}/
    run rsync -azhP ${SCRIPT_DIR}/config/neofetch ${HOME}/.config/

    alacritty_setup

    source ${HOME}/.zshrc

    flutter_doctor
}

function alacritty_setup {
    info "Configuring Alacritty ..."
    run mkdir -p ${HOME}/.config/alacritty/themes
    run cp -af ${SCRIPT_DIR}/config/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml

    run git clone https://github.com/alacritty/alacritty-theme ${HOME}/.config/alacritty/themes

}
