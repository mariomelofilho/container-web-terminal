FROM golang:1.15.4-alpine AS build
WORKDIR /src
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN apk add --no-cache git mercurial
RUN go get -u github.com/davecgh/go-spew/spew
RUN go get -u golang.org/x/net/websocket
RUN go get -u github.com/gorilla/handlers
COPY main.go /src
RUN go build -a -installsuffix cgo -o /out/main .

FROM node:alpine3.12 AS xterm-extract
WORKDIR /src
RUN npm pack xterm@4.9.0 && \
    tar -xzf xterm-*.tgz && \
    mkdir xterm && \
    mv package/css/xterm.css xterm/ && \
    mv package/lib/xterm.js xterm/

FROM alpine:latest
LABEL maintainer="Gennaro Vietri <gennaro.vietri@bitbull.it>"
LABEL maintainer="Fatih Boy <fatih@entterprisecoding.com>"

RUN apk --update add socat 

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /out/main /opt/docker-web-terminal/
ADD wwwroot /opt/docker-web-terminal/wwwroot
COPY --from=xterm-extract /src/xterm /opt/docker-web-terminal/wwwroot/xterm/

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8888

CMD ["/opt/docker-web-terminal/main"]