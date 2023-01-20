# build a main binary using the golang container
FROM golang:1.19 as builder

WORKDIR /go/src/github.com/kubermatic/k8sniff/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# copy the main binary to a separate container based on ubuntu
FROM ubuntu:22.10
WORKDIR /bin/
EXPOSE 8443
COPY --from=builder /go/src/github.com/kubermatic/k8sniff/main .
ENTRYPOINT [ "/bin/main" ]
