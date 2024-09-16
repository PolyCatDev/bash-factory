#!/bin/bash

# Installs necessary packages
echo -e "\e[32mInstalling needed Tools\e[0m"
sudo pacman -S --noconfirm base-devel git


# Asks for extra tools
read -p "Do you want fancy tools (vim, nvim, nano, micro, lsd, bat, tmux)? (y/n) " FANCY_ANSWER
FANCY_ANSWER=$(echo "$FANCY_ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ $FANCY_ANSWER == "y" ]]; then
	sudo pacman -S --noconfirm nano micro vim neovim lsd bat tmux
fi


# Asks for Yay package manager
read -p "Do you want the yay package manager? (y/n) " YAY_ANSWER
YAY_ANSWER=$(echo "$YAY_ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ $YAY_ANSWER == "y" ]]; then
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd .. && rm -rf yay
fi


# Asks for VSCode/VSCodium and installs it thru yay or makepkg depending on previous entry
read -p "Do you want VSCodium, VSCode or none? (a/b/n) " VS_ANSWER
VS_ANSWER=$(echo "$VS_ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ $VS_ANSWER == "a" && $YAY_ANSWER == "y" ]]; then
	VS="y"
	echo -e "\e[32mInstalling VSCodium\e[0m"
	yay -S vscodium-bin --noconfirm

elif [[ $VS_ANSWER == "b" && $YAY == "y" ]]; then
	VS="y"
	echo -e "\e[32mInstalling VSCode\e[0m"
	yay -S vscode-bin --noconfirm

elif [[ $VS_ANSWER == "a" ]]; then
	VS="y"
	echo -e "\e[32mInstalling VSCodium\e[0m"
	git clone https://aur.archlinux.org/vscodium-bin.git
	cd vscodium-bin
	makepkg -si
	cd .. && rm -rf vscodium-bin

elif [[ $VS_ANSWER == "b" ]]; then
	VS="y"
	echo -e "\e[32mInstalling VSCode\e[0m"
	git clone https://aur.archlinux.org/visual-studio-code-bin.git
	cd visual-studio-code-bin
	makepkg -si
	cd .. && rm -rf visual-studio-code-bin
fi


# Asks for adw-gtk3 package if user selected to install VSCode/VSCodium
# And installs with yay or makepkg depending on if the user selected to install yay
if [[ $VS = "y" ]]; then
	echo ""
	echo "Do you want adw-gtk3 theme?"
	read -p "This will theme the gtk parts of VSCode/VSCodium in a simple dark theme. (y/n) " ADW_ANSWER
fi
ADW_ANSWER=$(echo "$ADW_ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ $ADW_ANSWER == "y" && $YAY_ANSWER == "y" && $VS == "y" ]]; then
	yay -S adw-gtk3 --noconfirm
elif [[ $ADW_ANSWER == "y" && $VS = "y" ]]; then
	git clone https://aur.archlinux.org/adw-gtk3.git
	cd adw-gtk3
	makepkg -si
	cd .. && rm -rf adw-gtk3
fi

# Prints out the finnal message of the script
echo -e "\e[32mDev Environment Setup Done\e[0m"
