FROM golang:1.20 AS BUILDER

LABEL maintainer="Roman Tkalenko"

COPY . /go/src/github.com/ClickHouse/clickhouse_exporter

WORKDIR /go/src/github.com/ClickHouse/clickhouse_exporter

RUN make init
RUN make all

FROM alpine:latest

COPY --from=BUILDER /go/bin/clickhouse_exporter /usr/local/bin/clickhouse_exporter
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/clickhouse_exporter"]
CMD ["-scrape_uri=http://localhost:8123"]
EXPOSE 9116
