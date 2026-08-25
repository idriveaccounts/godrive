FROM golang:1.23-alpine AS build

RUN apk add --no-cache git

WORKDIR /go/src/github.com/kgretzky/evilginx2

RUN git clone https://github.com/kgretzky/evilginx2.git .

RUN go mod download

RUN go build -o /go/bin/evilginx main.go

FROM alpine:latest

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=build /go/bin/evilginx /app/evilginx

RUN mkdir -p /app/phishlets

COPY --from=build /go/src/github.com/kgretzky/evilginx2/phishlets /app/phishlets

EXPOSE 443 80 53/udp

# Mantener el contenedor vivo y ejecutar evilginx
ENTRYPOINT ["/app/evilginx"]
CMD ["-c", "/app/config"]