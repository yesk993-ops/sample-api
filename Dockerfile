# ---------- Build Stage ----------
FROM golang:1.22-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

# copy go modules first (better caching)
COPY go.mod go.sum ./

RUN go mod download

# copy source code
COPY . .

# build binary
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

# ---------- Runtime Stage ----------
FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
