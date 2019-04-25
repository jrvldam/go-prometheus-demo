# Go Prometheus Demo

## Run locally
Execute `./run.sh`, this will build the binary and execute it locally

```
./run.sh
```

## Build and push to docker registry
Binary will be compiled for Linux and amd64 arch, then builds docker image and pushes it to docker registry `eu.gcr.io/pmoncada-001/go-prometheus-demo`
```
./build-and-push.sh
```

## Restart application in Kubernetes
To apply changes and deploy new image pushed to the registry, restart the pods
```
./restart.sh
```

## How to use it

- Endpoint base: http://IP_ADDRESS/
- Visit home: `curl -X GET http://IP_ADDRESS/`
- Buy a book of type `genre`: `curl -X POST http://IP_ADDRESS/buy/:genre`

## Deploy to Kubernetes
App is already deployed to Kubernetes, but if you need to deploy it again, then execute:
```
kubectl apply -f k8s/
```