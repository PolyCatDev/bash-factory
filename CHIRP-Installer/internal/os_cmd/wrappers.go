package os_cmd

import (
	"log"
	"os/exec"
	"strings"
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

// Accepts a group and returns command and args
// for adding that user to the /etc/group file
func CurrentUserAddToGroup(group string) (string, []string) {
	user := Run("whoami", []string{}, false)
	user = strings.TrimSpace(user)

	args := []string{"-c", "echo \"" + group + ":x:20:" + user + "\" >> /etc/group"}

	return "sh", args
}
