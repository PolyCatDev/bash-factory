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

clangd_config = """
CompileFlags:
  Add: [
    -DSSIZE_MAX,
    -DLWIP_NO_UNISTD_H=1,
    -Dssize_t=long,
    -D_SSIZE_T_DECLARED,
    -Wno-unknown-warning-option
  ]
  Remove: [
    -mlong-calls,
    -fno-tree-switch-conversion,
    -mtext-section-literals,
    -mlongcalls,
    -fstrict-volatile-bitfields,
    -free,
    -fipa-pta,
    -march=*,
    -mabi=*,
    -mcpu=*
  ]
Diagnostics:
  Suppress:
    - pp_including_mainfile_in_preamble
    - pp_expr_bad_token_start_expr
    - redefinition_different_typedef
    - main_returns_nonint
"""

with open(".glangd", "w") as f:
    _ = f.write(clangd_config)


_ = subprocess.run(["pio","run", "--target", "compiledb"])
