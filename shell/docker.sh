# Docker compose helpers

# Tail logs for one container, or all if no arg given
dl() {
  local container="${1:-}"
  if [[ -z "$container" ]]; then
    docker compose logs -f
  else
    docker compose logs -f "$container"
  fi
}

# Restart a docker compose service
dcr() {
  if [[ -z "$1" ]]; then
    echo "Usage: dcr <container>"
    return 1
  fi
  docker compose restart "$1"
}
