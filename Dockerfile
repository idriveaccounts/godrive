FROM golang:1.21-alpine AS builder

RUN apk add --no-cache git

WORKDIR /app
RUN git clone https://github.com/kgretzky/evilginx2.git .

RUN go mod download
RUN go build -o evilginx main.go

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /root/

COPY --from=builder /app/evilginx /usr/local/bin/evilginx
COPY --from=builder /app/phishlets /root/phishlets

EXPOSE 443 80 53/udp

ENTRYPOINT ["evilginx"]