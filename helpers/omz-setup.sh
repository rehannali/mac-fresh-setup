function omz_setup {
    # Install Oh My Zsh
    info "Installing Oh My ZSH ...."

    if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    	info "Removing old zsh directory before installation."
    	run sudo rm -rf "${HOME}/.oh-my-zsh"
    fi

    run sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Check if the shell change was successful
    if [[ $? -ne 0 ]]; then
        error "Unable to install oh-my-zsh."
    else 
        omz_theme_setup
        omz_theme_configuration
    fi
}

function omz_theme_setup {
    #echo "Installing PowerLevel10K"
    #git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k

    info "Installing Spaceship theme"
    run git clone https://github.com/spaceship-prompt/spaceship-prompt.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
    run ln -s "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"

    info "Installing ZSH Syntax Highlighting"
    run git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    
    info "Installing ZSH 256 Color Plougin"
    run git clone https://github.com/chrissicool/zsh-256color.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-256color
    
    info "Installing ZSH Auto Suggestiong plugin"
    run git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    
    info "Installing ZSH Auto complete plugin"
    run git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autocomplete
    
    info "Installing fast-syntax-highlighting"
    run git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    
    info "Configuring Poetry"
    run mkdir -p $ZSH_CUSTOM/plugins/poetry
    run poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
}

function omz_theme_configuration {
    # Spaceship config
    info "Configuring spaceship theme"
    run mkdir -p ${HOME}/.config/spaceship

    info "Checking if spaceship file is available"
    if [[ -f "${HOME}/.config/spaceship/spaceship.zsh" ]]; then
        info "spaceship file is available and perform back up."
        timestamp=$(date +%Y%m%d)
        run mv ${HOME}/.config/spaceship/spaceship.zsh ${HOME}/.config/spaceship/spaceship.zsh.bak.${timestamp}
    fi

    info "Copying spaceship file to config directory."
    run cp -af ${SCRIPT_DIR}/config/spaceship.zsh ${HOME}/.config/spaceship/spaceship.zsh
}