function process_homebrew_setup {
    brew_update_and_upgrade
    process_brew_files
    cleanup_after_brew_files
}


# Update homebrew recipes

function brew_update_and_upgrade {
    info "Updating brew using update && upgrade"
    run brew update && run brew upgrade
}


function process_brew_files {
    info "Preconfigure Brew tap and initial config"
    run brew bundle -v install --file ${SCRIPT_DIR}/PreBrewfile
    
    info "Accept xcode license to continue"
    run sudo xcodebuild -license accept
    
    info "Executing Brewfile - CLI"
    run brew bundle -v install --file ${SCRIPT_DIR}/BrewfileCli
    
    info "Executing Brewfile - CASK"
    run brew bundle -v install --file ${SCRIPT_DIR}/BrewfileCask
    
    info "Executing Brewfile - APPSTORE"
    run brew bundle -v install --file ${SCRIPT_DIR}/BrewfileAppStore
    
    info "Appstore apps upgrade"
    run mas upgrade
}

function cleanup_after_brew_files {
    info "Brew Cleaning up..."
    run brew cleanup && rm -rf $(brew --cache)
}