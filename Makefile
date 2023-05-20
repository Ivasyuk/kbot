VERSION=$(shell  -git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format
	go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
	
get:
	go get