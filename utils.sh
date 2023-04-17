
function bail {
	error "$*"
	exit 99
}

function error {
	print "ERROR: $* \n" 1>&2
}

function info {
	print "INFO: $* \n"
}

function cleanup {
	bail "Exiting remaining setup. Found Trap to exit installation."
}

function linebreak {
	print "\n"
}

function print {
    echo -e "\n$@"
}
