# ./Dockerfile
### -- Stage 1: Build Routinator
FROM rust:1.82-alpine as builder

ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH

RUN apk add --no-cache \
      bash curl ca-certificates git rsync \
      build-base openssl-dev

RUN cargo install routinator

### -- Stage 2: Minimal Alpine runtime
FROM alpine:latest

RUN apk add --no-cache \
      bash ca-certificates rsync openssl tini su-exec libgcc

COPY --from=builder /usr/local/cargo/bin/routinator /usr/local/bin/routinator

RUN addgroup -S routinator && adduser -S -D -H -s /sbin/nologin -G routinator routinator && \
    mkdir -p /var/lib/routinator /home/routinator && \
    chown -R routinator:routinator /var/lib/routinator /home/routinator

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["routinator", "server"]
