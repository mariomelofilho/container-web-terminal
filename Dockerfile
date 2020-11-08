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

FROM alpine:latest
MAINTAINER Gennaro Vietri <gennaro.vietri@bitbull.it>
MAINTAINER Fatih Boy <fatih@entterprisecoding.com>

RUN apk --update add socat 

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

COPY --from=build /out/main /opt/docker-console/
ADD wwwroot /opt/docker-console/wwwroot

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8888

CMD ["/opt/docker-console/main"]