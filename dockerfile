FROM alpine:3.7

EXPOSE 8080

ADD svc-tils /bin/svc-tils

ENTRYPOINT "svc-tils"