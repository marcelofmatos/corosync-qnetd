# corosync-qnetd — QDevice (árbitro de quórum) para clusters corosync/Proxmox.
# Imagem mínima Debian 13 (trixie) + corosync-qnetd.
# A CA/NSS db NÃO é embutida na imagem — é gerada em runtime e persistida no volume
# (montar um volume em /etc/corosync/qnetd). Assim a imagem é segura p/ registry público.
FROM debian:trixie-slim

ARG APP_VERSION=dev

RUN apt-get update \
 && apt-get install -y --no-install-recommends corosync-qnetd \
 && rm -rf /var/lib/apt/lists/* /etc/corosync/qnetd/nssdb

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

LABEL org.opencontainers.image.title="corosync-qnetd" \
      org.opencontainers.image.description="corosync-qnetd (QDevice arbiter) — CA gerada em runtime, persistida em volume" \
      org.opencontainers.image.vendor="Marcelo Matos" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.version="${APP_VERSION}"

EXPOSE 5403/tcp
VOLUME ["/etc/corosync/qnetd"]

ENTRYPOINT ["/entrypoint.sh"]
