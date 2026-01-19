# Flexible Docker functions
dl() {
  local container="${1:-}"
  if [[ -z "$container" ]]; then
    docker compose logs -f
  else
    docker compose logs -f "$container"
  fi
}

dcr() {
  if [[ -z "$1" ]]; then
    echo "Usage: dcr <container>"
    return 1
  fi
  docker compose restart "$1"
}

# Mongosh connections (functions so env vars expand at runtime)
mongosh-uat() { mongosh "$MONGO_UAT_URL" "$@"; }
mongosh-prod() { mongosh "$MONGO_PROD_URL" "$@"; }
mongosh-qa() { mongosh "$MONGO_QA_URL" "$@"; }

alias dlapi="docker logs -f workstation-v2-be-api-1"
alias dlevents="docker logs -f workstation-v2-be-events-1"
alias dlfe="docker logs -f workstation-v2-fe-1"
alias dlchat="docker logs -f workstation-v2-be-chat-api-1"
alias dlservice="docker logs -f workstation-v2-be-service-1"
alias dlagen="docker logs -f workstation-v2-be-agent-gen-1"
alias dcrapi='docker compose restart be-api'
alias dcrbe='docker compose restart be-api be-events be-service'
alias dcrchat='docker compose restart be-chat-api'
alias dcrservice='docker compose restart be-service'

npm-login() {
    echo "Starting AWS SSO login..."
    aws sso login
    echo "AWS SSO login complete. Logging into CodeArtifact..."
    aws codeartifact login --domain fluint --domain-owner 008776105309 --repository artifacts --tool npm
    echo "CodeArtifact login complete."
}