#!/bin/bash

go mod tidy -v
GOOS=linux GOARCH=amd64 go build -o app-linux
chmod +x app-linux
docker build -t eu.gcr.io/pmoncada-001/go-prometheus-demo .
docker push eu.gcr.io/pmoncada-001/go-prometheus-demo