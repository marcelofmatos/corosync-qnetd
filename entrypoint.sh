#!/bin/sh
set -e

NSSDB=/etc/corosync/qnetd/nssdb

# Inicializa a CA/NSS db na 1a subida (persistida no volume montado em /etc/corosync/qnetd).
# Se ja existe, REUSA (regenerar invalidaria os certs ja emitidos aos nos do cluster).
if [ ! -f "$NSSDB/qnetd-cacert.crt" ]; then
  echo "[qnetd] NSS db ausente — inicializando CA..."
  corosync-qnetd-certutil -i
else
  echo "[qnetd] NSS db existente — reaproveitando CA."
fi

echo "[qnetd] iniciando corosync-qnetd (foreground) na porta 5403..."
exec corosync-qnetd -f
