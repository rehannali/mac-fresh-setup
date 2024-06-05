

function install_flutter {
    info "Installing Flutter"

    info "Checking if flutter directory available"
    if [[ -d "${HOME}/.flutter" ]]; then
    	info "Removing flutter directory"
    	run rm -rf ${HOME}/.flutter
    fi

    run git clone https://github.com/flutter/flutter.git ${HOME}/.flutter -b beta
    run export PATH="${HOME}/.flutter/bin:$PATH"

    info "Configuring Flutter"
    run flutter precache

    info "Flutter Channel"
    run flutter channel
}

function flutter_doctor {
    info "Flutter Doctor"
    run flutter doctor -v
}