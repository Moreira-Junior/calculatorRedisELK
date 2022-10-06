FROM golang:1.16.15-bullseye AS go
COPY . /home/go/src
WORKDIR /home/go/src
RUN go mod download
RUN go build -o main main.go

RUN apt-get update -y && \
 apt-get install -y collectd

COPY ./collectd.conf /etc/collectd/collectd.conf

ENTRYPOINT  /etc/init.d/collectd start && /home/go/src/main
EXPOSE 8080

