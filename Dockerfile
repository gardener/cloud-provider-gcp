############# builder            #############
FROM golang:1.18.10 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-gcp
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# cloud-provider-gcp #############
FROM alpine:3.17.3 AS cloud-provider-gcp

COPY --from=builder /go/bin/gcp-cloud-controller-manager /gcp-cloud-controller-manager

WORKDIR /

ENTRYPOINT ["/gcp-cloud-controller-manager"]
