FROM golang:1.22.5-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app .

FROM gcr.io/distroless/base-debian12
WORKDIR /
COPY --from=builder /app/app /my-go-app
COPY --from=builder /app/static ./static
EXPOSE 8080
CMD ["/my-go-app"]
