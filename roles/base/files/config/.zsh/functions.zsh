# Colormap
function colormap() {
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

locate_chrome() {
    for path in "$HOME/Applications" /Applications; do
        if command -v "$path/Google Chrome.app/Contents/MacOS/Google Chrome" >/dev/null 2>&1; then
            echo "$path/Google Chrome.app/Contents/MacOS/Google Chrome"
            return
        fi
    done
    echo "Warning: Google Chrome executable not found in standard locations."
    return 1
}