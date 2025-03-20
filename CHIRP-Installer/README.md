# PolyCat's CHIRP Installer
A fancy linux installer script for the popular ham radio programming software [CHIRP](https://chirpmyradio.com/)

>[!KNOWN BUG]
> When first installing dependencies with `brew` the program might error out after installing everthing. Just run the program again and you should be good.

## Download and Run
```bash
curl -o chirp-installer.gz https://raw.githubusercontent.com/PolyCatDev/bash-factory/refs/heads/main/CHIRP-Installer/chirp-installer.gz &&\
gunzip chirp-installer.gz &&\
chmod +x ./chirp-installer &&\
./chirp-installer &&\
rm -f ./chirp-installer
```

### Add desktop icon
```bash
mkdir -p ~/.local/share/applications/ ~/.local/share/icons/apps/ && cd ~/.local/share/applications/ &&\
curl -o chirp.desktop https://raw.githubusercontent.com/PolyCatDev/bash-factory/refs/heads/main/CHIRP-Installer/media/chirp.desktop &&\
curl -o ~/.local/share/icons/apps/chirp.png https://raw.githubusercontent.com/PolyCatDev/bash-factory/refs/heads/main/CHIRP-Installer/media/chirp.png &&\
echo "Exec=$(realpath $(which chirp))" >> chirp.desktop &&\
echo "Icon=$(realpath ~/.local/share/icons/apps/chirp.png)" >> chirp.desktop

```

## Preview
![chirp-installer](https://github.com/user-attachments/assets/b0d20bb5-aa9e-4ff9-8129-e8026f6a84f2)

## What is the "legacy" folder?
The place where the previous versions of this script are stored
