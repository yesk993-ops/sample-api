FROM golang:alpine AS build-env

RUN apk add --no-cache git

WORKDIR /go/src/app

COPY . .

RUN go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
    -ldflags '-extldflags "-static"' -o app .

FROM scratch

WORKDIR /app

COPY --from=build-env /go/src/app/app .

ENTRYPOINT ["./app"]
