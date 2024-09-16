#!/bin/bash

# Initial prompt with help flag exception
if [[ $1 != "-h" ]]; then
    read -p "Make sure you entered everything correctly. Do you wish to continue? (y/n) " INIT_ANSWER
    INIT_ANSWER=$(echo "$INIT_ANSWER" | tr '[:upper:]' '[:lower:]')

    if [[ $INIT_ANSWER != "y" ]]; then
	    exit
    fi
fi


# Check for help flag
if [[ $1 == "-h" ]]; then
    echo ""

    echo -e "\e[32mdevenv-setup:\e[0m"
    echo "A Linux Development Enviroment setup script"
    echo ""

    echo -e "\e[32mSyntax:\e[0m"
    echo "./devenv-setup *distro*"
    echo ""

    echo -e "\e[32mExample:\e[0m"
    echo "./devenv-setup --arch"
    echo ""
fi


# Checks if first argument is --arch and launches the arch script if yes
if [[ $1 == "--arch" ]]; then
    chmod +x ./arch.sh
    source ./arch.sh
elif [[ $1 != "-h" ]]; then
    echo -e "\e[31mArgument invalid or no arguments.\e[0m"
fi
