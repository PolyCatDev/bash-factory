import os
import subprocess

project_name = input("Enter project name: ")
os.mkdir(project_name)
os.chdir(project_name)

board_name = input("Board ID: ")
_ = subprocess.run(["pio","project", "init", "--board", board_name])

code = """
import os
Import("env")

# include toolchain paths
env.Replace(COMPILATIONDB_INCLUDE_TOOLCHAIN=True)

# override compilation DB path
env.Replace(COMPILATIONDB_PATH="compile_commands.json")
"""

with open("extra_script.py", "w") as f:
    _ = f.write(code)


with open("platformio.ini", "a") as f:
    _ = f.write("extra_scripts = pre:extra_script.py")


_ = subprocess.run(["pio","run", "--target", "compiledb"])
