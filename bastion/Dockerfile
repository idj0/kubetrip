FROM nginx:1.21.3-alpine

# Copy binary to production image
COPY tailscale_bin/tailscaled /usr/sbin/tailscaled
COPY tailscale_bin/tailscale /usr/sbin/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN apk add --no-cache \
        ca-certificates \
        iptables \
        ip6tables \
  && rm -rf /var/cache/apk/*

COPY bastion.conf /etc/nginx/conf.d/

COPY ./init-tailscale.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/init-tailscale.sh

EXPOSE 8080
