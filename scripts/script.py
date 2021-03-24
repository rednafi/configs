#!/usr/bin/env python3.8

import subprocess
import os

PASSWORD = os.getenv("PASSWORD")


class Tools:
    @staticmethod
    def run_shell(cmd):
        subprocess.run(cmd, shell=True, check=True, text=True, executable="/bin/bash")

    @staticmethod
    def print_color(text):
        print(text)


t = Tools()


def update_packages():
    t.run_shell(
        f"""
    echo
    echo "Updating native packages..."
    echo "==========================="

    echo

    echo {PASSWORD} |   sudo -S apt update
    echo {PASSWORD} |   sudo -S apt upgrade
    echo {PASSWORD} |   sudo -S apt autoremove
    echo {PASSWORD} |   sudo -S apt autoclean

    echo

    """
    )


def install_python(versions=("3.7", "3.8", "3.9", "3.10")):
    t.run_shell(
        f"""
    echo {PASSWORD} | sudo -S apt -y install software-properties-common
    echo {PASSWORD} | sudo -S add-apt-repository -y ppa:deadsnakes/ppa
    """
    )
    for version in versions:
        t.run_shell(
            f"""
        echo

        echo "Installing Python {version}..."
        echo "==============================="

        echo
        echo {PASSWORD} | sudo -S apt install -y python{version}
        echo {PASSWORD} | sudo -S apt install -y python{version}-dev
        echo {PASSWORD} | sudo -S apt install -y python{version}-venv
        echo
    """
        )


def install_docker():
    t.run_shell(
        f"""

    echo "Installing docker..."
    echo "===================="

    echo
    # Uninstall old version.
    echo {PASSWORD} | sudo -S apt-get remove docker docker-engine docker.io containerd runc

    # Install packages to allow apt to use a repository over HTTPS.
    echo {PASSWORD} | sudo -s apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    # Add Docker’s official GPG key.
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | echo {PASSWORD }| \
    sudo -S apt-key add -

    # Verify fingerprint.
    echo {PASSWORD} | sudo -S apt-key fingerprint 0EBFCD88
    echo {PASSWORD} | sudo -S add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    # Install docker ce.
    echo {PASSWORD} | sudo -S apt-get install docker-ce docker-ce-cli containerd.io

    # Run hello world.
    echo {PASSWORD} | sudo -S docker run hello-world

    # Install docker-compose.
    echo {PASSWORD} | sudo -S curl -L \
        "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    echo {PASSWORD} | sudo -S chmod +x /usr/local/bin/docker-compose
    echo {PASSWORD} | sudo -S ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    docker-compose --version


    # Post installation (running docker as non-root).
    echo {PASSWORD} | sudo -S groupadd docker
    echo {PASSWORD} | sudo -S usermod -aG docker $USER
    newgrp docker
    docker run hello-world
    echo {PASSWORD} | sudo -S chown "$USER":"$USER" /home/"$USER"/.docker -R
    echo {PASSWORD} | sudo -S chmod g+rwx "$HOME/.docker" -R
    echo {PASSWORD} | sudo -S systemctl enable docker
    echo {PASSWORD} | sudo -S systemctl restart docker
    echo
    """
    )


def install_fish():
    t.run_shell(
        f"""

    echo
    echo "Installing fish..."
    echo "=================="
    echo
    echo {PASSWORD} | sudo -S apt install fish
    echo

    echo "Changing to fish..."
    echo "===================="
    echo
    echo {PASSWORD} | sudo -S chsh -s $(which fish)
    echo

    echo "Moving fish config..."
    echo "====================="
    echo
    echo y | cp -r fish ~/.config/
    fish && source ~/.config/fish/config.fish
    echo
    """
    )


def install_font(version="2.225"):
    t.run_shell(
        f"""

    echo
    echo "Installing Jetbrains Mono..."
    echo "============================"
    echo

    echo {PASSWORD} | sudo -S curl -OJL https://download.jetbrains.com/fonts/JetBrainsMono-{version}.zip
    echo {PASSWORD} | sudo -S unzip ./JetBrainsMono-{version}.zip -d /usr/share/fonts
    echo {PASSWORD} | sudo -S fc-cache -f -v
    echo {PASSWORD} | sudo -S rm -rf JetBrainsMono-{version}.zip
    echo
    """
    )


if __name__ == "__main__":
    update_packages()
    install_python()
    install_docker()
    install_fish()
    install_font()
