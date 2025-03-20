package os_cmd

import (
	"fmt"
	"log"
	"os"
	"os/exec"
)

// Accepts a commdand and a slice of arguments and returns the output of the command
func RunReturn(command string, args []string, isSudo bool) string {

	if isSudo {
		args = append([]string{command}, args...)
		command = "sudo"
	}

	//log.Println(command, args)

	cmd, err := exec.Command(command, args...).Output()
	if err != nil {
		log.Fatalln("Error executing command:", err)
	}

	return string(cmd)

}

// Accepts a commdand and a slice of arguments and
// runs it with std output logs
func Run(command string, args []string, isSudo bool) {

	fmt.Print("\n")
	defer fmt.Print("\n")

	if isSudo {
		args = append([]string{command}, args...)
		command = "sudo"
	}

	cmd := exec.Command(command, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()
	if err != nil {
		log.Fatalln(err)
	}
}
