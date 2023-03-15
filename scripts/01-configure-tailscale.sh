#!/bin/bash

systemctl restart systemd-sysctl

curl -fsSL https://tailscale.com/install.sh | sh

systemctl enable --now tailscaled

source /tmp/init.env

[[ -z "${TS_LOGIN_SERVER}" ]] || TS_LOGIN_SERVER="--login-server=${TS_LOGIN_SERVER}"
[[ -z "${TS_AUTH_KEY}" ]]     || TS_AUTH_KEY="--auth-key=${TS_AUTH_KEY}"
[[ -z "${TS_TAGS}" ]]         || TS_TAGS="--advertise-tags=${TS_TAGS}"

TS_HOSTNAME="$(hostname)-$(openssl rand -hex 4)"
TS_HOSTNAME="--hostname=${TS_HOSTNAME}"

cmd="tailscale up ${TS_LOGIN_SERVER} --advertise-exit-node --accept-routes ${TS_AUTH_KEY} ${TS_HOSTNAME} ${TS_TAGS}"

echo "+++++++ Executing: ${cmd}"

${cmd}