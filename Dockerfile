FROM golang:alpine as gobuilder

WORKDIR /go/src/github.com/liquidweb/kube-cert-manager
RUN apk update && apk add git bash curl && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | bash
RUN update-ca-certificates
COPY . .
RUN dep ensure
RUN CGO_ENABLED=0 go build

FROM scratch
COPY --from=gobuilder /go/src/github.com/liquidweb/kube-cert-manager/kube-cert-manager /app/kube-cert-manager
WORKDIR /app
EXPOSE 5002/tcp
CMD ["/app/kube-cert-manager"]
