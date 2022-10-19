GO=go
GOTEST=$(GO) test
GOBUILD=$(GO) build

## Clean dist directory and rebuild the binary file
go_build: 
	GO111MODULE=on
	GOFLAGS=-mod=vendor
	rm -rf ./dist 
	$(GOBUILD) -o ./dist/app ./src

## Build docker image
docker_build:
	docker build -t yashkumarverma/minitoring-workspace .

## Run docker image
docker_run:
	docker run --rm -p 80:80 yashkumarverma/minitoring-workspace

## Compile and prepare a docker image
clean_build:
	make go_build
	make docker_build
