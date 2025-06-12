#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

# Skript-Einstellungen
APP="Omada"
var_cpu=2
var_ram=3072
var_disk=8
var_os="debian"
var_version=12
var_unprivileged=0   # privilegierter Container

header_info "$APP"
variables
color
catch_errors

# Container erstellen
start
build_container
description

# MongoDB 4.4 installieren (AVX nicht erforderlich)
msg_info "Installing MongoDB 4.4 (AVX not required)"
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc \
  | gpg --dearmor >/usr/share/keyrings/mongodb-server-4.4.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg] \
http://repo.mongodb.org/apt/debian $(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)/mongodb-org/4.4 main" \
  >/etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
msg_ok "MongoDB 4.4 installed"

# Omada Controller aktualisieren/installieren
update_script

# Abschlussmeldung
msg_ok "Completed Successfully!"
echo -e "${INFO} Access it using the following URL:"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:8043${CL}"
