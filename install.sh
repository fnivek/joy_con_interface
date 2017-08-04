#!/bin/bash
#
# This script installs all the required software

# Capture and exit on errors
trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
trap 'exit_val=$? && err "exit ${exit_val} due to $previous_command" && exit "${exit_val}"' ERR

#
# Below are functions for making output look nice
#

# Globals
GOOD_COLOR='\033[1;36m'
ERROR_COLOR='\033[1;31m'
DEBUG_COLOR='\033[1;32m'
WARN_COLOR='\033[1;33m'
NO_COLOR='\033[0m'
INFO_PREFIX="${GOOD_COLOR}INFO [%(%Y-%m-%dT%H:%M:%S%z)T]:"
ERROR_PREFIX="${ERROR_COLOR}ERROR [%(%Y-%m-%dT%H:%M:%S%z)T]:"
DEBUG_PREFIX="${DEBUG_COLOR}DEBUG [%(%Y-%m-%dT%H:%M:%S%z)T]:"
WARN_PREFIX="${WARN_COLOR}WARN [%(%Y-%m-%dT%H:%M:%S%z)T]:"

VERBOSITY=3

################################
# Prints usage
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
################################
default_print_usage() {
  printf "Usage: $0 [options]
    \t-h\t Display this help
    \t-v\t Set verbosity [0: silent, 1: error, 2: warn, 3: info, 4: debug] default 3
    "
  exit 0
}

################################
# Prints errors to stderr
# Globals:
#   None
# Arguments:
#   Error message
# Returns:
#   None
################################
err() {
  if [[ "${VERBOSITY}" -gt 0 ]]; then
    printf "${ERROR_PREFIX} $@ ${NO_COLOR}\n" >&2
  fi
}

################################
# Prints information to stdout
# Globals:
#   VERBOSITY
# Arguments:
#   Message
# Returns:
#   None
################################
info() {
  if [[ "${VERBOSITY}" -gt 2 ]]; then
    printf "${INFO_PREFIX} $@ ${NO_COLOR}\n"
  fi
}

################################
# Prints debug to stdout
# Globals:
#   VERBOSITY
# Arguments:
#   Message
# Returns:
#   None
################################
debug() {
  if [[ "${VERBOSITY}" -gt 3 ]]; then
    printf "${DEBUG_PREFIX} $@ ${NO_COLOR}\n"
  fi
}

################################
# Prints warn to stdout
# Globals:
#   VERBOSITY
# Arguments:
#   Message
# Returns:
#   None
################################
warn() {
  if [[ "${VERBOSITY}" -gt 1 ]]; then
    printf "${WARN_PREFIX} $@ ${NO_COLOR}\n"
  fi
}

################################
# Default command line parser
# Globals:
#   VERBOSITY
# Arguments:
#   $@
# Returns:
#   None
################################
default_cmd_line_parse() {
  while getopts ':v:' flag; do
    case "${flag}" in
      v) VERBOSITY="${OPTARG}" ;;
      *) default_print_usage ;;
    esac
  done
}


#
# This is where the installation begins
#

# Handle command line arguments
default_cmd_line_parse "$@"

# Install script dependencies
info "Installing script dependencies (pip, wget)"
debug 'sudo apt update -qq'
sudo apt update -qq
debug "Installing wget"
sudo apt install -y wget &> /dev/null

# First install pip
debug "Installing pip"
# Download pip install script
get_pip="$(mktemp)"
if ! wget -q -O ${get_pip} https://bootstrap.pypa.io/get-pip.py; then
  err "Can't download get-pip.py from https://bootstrap.pypa.io/get-pip.py please check internet connection"
  exit 1
fi
# Install pip
sudo -H python "${get_pip}" &> /dev/null
if ! [[ "$?" ]]; then
  err "Failed to install pip"
  exit 1
fi
debug "pip installed"


# Install python bluetooth module
info "Installing pyBluez"
debug "Installing libbluetooth-dev"
sudo apt install -y libbluetooth-dev &> /dev/null
debug "Installing pyBluez with pip"
if ! sudo -H python -m pip install pyBluez &> /dev/null; then
  err "Failed to install pyBluez"
fi

# Complete
info "Installation succesfully completed"
exit 0
