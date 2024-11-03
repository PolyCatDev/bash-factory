# An installation script for the popular radio programming program [CHIRP](https://chirpmyradio.com)
# By PolyCat

from bs4 import BeautifulSoup
from requests import get
from subprocess import run, check_output

# Returns a tuple with the downlad link at index 0 and the file name at index 1
def get_link() -> tuple:
    url = "https://archive.chirpmyradio.com/download?stream=next"

    source = get(url, allow_redirects=True)
    doc = BeautifulSoup(source.content, "html.parser")

    links = doc.find_all('a')
    del doc
    result = ' '.join(link.get('href', '') for link in links if link.get('href', '').endswith('.whl'))

    return (source.url + result, result)

# Takes in a url, file name and download path and downloads the file in the folder specified
def download_file(url, file_name, path):
    wheel = get(url, stream=True)

    with open(f"{path}/{file_name}", "wb") as f:
        f.write(wheel.content)

# Takes in a package manager (apt, dnf or brew) and returns a string with a install command for the deps
def deps_install(pkgman:str) -> str:
    sudo = True
    no_confirm = ""
    is_sudo = ""

    match pkgman:
        case "dnf":
            pkgs = "python3-wxpython4 pipx"
            no_confirm = "-y"
        case "apt":
            pkgs = "python3-wxgtk4.0 pipx"
            no_confirm = "-y"
        case "brew":
            pkgs = "wxpython pipx"
            sudo = False
        case _:
            print(f"Unsupported package manager: {pkgman}")
            exit()
    
    if sudo == True:
        del sudo
        is_sudo = "sudo "

    return f"{is_sudo}{pkgman} install {pkgs} {no_confirm}"

# Takes in path to .whl and returns pipx installatin commands
def install(path:str) -> str:
    return f"pipx install --system-site-packages {path}"

# Takes in a group string and returns a command for adding the current user to that group
def add_user_to(group: str) -> str:
    user = check_output("whoami", shell=True, text=True).strip()
    return f"""sudo sh -c 'echo "{group}:x:20:{user}" >> /etc/group'"""

if __name__ == "__main__":

    # Choose pkg manager
    pkg_loop = True
    while pkg_loop:
        pkgman = input("Choose a package manager (apt/dnf/brew): ")
        if pkgman == "apt" or pkgman == "dnf" or pkgman == "brew":
            pkg_loop = False
    install_cmd = deps_install(pkgman)

    print("Downloading the latest release of CHIRP")
    path = "download"
    url = get_link()

    # Downlaod .whl
    download_file(url[0], url[1], path)

    # Install deps then use pipx to install chirp .whl
    print("Installing CHIRP")
    run(install_cmd, shell=True)
    run(install(f"{path}/{url[1]}"), shell=True)

    # Add user to dialout group if on linux
    if pkgman == "brew":
        loop = True

        while loop:
            is_on_mac = input("Are you on MacOS? (y/n): ")
            if is_on_mac == "y" :
                exit()
            elif is_on_mac == "n":
                loop = False
    run(add_user_to("dialout"), shell=True)
