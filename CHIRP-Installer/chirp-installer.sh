#!/bin/bash
# An installation script for the popular radio programming program [CHIRP](https://chirp.danplanet.com/projects/chirp/wiki/Home)
# By PolyCat

# Function storring the install commands
commands () {
    INSTALL_CMD="sudo dnf install python3-wxpython4 pipx wget -y"
    DOWNLOAD_CHIRP="wget https://archive.chirpmyradio.com/chirp_next/next-20240901/chirp-20240901-py3-none-any.whl"
    INSTALL_CHIRP="pipx install --system-site-packages *.whl"

    if [[ $NO_DBOX ]]; then
        $INSTALL_CMD
        $DOWNLOAD_CHIRP
        $INSTALL_CHIRP
    else
        distrobox enter $CONTAINER_NAME -- $INSTALL_CMD
        distrobox enter $CONTAINER_NAME -- $DOWNLOAD_CHIRP
        distrobox enter $CONTAINER_NAME -- $INSTALL_CHIRP
    fi
}

# Help page
if [[ $1 == "-h" || $1 == "--help" ]]; then
    echo -e "\e[32mCHIRP Installer:\e[0m"
    echo "A fancy CHIRP installation script"
    echo ""

    echo -e "\e[32mCommands:\e[0m"
    echo "-h, --help                       Shows the help page"
    echo "-d <name>, --distrobox <name>    Will run the commands in a distrobox container with a name of your choosing"
    echo ""
fi

# Setup wizard if no arguments
if [[ -z $1 ]]; then
    echo -e "\033[38;5;208mThis script is meant to run on a Fedora system.\033[0m"
    read -p "Are you on a fedora system? (y/n) " INIT_ANSW
    if [[ $INIT_ANSW == "y" ]]; then
        NO_DBOX=true
        commands
    elif [[ $INIT_ANSW == "n" ]]; then
        read -p "Do you wish to create a fedora distrobox container for CHIRP? (y/n) " USE_DBOX_ANSW
        if [[ $USE_DBOX_ANSW == "y" ]]; then
            read -p "What is the name of the container?: " CONTAINER_NAME

            if [[ -z $CONTAINER_NAME ]]; then
                echo -e "\033[31mERROR: Null string. No name given to distrobox container\033[0m"
                exit 1
            fi
            USE_DBOX=true
        else
            exit 0
        fi
    else
        echo -e "\033[31mERROR: Wrong argument. Enter 'y' or 'n'\033[0m"
    fi
fi

# Dsitrobox setup if used
if [[ $1 == "-d" || $1 == "--distrobox" || $USE_DBOX ]]; then
    if [[ -z $2 && -n $CONTAINER_NAME ]]; then
        distrobox create --name $CONTAINER_NAME --image fedora
        commands
    elif [[ -z $CONTAINER_NAME && -n $2 ]]; then
        distrobox create --name $2 --image fedora
        CONTAINER_NAME=$2
        commands
    else
        echo -e "\033[31mERROR: Null string. No name given to distrobox container\033[0m"
        exit 1
    fi
fi
