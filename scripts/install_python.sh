#!/usr/bin/env bash

# Bash strict mode
set -euo pipefail

sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa

versions=("3.7" "3.8" "3.9" "3.10")

for version in "${versions[@]}"
do

    echo

    echo "Installing Python $version..."
    echo "==============================="

    echo
    sudo apt install -y python$version
    sudo apt install -y python$version-dev
    sudo apt install -y python$version-venv
    echo
done
