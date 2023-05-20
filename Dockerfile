FROM golang:1.19 as builder
WORKDIR /got/src/app
COPY . .
RUN go get
RUN make build