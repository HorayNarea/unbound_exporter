FROM golang:alpine AS build
LABEL maintainer "Thomas Sänger <thomas@gecko.space>"

ENV CGO_ENABLED=0

RUN apk add --no-cache \
  ca-certificates \
  git

RUN go get -v -d github.com/kumina/unbound_exporter
RUN go install -v github.com/kumina/unbound_exporter


FROM scratch
COPY --from=build /go/bin/* /

VOLUME /certs

CMD [ "/unbound_exporter", "-unbound.host", "$UNBOUND_HOST" ]

EXPOSE 9167/tcp
