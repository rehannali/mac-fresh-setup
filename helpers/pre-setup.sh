function presetup_execution {
    install_xcode_cli
    check_if_you_want_to_continue
    install_homebrew
}


function install_xcode_cli {
    read -n 1 -p "Are you sure you want to install Xcode CLI if not already? <y/N> :" yn

    if [[ ${yn} =~ [yY] ]]; then
        info "Installing Xcode CLI"
        run xcode-select --install
    fi

    linebreak
}

function check_if_you_want_to_continue {
    read -n 1 -p "Are you wish to continue to proceed setup after xcode CLI installation <y/N> :" ans

    if [[ ! ${ans} =~ [yY] ]]; then
        bail "Exiting remaining installation"
    fi

    linebreak

    # Add initial configuration for M1 MacBook's
    if [[ $(uname -m) == 'arm64' ]]; then
        info "Configuring Settings for M1 MacBook's"
        run export PATH="/opt/homebrew/bin:$PATH"
        run sudo softwareupdate --install-rosetta --agree-to-license
    fi
}

function install_homebrew {
    # Check for Homebrew to be present, install if it's missing
    if ! command -v brew &> /dev/null; then
        info "Installing homebrew..."
        run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi
}