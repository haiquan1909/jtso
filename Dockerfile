FROM golang:alpine as builder
ARG LDFLAGS=""

RUN apk --update --no-cache add git build-base gcc

COPY . /build
WORKDIR /build

RUN go build -o ./jtso -ldflags "${LDFLAGS}" ./main.go 

FROM alpine:latest

USER 0
RUN mkdir -p /etc/jtso

RUN apk update --no-cache && \
    adduser -S -D -H -h / flow
USER flow
COPY --from=builder /build/jtso /

EXPOSE 8081

ENTRYPOINT ["ls -lia"]