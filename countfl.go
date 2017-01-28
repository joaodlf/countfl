package main

import (
	"bufio"
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"sync/atomic"
)

func main() {
	args := os.Args[0:]

	if len(args) < 2 {
		errorExit(errors.New("Must provide a file extension"), 0)
	}

	// File extension
	ext := args[len(args)-1]
	if !strings.HasPrefix(ext, ".") {
		ext = "." + ext
	}

	// Optional flags
	searchDir := flag.String("d", ".", "The directory to search")
	exclude := flag.String("e", ".", "A directory to exclude from results")
	log := flag.Bool("l", false, "Displays the log")

	flag.Parse()

	// Check if dir exists
	if _, err := os.Stat(*searchDir); os.IsNotExist(err) {
		errorExit(err, 0)
	}

	var totalFiles uint64
	var totalLines uint64
	var totalErrors uint64
	var wg sync.WaitGroup

	fmt.Println("Finding", ext, "files in", *searchDir)
	// Iterate through files and count lines
	filepath.Walk(*searchDir, func(path string, file os.FileInfo, err error) error {
		if err == nil {
			wg.Add(1)
			go func(path string, file os.FileInfo) {
				defer wg.Done()

				if !file.IsDir() && strings.HasSuffix(file.Name(), ext) {
					if !strings.HasPrefix(path, *exclude) {
						fileOpen, _ := os.Open(path)
						fileScanner := bufio.NewScanner(fileOpen)
						fileLines := 0

						if *log == true {
							fmt.Println(path)
						}

						for fileScanner.Scan() {
							fileLines++
						}

						// Add values to atomic counters
						atomic.AddUint64(&totalLines, uint64(fileLines))
						atomic.AddUint64(&totalFiles, 1)
					}
				}
			}(path, file)
		} else {
			totalErrors++
			if *log == true {
				fmt.Fprintln(os.Stderr, "Error:", err)
			}
		}
		return nil
	})

	// Wait for all goroutines to finish
	wg.Wait()

	fmt.Println("============")
	fmt.Println("Total Files:", atomic.LoadUint64(&totalFiles))
	fmt.Println("Total Lines:", atomic.LoadUint64(&totalLines))
	fmt.Println("Total Errors:", totalErrors)
}

func errorExit(e error, code int) {
	fmt.Fprintln(os.Stderr, "Error:", e)
	os.Exit(code)
}
