package os_cmd

import (
	"errors"
	"fmt"
	"strings"
)

// Takes in "dnf", "apt" or "brew" and returns the necessary args
func GetPackageManagerArgs(packageManager string) ([]string, bool, error) {

	var args []string
	var noConfirm string
	var isSudo bool = true
	var err error

	switch packageManager {
	case "dnf":
		args = []string{"python3-wxpython4", "pipx"}
		noConfirm = "-y"
	case "apt":
		args = []string{"python3-wxgtk4.0", "pipx"}
		noConfirm = "-y"
	case "brew":
		args = []string{"wxpython", "pipx"}
		isSudo = false
	default:
		err = errors.New(fmt.Sprint("Unsupported package manager:"+" ", packageManager))
	}

	if noConfirm != "" {
		args = append(args, noConfirm)
	}

	return args, isSudo, err
}

// Accepts a group and returns command and args
// for adding that user via the usermod command
func CurrentUserAddToGroup(group string) (string, []string) {
	user := RunReturn("whoami", []string{}, false)
	user = strings.TrimSpace(user)

	args := []string{"-aG", group, user}

	return "usermod", args
}
