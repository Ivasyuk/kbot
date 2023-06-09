FROM quay.io/projectquay/golang:1.20 as builder

ARG ARCH
ARG OS 

WORKDIR /go/src/app
COPY . .
RUN make ${OS} ARCH=${ARCH}


FROM alpine
RUN apk add libc6-compat 
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot" ]
