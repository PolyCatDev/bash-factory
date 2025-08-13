# Setup PlatfromIO for Clangd
> [!IMPORTANT]
> This script has become immediately outdated due to my [clangd-platformio repo](https://github.com/PolyCatDev/clangd-platformio), and the script never worked particularly well to begin with.


Simple script to set up PlatfromIO and Clangd LSP to work together. 

The script will ask for project name and board ID and then it will do all the basic setup.

### Run from web

```bash
curl -o setup-pio-clangd.py https://raw.githubusercontent.com/PolyCatDev/bash-factory/refs/heads/main/Setup-PlatfromIO-Clangd/setup-pio-clangd.py && python ./setup-pio-clangd.py; rm -f ./setup-pio-clangd.py
```
