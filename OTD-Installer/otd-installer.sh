
#!/bin/bash
# An Open Tablet Driver installation script for multiple distros
# by PolyCat

if [[ $1 == "-h" || $1 == "--help" || -z $1 ]]; then
    echo -e "\e[32mOTD Installer:\e[0m"
    echo "An Open Tablet Driver installation script for multiple distros"
    echo ""

    echo -e "\e[32mCommands:\e[0m"
    echo "-d <name>, --distro <name>    Choose what distro you are using"
    echo ""

    echo -e "\e[32mSupported Distros:\e[0m"
    echo "  - debian"
    echo "  - ubuntu"
    echo "  - arch-linux"
    echo "  - fedora"
    echo "  - fedora-atomic"
    echo "  - openSUSE"
    echo "  - gentoo"
    echo "  - nixos"

elif [[ $1 == "-d" && -n $2 || $1 == "--distro" && -n $2 ]]; then
    RPM_OTD="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest/download/OpenTabletDriver.rpm"
    DEB_OTD="https://github.com/OpenTabletDriver/OpenTabletDriver/releases/latest/download/OpenTabletDriver.deb"

    mkdir otd-install
    cd otd-install

    rmFolder () {
        cd ..
        rm -rf otd-install
    }

    if [[ $2 == "ubuntu" || $2 == "debian" ]]; then
        sudo apt install wget -y
        wget $DEB_OTD
        sudo apt install ./OpenTabletDriver.deb -y
        OTD_INSTALLED=true

    elif [[ $2 == "fedora" ]]; then
        sudo dnf install wget -y
        wget $RPM_OTD
        sudo dnf install ./OpenTabletDriver.rpm -y
        sudo dracut --regenerate-all --force
        OTD_INSTALLED=true


    elif [[ $2 == "fedora-atomic" ]]; then
        wget $RPM_OTD
        rpm-ostree install ./OpenTabletDriver.rpm -y
        #sudo dracut --regenerate-all --force
        OTD_INSTALLED=true

    elif [[ $2 == "arch-linux" ]]; then
        sudo pacman -S --noconfirm base-devel git

        git clone https://aur.archlinux.org/opentabletdriver.git
        cd opentabletdriver
        makepkg -si --noconfirm && cd ..

        sudo mkinitcpio -P
        sudo rmmod wacom hid_uclogi

        OTD_INSTALLED=true

    elif [[ $2 == "openSUSE" ]]; then
        wget $RPM_OTD

        sudo zypper install libicu
        sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
        wget https://packages.microsoft.com/config/opensuse/15/prod.repo
        sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
        sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo

        sudo zypper refresh
        sudo zypper --no-gpg-checks install ./OpenTabletDriver.rpm

        OTD_INSTALLED=true

    elif [[ $2 == "nixos" ]]; then
        NIXOS_CONFIG_PATH="/etc/nixos/configuration.nix"
        sudo echo "# Enable OpenTabletDriver" >> $NIXOS_CONFIG_PATH
        sudo echo "hardware.opentabletdriver.enable = true;" >> $NIXOS_CONFIG_PATH
        OTD_INSTALLED=true

    elif [[ $2 == "gentoo" ]]; then
        echo -e "You are on Gentoo and know better than me. Here's a link to the wiki: \e[32mhttps://opentabletdriver.net/Wiki/Install/Linux#gentoo\e[0m "
        echo ""
        rmFolder
        exit 1

    # Second argument error report
    else
        echo -e "\033[31mERROR: Unexpected distro\033[0m \e[38;5;94m'$2'\e[0m \033[31mfound\033[0m"
        rmFolder
        exit 1
    fi

    rmFolder

    # Post Install
    if [[ $OTD_INSTALLED ]]; then

        if [[ $2 == "fedora-atomic" ]]; then
            echo ""
            echo -e "\033[31mATTENTION:\033[0m"
            echo "You are on $2. To see the app you must first reboot"
            echo -e "Then you could run \e[32m'systemctl --user enable opentabletdriver.service --now'\e[0m to autostart OTD on boot"
        else
            read -p "Start Open Tablet Driver on boot? (Y/n): " ENABLE_SYSD
            ENABLE_SYSD=$(echo "$ENABLE_SYSD" | tr '[:upper:]' '[:lower:]')

            if [[ $ENABLE_SYSD == "y" || -z $ENABLE_SYSD ]]; then
                systemctl --user enable opentabletdriver.service --now
            fi
        fi

        echo ""
        echo -e "\e[32mOpen Tablet Driver installed on $2\e[0m"
        echo "For more information check out the official docs: https://opentabletdriver.net/Wiki"
    fi

# First argument error report
else
    echo -e "\033[31mERROR: Unexpected argument\033[0m \e[38;5;94m'$1'\e[0m \033[31mfound\033[0m"
    exit 1
fi
