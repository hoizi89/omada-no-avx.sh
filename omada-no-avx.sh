#!/usr/bin/env bash
# omada-no-avx.sh – angepasst für Debian 12 ohne AVX, privilegierter LXC
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)

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

# 1️⃣ Container erstellen
start
build_container
description

# 2️⃣ Alte MongoDB-Repo-Dateien entfernen (Duplikate verhindern)  
rm -f /etc/apt/sources.list.d/mongodb-org*.list

# 3️⃣ MongoDB 4.4 installieren (AVX nicht erforderlich)  
msg_info "Installing MongoDB 4.4 (AVX not required)"
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc \
  | gpg --dearmor >/usr/share/keyrings/mongodb-org-4.4.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-org-4.4.gpg] \
https://repo.mongodb.org/apt/debian $(grep -Po '(?<=^VERSION_CODENAME=).+' /etc/os-release)/mongodb-org/4.4 main" \
  >/etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
msg_ok "MongoDB 4.4 installed"

# 4️⃣ Omada Controller herunterladen & installieren/aktualisieren
update_script

# 5️⃣ Abschlussmeldung
msg_ok "Completed Successfully!"
echo -e "${INFO}Access it using the following URL:"
echo -e "${TAB}${GATEWAY}${BGN}https://${IP}:8043${CL}"
