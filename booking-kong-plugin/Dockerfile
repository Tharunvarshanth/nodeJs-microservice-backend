FROM golang:1.17.9-alpine3.15 AS builder

WORKDIR /tmp/go-plugins
COPY ./plugins /tmp/go-plugins/plugins
RUN cd /tmp/go-plugins/plugins && GOOS=linux GOARCH=amd64 go build -o api-gateway/.bin/api-gateway api-gateway/cmd/main.go

FROM kong:2.8.1-alpine
USER root
RUN apk update && apk add gettext

COPY --from=builder /tmp/go-plugins/plugins/api-gateway/.bin/api-gateway /usr/local/bin/

ENV KONG_PLUGINSERVER_NAMES="api-gateway"
ENV KONG_PLUGINSERVER_API_GATEWAY_SOCKET="/usr/local/kong/api-gateway.socket"
ENV KONG_PLUGINSERVER_API_GATEWAY_START_CMD="/usr/local/bin/api-gateway"
ENV KONG_PLUGINSERVER_API_GATEWAY_QUERY_CMD="/usr/local/bin/api-gateway -dump"

RUN ["/usr/local/bin/api-gateway", "-dump"]

USER kong
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
#docker build --no-cache --platform linux/amd64  -t triton-kong:0.0.6 .