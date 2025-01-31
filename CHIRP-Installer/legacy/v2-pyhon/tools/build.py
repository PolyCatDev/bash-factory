from subprocess import run

def main():
    run(["pyinstaller", "--onefile", "src/main.py"])

if __name__ == "__main__":
    main()
