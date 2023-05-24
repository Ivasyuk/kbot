#APP=$(basename $(shell git remote get-url origin))
APP=kbot
REGISTRY=gcr.io/devopsproject-386908
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

get:
	go get

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
compile_macos: format get
	CGO_ENABLED=0 GOOS=darwin GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_macos:
	@echo "Please run with arguments ARCH, for example: make macos ARCH=amd64"


# LINUX COMPILE
ifeq ($(strip $(ARCH)),)
linux: attention_linux
else
linux: compile_linux
endif
compile_linux: format get
	CGO_ENABLED=0 GOOS=linux GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_linux:
	@echo "Please run with propriate argument ARCH, for example: make linux ARCH=amd64"

# WINDOWS COMPILE
ifeq ($(strip $(ARCH)),)
windows: attention_windows
else
windows: compile_windows
endif
compile_windows: format get
	CGO_ENABLED=0 GOOS=windows GOARCH=$(ARCH) go build -v -o ./kbot -ldflags "-X="github.com/Ivasyuk/kbot/cmd.appVersion=${VERSION}
attention_windows: 
	@echo "Please run with arguments ARCH, for example: make windows ARCH=amd64"

clean:
	rm -rf ./kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}

ifeq ($(strip $(OS)),)
image: builderror
else
image: buildimage
endif
buildimage:
	docker  build --build-arg OS=$(OS) --build-arg  ARCH=$(ARCH)  -t ${REGISTRY}/${APP}:${VERSION} .

builderror:
	@echo "Please run with arguments OS and ARCH , for example: make image OS=linux ARCH=amd64"

push:
	docker push ${REGISTRY}/${APP}:${VERSION}