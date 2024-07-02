function presetup_execution {
    install_xcode_cli
    check_if_you_want_to_continue
    install_homebrew
    setup_ansible
}


function install_xcode_cli {
    if [[ ! $(xcode-select -p 2>/dev/null) ]]; then
        info "Installing Xcode CLI..."
        run xcode-select --install
        # Wait for Xcode CLI to be installed
        until xcode-select -p &>/dev/null; do
            info "Waiting for Xcode CLI to install..."
            sleep 5
        done
    else
        info "Xcode CLI is already installed."
    fi
}

function check_if_you_want_to_continue {
    # Add initial configuration for M1 MacBook's
    if [[ $(uname -m) == 'arm64' ]]; then
        info "Configuring Settings for M1 MacBook's"
        run export PATH="/opt/homebrew/bin:$PATH"
        if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
            info "Installing Rosetta 2..."
            run sudo softwareupdate --install-rosetta --agree-to-license
        else
            info "Rosetta 2 is already installed."
        fi
    fi
}

function install_homebrew {
    # Check for Homebrew to be present, install if it's missing
    if ! command -v brew &> /dev/null; then
        info "Installing homebrew..."
        run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        info "Homebrew is already installed."
    fi
}

function setup_ansible {
    if ! command -v ansible &> /dev/null; then
        info "Installing Ansible..."
        brew install ansible
    else
        info "Ansible is already installed."
    fi
}