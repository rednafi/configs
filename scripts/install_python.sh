#!/usr/bin/env bash

# Bash strict mode
set -euo pipefail

# Log color.
green="\033[0;32m"
clear="\033[0m"

# Python versions to install.
versions=("3.7" "3.8" "3.9" "3.10")


# Add deadsnake ppa.
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa

# Install Python.
for version in "${versions[@]}"
do

    echo

    printf "${green}Installing Python $version...${clear}\n"
    printf "${green}=============================${clear}\n"

    echo
    sudo apt install -y python$version python$version-dev python$version-venv
    echo
done

## Install build dependencies.
printf "${green}Installing Python build dependencies...${clear}\n"
printf "${green}=======================================${clear}\n"
echo
sudo apt install build-essential
echo