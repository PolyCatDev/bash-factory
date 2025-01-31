package scraper

import (
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"sync"

	"github.com/gocolly/colly"
)

// Outputs the download url for CHIRP wheel package
func GetChirpWheelUrl() (string, string) {

	website := "https://archive.chirpmyradio.com/download?stream=next"

	var wg sync.WaitGroup

	collector := colly.NewCollector(colly.AllowedDomains("archive.chirpmyradio.com"))
	var finalURL string
	var wheel string

	collector.OnRequest(func(r *colly.Request) {
		wg.Add(2)
	})

	collector.OnHTML("a[href]", func(h *colly.HTMLElement) {
		href := h.Attr("href")
		if strings.HasSuffix(href, ".whl") {
			wheel = href
			wg.Done()
		}
	})

	collector.OnResponse(func(r *colly.Response) {
		finalURL = r.Request.URL.String()
		wg.Done()
	})

	collector.OnError(func(r *colly.Response, err error) {
		log.Fatalln("Error while scarpig:", err)
	})

	collector.Visit(website)
	wg.Wait()
	return finalURL + wheel, wheel
}

// Downloads a file from a URL with a spcific name and dumps it at the root of the project
func DownloadFile(url string, filename string) {

	resp, err := http.Get(url)
	if err != nil {
		log.Fatalln("Error downloading the file:", err)
	}
	defer resp.Body.Close()

	outFile, err := os.Create(filename)
	if err != nil {
		log.Fatalln("Error creating the file:", err)
	}
	defer outFile.Close()

	_, err = io.Copy(outFile, resp.Body)
	if err != nil {
		log.Fatalln("Error saving the file:", err)
	}

}
