#!/bin/bash

# Function to check if the script is running as root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    echo "Please run 'sudo $0'"
    exit 1
  fi
}

# Function to get the Ubuntu version and codename
get_version_codename() {
  . /etc/lsb-release
  echo "$DISTRIB_RELEASE $DISTRIB_CODENAME"
}

# Function to check if the Ubuntu version is an LTS release and 14.04 or newer
is_supported_lts_version() {
  local version=$1
  local codename=$2

  # Check if the version is 14.04 or newer
  if dpkg --compare-versions "$version" ge "14.04"; then
    # Check if the codename indicates an LTS release
    case $codename in
      trusty|xenial|bionic|focal|jammy|noble)
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  else
    return 1
  fi
}

# Function to update sources.list
update_sources_list() {
  local codename=$1
  cat <<EOF > /etc/apt/sources.list
deb http://old-releases.ubuntu.com/ubuntu/ $codename main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-security main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-backports main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ $codename-proposed main restricted universe multiverse
EOF
}

# Main script logic
main() {
  check_root

  # Get the Ubuntu version and codename
  read version codename < <(get_version_codename)

  # Check if the version is an LTS release and 14.04 or newer
  if is_supported_lts_version "$version" "$codename"; then
    echo "This script is not needed for Ubuntu 14.04 LTS and newer LTS releases. Exiting."
    exit 0
  fi

  echo "Deleting the old /etc/apt/sources.list"
  rm -f /etc/apt/sources.list

  echo "Creating a new /etc/apt/sources.list"
  update_sources_list $codename

  echo "Updating package list and upgrading the system"
  apt-get update
  apt-get dist-upgrade -y

  echo "Done."
}

# Run the main function
main
