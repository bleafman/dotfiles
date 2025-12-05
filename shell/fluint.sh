alias mongosh-uat="mongosh $MONGO_UAT_URL"
alias mongosh-prod="mongosh $MONGO_PROD_URL"
alias mongosh-qa="mongosh $MONGO_QA_URL"

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