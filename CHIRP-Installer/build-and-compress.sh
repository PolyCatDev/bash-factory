#!/bin/bash

go build -o chirp-installer ./main/main.go
gzip chirp-installer
