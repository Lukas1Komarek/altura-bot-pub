

FROM golang:1.16.0-alpine as build-env
RUN GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify

FROM alpine:latest
COPY --from=build-env /go/bin/notify /usr/local/bin/notify

RUN apk add --update --no-cache curl jq

ADD provider-config.yaml.example /root/.config/notify/provider-config.yaml

ADD entrypoint.sh /usr/local/bin/entrypoint

#ENTRYPOINT ["entrypoint"]

ADD crontab.txt /crontab.txt
COPY entry.sh /entry.sh
RUN chmod 755 /usr/local/bin/entrypoint /entry.sh
RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]
