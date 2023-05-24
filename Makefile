APP=$(basename $(shell git remote get-url origin))
REGISTRY=gcr.io/devopsproject-386908
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

# MACOS COMPILE
ifeq ($(strip $(ARCH)),)
macos: attention_macos
else
macos: compile_macos
endif
compile_macos:
	CGO_ENABLED=0 GOOS=darwin GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_macos:
	@echo "Please run with arguments ARCH, for example: make macos ARCH=amd64"


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

clean:
	rm -rf ./kbot
	
get:
	go get

imagewindows: 
	docker  build  -t ${REGISTRY}/kbot:${VERSION} -f winDockerfile .

push:
	docker push ${REGISTRY}/${APdocP}:${VERSION}