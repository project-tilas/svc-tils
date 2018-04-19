FROM golang:1.10.1 AS builder

EXPOSE 8080

ADD svc-tils /bin/svc-tils

ENTRYPOINT "svc-tils"