resource "vultr_startup_script" "ts_install" {
    name = "01-configure-tailscale"
    script = filebase64("${path.module}/scripts/01-configure-tailscale.sh")
}

# os search -> curl "https://api.vultr.com/v2/os"   -X GET   -H "Authorization: Bearer ${VULTR_API_KEY}" | jq '.os[] | select(.family=="debian")'
# {
#   "id": 352,
#   "name": "Debian 10 x64 (buster)",
#   "arch": "x64",
#   "family": "debian"
# }
# {
#   "id": 477,
#   "name": "Debian 11 x64 (bullseye)",
#   "arch": "x64",
#   "family": "debian"
# }
data "vultr_os" "debian_11" {
    filter {
        name = "name"
        values = [ "Debian 11 x64 (bullseye)" ]
    }
}

resource vultr_firewall_group ts_exit_nodes {
    description = "Firewall group assigned to tailscale exit nodes deployed in the tenancy."
}

resource vultr_firewall_rule fwr_ssh {
    firewall_group_id = vultr_firewall_group.ts_exit_nodes.id 
    protocol = "tcp"
    ip_type = "v4"
    subnet = "0.0.0.0"
    subnet_size = 0
    port = 22
    notes = "[TEMP] Allow ssh ingress to host"
}

resource "vultr_instance" "ts-exit-node" {
    for_each = toset(var.ts_node_regions)
    plan = "vc2-1c-1gb"
    region = each.value
    os_id = data.vultr_os.debian_11.id
    script_id = vultr_startup_script.ts_install.id
    firewall_group_id = vultr_firewall_group.ts_exit_nodes.id 
    enable_ipv6 = false
    backups = "disabled"
    ddos_protection = false
    activation_email = false
    label = "ts-exit-${each.value}"
    user_data = templatefile("${path.module}/templates/00-user-data.tftmpl", {
        ts_backend_server = var.ts_backend_server,
        ts_preauth_key    = var.ts_preauth_key,
    })
    hostname = "ts-exit-${each.value}"
    lifecycle {
        ignore_changes = [
            # Ignore changes to tags, e.g. because a management agent
            # updates these based on some ruleset managed elsewhere.
            user_data,
        ]
    }
}
