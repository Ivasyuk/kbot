VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

limux: TARGETOS = linux
macOS: TARGETOS = macOS
Windows: TARGETOS = Windows

arm:GOARCH = arm

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

linux: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
macOS: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${giit} go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
Windows: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
	
get:
	go get