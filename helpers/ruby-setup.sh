function ruby_setup  {
    # rvm_setup
    rbenv_setup
    ruby_dependencies
}

function rvm_setup {
    info "Checking is rvm exists"

    if [[ -d "${HOME}/.rvm" ]]; then
    	info "Removing rvm directory"
    	run sudo rm -rf "${HOME}/.rvm"
    fi

    info "Installing RVM"
    curl -sSL https://get.rvm.io | bash -s stable

    # Ruby
    run export PATH="$PATH:${HOME}/.rvm/bin"
    run source ${HOME}/.rvm/scripts/rvm
    run rvm install ruby-2.7
    run rvm install ruby
    run rvm use system
}

function rbenv_setup {
    info "Checking is rbenv exists"

    if [[ -d "${HOME}/.rbenv" ]]; then
    	info "Removing rbenv directory"
    	run rm -rf "${HOME}/.rbenv"
    fi

    if [[ ! "$PATH" =~ "$HOME/.rbenv/bin" ]]; then
        run export PATH="$HOME/.rbenv/bin:$PATH"
    fi

    latest_ruby_version=$(rbenv install -l | grep -E '^(\d+\.\d+\.\d+)$' | sort -V | tail -n 1)

    run rbenv install $latest_ruby_version
    run rbenv global $latest_ruby_version
}

function ruby_dependencies {
    run sudo gem install cocoapods
    run sudo gem install cocoapods-keys
    run gem install cocoapods
    run gem install cocoapods-keys
}