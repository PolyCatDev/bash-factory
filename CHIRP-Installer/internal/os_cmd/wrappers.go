package os_cmd

import (
	"log"
	"os/exec"
)

// Accepts a commdand and a slice of arguments and returns the output of the command
func Run(command string, args []string, isSudo bool) string {

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


