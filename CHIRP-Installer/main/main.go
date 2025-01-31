package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
	"sync"

	"github.com/PolyCatDev/chirp-installer/internal/os_cmd"
	"github.com/PolyCatDev/chirp-installer/internal/scraper"
)

func main() {
	// Set package manager
	reader := bufio.NewReader(os.Stdin)
	var pkgManager string
	var deps []string
	var isSudo bool
	for {
		var err error
		fmt.Print("Choose a package manager (apt/dnf/brew): ")
		pkgManager, err = reader.ReadString('\n')
		pkgManager = strings.TrimSpace(pkgManager)
		if err != nil {
			log.Fatalln(err)
		}

		deps, isSudo, err = os_cmd.GetPackageManagerArgs(pkgManager)
		if err == nil {
			break
		}
		fmt.Println(err)
	}

	wheelNameChan := make(chan string)
	var wg sync.WaitGroup
	wg.Add(2)

	// Download CHIRP wheel package
	go func() {
		defer wg.Done()
		fmt.Println("Downloading CHIRP")
		downUrl, wheelName := scraper.GetChirpWheelUrl()
		scraper.DownloadFile(downUrl, wheelName)
		wheelNameChan <- wheelName
	}()

	// Installing deps
	go func() {
		defer wg.Done()
		fmt.Println("Installing system dependencies with", pkgManager)
		deps = append([]string{"install"}, deps...)
		os_cmd.Run(pkgManager, deps, isSudo)
	}()

	wheelName := <-wheelNameChan
	close(wheelNameChan)
	wg.Wait()

	// Istalling CHIRP with Pipx
	fmt.Println("Installing CHIRP with pipx")
	os_cmd.Run("pipx", []string{"install", "--system-site-packages", "./" + wheelName}, false)

	// Add user to dialout group if not already
	groups := os_cmd.Run("groups", []string{}, false)
	if !strings.Contains(groups, "dialout") {
		fmt.Println("Adding user to dialout group")
		addUserCommand, AddUserArgs := os_cmd.CurrentUserAddToGroup("dialout")

		os_cmd.Run(addUserCommand, AddUserArgs, true)

		defer fmt.Println("Reboot your machine to fully complete setup")
	}

	// Remove wheel package
	fmt.Println("Cleaning up")
	err := os.Remove(wheelName)
	if err != nil {
		log.Fatalln("Error removing file:", err)
	}

	fmt.Println("chirp command now available")
}
