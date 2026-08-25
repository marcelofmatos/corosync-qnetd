# corosync-qnetd

Imagem Docker mínima do **`corosync-qnetd`** — o árbitro de quórum (QDevice) para clusters
corosync / Proxmox VE. Dá um voto externo (o 3º voto) a um cluster de 2 nós, evitando perda de
quórum quando um nó cai.

- Base: `debian:trixie-slim` + `corosync-qnetd`.
- **A CA/NSS db é gerada em runtime** (não vem embutida na imagem) e **persistida em volume**
  montado em `/etc/corosync/qnetd` → a imagem é segura para registry público.
- Porta: **5403/tcp** (TLS).

## Imagem (GHCR)
```
ghcr.io/marcelofmatos/corosync-qnetd:1        # pin no MAJOR (recomendado)
ghcr.io/marcelofmatos/corosync-qnetd:1.0.0    # versão exata
ghcr.io/marcelofmatos/corosync-qnetd:latest
```
Publicada via CI **release-and-build** (Actions → *Release and build* → escolher patch/minor/major).

## Uso rápido
```bash
docker run -d --name qnetd \
  -v qnetd-nssdb:/etc/corosync/qnetd \
  -p 5403:5403 \
  ghcr.io/marcelofmatos/corosync-qnetd:1
```
Veja `docker-compose.yml` para deploy em Swarm (volume persistente + porta em mode host).

## Ativar o QDevice no cluster (resumo)
`pvecm qdevice setup` pressupõe o qnetd num host via SSH; com o qnetd em **container**, a troca de
certificados é manual (`corosync-qnetd-certutil` no container ↔ `corosync-qdevice-net-certutil` nos
nós), seguida da seção `quorum { device { model: net; net { host: <ip-do-qnetd> } } }` no
`corosync.conf` e `systemctl enable --now corosync-qdevice` nos nós. Verificar com
`pvecm status` (votos +1) e `corosync-qdevice-tool -s`.

## Versionamento
SemVer, `latest` sempre na última. Não sobrescrever tags de versão — feature/fix nova = nova versão.
