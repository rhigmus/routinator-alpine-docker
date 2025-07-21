# /root/Attempt-2_alpine-with-routinator-installed/Dockerfile
FROM alpine:latest

# Set environment variables for Cargo install path
ENV CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    CARGO_TARGET_DIR=/usr/local/cargo-target

# Install runtime deps separately so they remain
RUN apk add --no-cache \
      bash curl ca-certificates git rsync \
      openssl tini su-exec libgcc \
    && apk add --no-cache --virtual .build-deps rust cargo build-base \
    && mkdir -p /usr/local/cargo-target \
    && cargo install routinator \
    && apk del .build-deps \
    && mkdir -p /var/lib/routinator /home/routinator \
    && addgroup -S routinator && adduser -S -D -H -s /sbin/nologin -G routinator routinator \
    && chown -R routinator:routinator /var/lib/routinator /home/routinator

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["routinator", "server"]
