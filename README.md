# kbot

**telegram bot (Golang)**

## Init project

> Init go module (open termianl and run)

**go mod init github.com/ivasyuk/kbot**

> install codegenerator cobra-cli

**go install github.com/spf13/cobra-cli@latest**
 
>generate main.go and 'cmd' dir

**cobra-cli init**  

>add version ( generate versionin.go )

**cobra-cli add version** 
 
>generate telebot.go

**cobra-cli add kbot**
 
>set version

**go build -ldflags "-X="github.com/ivasyuk/kbot/cmd.appVersion=v1.0.0**
 

## Telegram bot setup 

- Add TELE_TOKEN and logic in Run func in [kbot.go](./cmd/kbot.go)
- Download and install dependencies - **go get** 
- Build and update version to v1.0.2
**go build -ldflags "-X="github.com/ivasyuk/kbot/cmd.appVersion=v1.0.2**
- Create new bot in BotFather, copy token and set token securely wit command: 
**read -s TELE_TOKEN** 
- Export variable and run app
**export TELE_TOKEN**
- Run kbot
**./kbot start**

