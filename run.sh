#!/bin/bash

go mod tidy -v
go build -o app
./app