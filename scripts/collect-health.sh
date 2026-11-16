#!/usr/bin/env bash
# Проверка версий, служб и ресурсов. Настройки не меняет.
set -uo pipefail

usage() {
  printf 'Usage: bash scripts/collect-health.sh server|agent\n'
  printf 'Read-only diagnostics. No automatic sudo, installs or configuration changes.\n'
}

if [[ $# -eq 1 && ( "$1" == '-h' || "$1" == '--help' ) ]]; then
  usage
  exit 0
fi
if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi
case "$1" in
  server)
    services=(wazuh-manager wazuh-indexer filebeat wazuh-dashboard)
    packages=(wazuh-manager wazuh-indexer wazuh-dashboard filebeat)
    ;;
  agent)
    services=(wazuh-agent)
    packages=(wazuh-agent)
    ;;
  *) usage >&2; exit 2 ;;
esac

printf 'Wazuh lab: service and package check\n'
printf 'Role: %s\n' "$1"
printf 'Time: '
date -Iseconds
printf '\nOS release:\n'
if [[ -r /etc/os-release ]]; then
  # Read a descriptive value without sourcing executable shell content.
  sed -n 's/^PRETTY_NAME=//p' /etc/os-release
else
  printf '/etc/os-release unavailable\n'
fi
printf '\nInstalled package versions:\n'
if command -v dpkg-query >/dev/null 2>&1; then
  for package in "${packages[@]}"; do
    if ! dpkg-query -W -f='${binary:Package}\t${Version}\n' "$package" 2>/dev/null; then
      printf '%s: not installed or unavailable\n' "$package"
    fi
  done
else
  printf 'dpkg-query unavailable\n'
fi

printf '\nService activity (not a delivery test):\n'
if command -v systemctl >/dev/null 2>&1; then
  for service in "${services[@]}"; do
    if state=$(systemctl is-active "$service" 2>/dev/null); then
      printf '%s: %s\n' "$service" "$state"
    else
      printf '%s: %s (or systemd unavailable)\n' "$service" "${state:-unknown}"
    fi
  done
else
  printf 'systemctl unavailable\n'
fi
printf '\nMemory:\n'
if command -v free >/dev/null 2>&1; then free -h; fi
printf '\nRoot filesystem:\n'
df -h / 2>/dev/null || true
printf '\nNo logs, credentials, IP addresses or agent keys were collected.\n'
printf 'This snapshot does not confirm enrollment, event delivery or alert detection.\n'
