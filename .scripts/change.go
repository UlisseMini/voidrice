package main

import (
	"io/ioutil"
	"os"
	"strings"

	"github.com/UlisseMini/leetlog"
)

func main() {
	files, err := ioutil.ReadDir(".")
	if err != nil {
		leetlog.Fatal(err)
	}

	padnum := 23
	for _, file := range files {
		fname := file.Name()
		if !strings.HasPrefix(fname, "license_") {
			continue
		}

		newName := fname[8:]
		padding := strings.Repeat(" ", padnum-len(fname))
		leetlog.Infof("%s%s --> %s", fname, padding, newName)

		if err := os.Rename(fname, newName); err != nil {
			leetlog.Error(err)
		}
	}
}
