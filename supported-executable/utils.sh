
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
	exit_code=$?
	if [[ $exit_code -ne 0 ]]; then
        bail "Exiting remaining setup due to error. (Exit code: $exit_code)"
    else
        info "Setup completed successfully!" 
    fi
}

function linebreak {
	print "\n"
}

function print {
    echo -e "\n$@"
}

function check_command {
    command -v "$1" &> /dev/null || bail "Unable to find $1, please install it and run this script again"
}

# Log then execute the provided command
function run {
	local cmdline=
		for arg in "$@"; do
			case "${arg}" in
				*\ * | *\"*)
					cmdline="${cmdline} '${arg}'"
					;;
				*)
					cmdline="${cmdline} ${arg}"
					;;
			esac
		done
		info "Running${cmdline}" 1>&2
	"$@"
}