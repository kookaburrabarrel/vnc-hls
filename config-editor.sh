#!/usr/bin/env bash
set -euo pipefail

CONFIG_FILE="config.json"
TMP_FILE="$(mktemp)"

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
SOFTGRAY='\033[0;37m'
ITALIC='\033[3m'
RESET='\033[0m'

if ! command -v jq &> /dev/null; then
  echo -e "${CYAN}jq not found. Please install it.${RESET}"
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo -e "${CYAN}$CONFIG_FILE not found.${RESET}"
  exit 1
fi

echo -e "${CYAN}=== Loading configuration from $CONFIG_FILE ===${RESET}"

prompt() {
  local label="$1"
  local default_val="$2"
  local example="$3"
  printf "${YELLOW}%s${RESET} ${SOFTGRAY}${ITALIC}(ex. %s)${RESET} [%s]: " "$label" "$example" "$default_val"
  IFS= read -r input < /dev/tty
  echo "${input:-$default_val}"
}

update_url_from_ip_port() {
  local key="$1"
  local old_url
  old_url=$(jq -r --arg k "$key" '.[$k]' "$CONFIG_FILE")

  # Extract old IP and port from URL like http://IP:PORT
  local old_ip="127.0.0.1"
  local old_port="80"
  if [[ $old_url =~ http://([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ]]; then
    old_ip="${BASH_REMATCH[1]}"
    old_port="${BASH_REMATCH[2]}"
  fi

  echo -e "\n${CYAN}→ Configuring ${key}${RESET}"

  local new_ip new_port
  new_ip=$(prompt "$key IP" "$old_ip" "192.168.1.1")
  new_port=$(prompt "$key port" "$old_port" "5000")

  local new_url="http://${new_ip}:${new_port}"
  jq --arg k "$key" --arg v "$new_url" '.[$k]=$v' "$CONFIG_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$CONFIG_FILE"
}

update_simple_key() {
  local key="$1"
  local old_val
  old_val=$(jq -r --arg k "$key" '.[$k] // ""' "$CONFIG_FILE")
  local example="example"
  case "$key" in
    archiver_port|archive_status_port)
      example="5000"
      ;;
    title)
      example="T-Bar Gates Dashboard"
      ;;
  esac
  local new_val
  new_val=$(prompt "Enter new value for '$key'" "$old_val" "$example")
  jq --arg k "$key" --arg v "$new_val" '.[$k] = $v' "$CONFIG_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$CONFIG_FILE"
}

update_gate_count() {
  local old_val
  old_val=$(jq -r '.gate_count // ""' "$CONFIG_FILE")
  local new_val
  new_val=$(prompt "Enter gate_count (integer or leave empty)" "$old_val" "3")
  jq --arg v "$new_val" '.gate_count = $v' "$CONFIG_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$CONFIG_FILE"
}

update_lanes() {
  local gate="$1"
  echo -e "\n${CYAN}→ Configuring lanes for gate: ${YELLOW}$gate${RESET}"
  local lanes
  lanes=$(jq -r --arg g "$gate" '.gates[$g] | keys[]' "$CONFIG_FILE")
  for lane in $lanes; do
    local old_ip old_port new_ip new_port
    old_ip=$(jq -r --arg g "$gate" --arg l "$lane" '.gates[$g][$l].ip' "$CONFIG_FILE")
    old_port=$(jq -r --arg g "$gate" --arg l "$lane" '.gates[$g][$l].port' "$CONFIG_FILE")

    new_ip=$(prompt "$gate/$lane: Enter IP" "$old_ip" "192.168.1.10")
    new_port=$(prompt "$gate/$lane: Enter port" "$old_port" "5900")

    jq --arg g "$gate" --arg l "$lane" --arg ip "$new_ip" --argjson port "$new_port" \
      '.gates[$g][$l].ip = $ip | .gates[$g][$l].port = $port' \
      "$CONFIG_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$CONFIG_FILE"
  done
}

# === Execute ===
echo
echo -e "${CYAN}=== Customize Top-Level Settings ===${RESET}"
update_url_from_ip_port "archive_url"
update_url_from_ip_port "status_url"
update_simple_key "archiver_port"
update_simple_key "archive_status_port"
update_gate_count
update_simple_key "title"

echo
echo -e "${CYAN}=== Customize Gates ===${RESET}"
for gate in $(jq -r '.gates | keys[]' "$CONFIG_FILE"); do
  update_lanes "$gate"
done

echo -e "\n${GREEN}✔ Configuration updated successfully in $CONFIG_FILE${RESET}"
