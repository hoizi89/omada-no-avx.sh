#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
APP="Omada"
var_cpu=2; var_ram=3072; var_disk=8
var_os="debian"; var_version=12; var_unprivileged=0
header_info "$APP"; variables; color; catch_errors

start
build_container
description

# Überspringe AVX-Check, setze MongoDB 4.4
msg_info "Installing MongoDB 4.4 (AVX not required)"
curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc \
  | gpg --dearmor >/usr/share/keyrings/mongodb-server-4.4.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg] \
http://repo.mongodb.org/apt/debian $(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)/mongodb-org/4.4 main" \
  >/etc/apt/sources.list.d/mongodb-org-4.4.list
$STD apt-get update
$STD apt-get install -y mongodb-org
msg_ok "MongoDB 4.4 installed"

# Rest des Skripts lädt und installiert Omada automatisch
update_script

msg_ok "Completed Successfully!\n…"
echo -e "Access it: https://${IP}:8043"
