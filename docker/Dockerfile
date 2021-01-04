#
# ------ get latest CA certificates
#
FROM alpine:3.9 as certs
RUN apk --update add ca-certificates


#
# ------ Pumba release Docker image ------
#
FROM scratch

# copy CA certificates
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# this is the last commabd since it's never cached
COPY pumba-bin /pumba

ENTRYPOINT ["/pumba"]
