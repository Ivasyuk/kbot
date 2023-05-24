EXECUTABLE=kbot
WINDOWS=$(EXECUTABLE)_windows_amd64.exe
LINUX=$(EXECUTABLE)_linux_amd64
DARWIN=$(EXECUTABLE)_darwin_amd64

APP=$(basename $(shell git remote get-url origin))
REGISTRY=gcr.io/devopsproject-386908
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

# LINUX COMPILE
ifeq ($(strip $(ARCH)),)
linux: attention_linux
else
linux: compile_linux
endif
compile_linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_linux:
	@echo "Please run with propriate argument ARCH, for example: make linux ARCH=amd64"

# WINDOWS COMPILE
ifeq ($(strip $(ARCH)),)
windows: attention_windows
else
windows: compile_windows
endif
compile_windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_windows:
	@echo "Please run with arguments ARCH, for example: make windows ARCH=amd64"


#linux: format

 #       CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) go build -v -o ./bin/$(EXECUTABLE)_linux_amd64 -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}

	
386: format
	CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -v -o ./bin/$(EXECUTABLE)_linux_386 -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -v -o ./bin/$(EXECUTABLE)_windows_386.exe -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0 GOOS=darwin GOARCH=386 go build -v -o ./bin/$(EXECUTABLE)_darwin_386 -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
arm: format
	CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -v -o ./bin/$(EXECUTABLE)_linux_arm -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0 GOOS=windows GOARCH=arm go build -v -o ./bin/$(EXECUTABLE)_windows_arm.exe -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm go build -v -o ./bin/$(EXECUTABLE)_darwin_arm -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf ./bin/*
	
get:
	go get

img_windows_amd64:
	docker build -t ${REGISTRY}/$(EXECUTABLE)_windows_amd64:${VERSION} ./DockerfileWindowsamd64

push:
	docker push ${REGISTRY}/${APdocP}:${VERSION}