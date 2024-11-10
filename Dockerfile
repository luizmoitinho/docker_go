FROM golang:1.23-alpine as BUILDER

WORKDIR /usr/src/app

COPY go.mod ./

RUN go mod download && go mod verify

COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o app_go .

FROM scratch

WORKDIR /usr/src/app

COPY --from=BUILDER /usr/src/app/ ./

ENTRYPOINT [ "./app_go" ]
