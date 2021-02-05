############# builder            #############
FROM golang:1.13.4 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-gcp
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# cloud-provider-gcp #############
FROM eu.gcr.io/gardener-project/3rd/alpine:3.12.3 AS cloud-provider-gcp

COPY --from=builder /go/bin/gcp-cloud-controller-manager /gcp-cloud-controller-manager

WORKDIR /

ENTRYPOINT ["/gcp-cloud-controller-manager"]
