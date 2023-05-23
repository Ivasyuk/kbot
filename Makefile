APP=$(basename $(shell git remote get-url origin))
REGISTRY=gcr.io/devopsproject-386908
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

limux: TARGETOS = linux
macOS: TARGETOS = darwin
Windows: TARGETOS = Windows


format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

linux: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
macOS: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
Windows: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot.exe -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
arm:
	echo "Compiling ARM for every OS "
	CGO_ENABLED=0  GOOS=linux GOARCH=${arm} go build -v -o kbot-linux-arm -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0  GOOS=darwin GOARCH=${arm} go build -v -o kbot-macos-arm -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0  GOOS=windows GOARCH=${arm} go build -v -o kbot-windows-arm.exe -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
	
get:
	go get

image:
	docker build -d ${REGISTRY}/${APP}:${VERSION}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}