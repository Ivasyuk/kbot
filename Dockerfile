FROM golang:1.19 as builder
WORKDIR /go/src/app
COPY . .
RUN make build


FROM alpine
RUN apk add libc6-compat 
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
CMD ./kbot
