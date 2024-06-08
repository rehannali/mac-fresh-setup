
function sdkman_setup {
    info "Checking is sdkman exists"

    if [[ -d "${HOME}/.sdkman" ]]; then
        info "Removing SDK Manager directory"
        run rm -rf "${HOME}/.sdkman"
    fi

    info "Installing SDK Manager"
    run curl -s "https://get.sdkman.io" | bash
    run source "${HOME}/.sdkman/bin/sdkman-init.sh"n

    info "Installing Additional Software / Utilities and configuration..."
    # SDK Manager

    # To ignore versions in setup use | grep -Ev '^(8|11|17)\.' will skip 8,11,17 as major versions
    info "Fetching all required java versions"
    versions=$(sdk ls java | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+-amzn' | sort -t'.' -k1,1nr -k2,2nr -k3,3nr | awk -F. '$1<=22 && !seen[$1]++')

    for version in $versions; do
        info "Installing Java version: $version"
        run sdk install java $version
        if [ $? -ne 0 ]; then
            error "Failed to install $version. Skipping..."
        fi
    done

    latest_stable=$(echo $versions | sort -V | tail -n 1)
    run sdk u java $latest_stable
}