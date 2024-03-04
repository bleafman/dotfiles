# Specific to BUILT

## ASDF (used for Helm/Kubectl)
. /opt/homebrew/opt/asdf/libexec/asdf.sh

## Built AWS Creds
export AWS_SHARED_CREDENTIALS_FILE=~/.aws/aws-developer

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

## mysql@5.7
export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"

# Built Aliases
alias awsd='aws_dev'
alias awsdp='aws_dev_principal'
alias awspd='aws_prod_developer'
alias rr="~/Code/built/inspections-product-api/Makefiles/scripts/rerunner.sh"

# DB LOGIN
# Dev
alias db_dev_bapi='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db dev-cla-bapi8-us-east-1 --dbuser SamlDbReadAccess'
alias db_dev_soa='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db dev-cla-soa8-us-east-1 --dbuser SamlDbReadAccess'
# OPS
alias db_ops_bapi='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db ops-cla-bapi8-us-east-1 --dbuser SamlDbReadAccess'
alias db_ops_soa='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db ops-cla-soa8-us-east-1 --dbuser SamlDbReadAccess'
# STAGING
alias db_staging_bapi='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db staging-cla-bapi8-us-east-1 --dbuser SamlDbReadAccess'
alias db_staging_soa='AWS_PROFILE=Built-Dev/BuiltDeveloper awslogin mysql-login --db staging-cla-soa8-us-east-1 --dbuser SamlDbReadAccess'
#PROD
alias db_prod_bapi='AWS_PROFILE=Built-Root/BuiltSupport_067182029689 awslogin mysql-login --db prod-cla-bapi8-replica-us-east-1 --dbuser SamlDbReadAccess'
alias db_prod_soa='AWS_PROFILE=Built-Root/BuiltSupport_067182029689 awslogin mysql-login --db prod-cla-soa8-us-east-1 --dbuser SamlDbReadAccess'
#Demo
alias db_demo_bapi='AWS_PROFILE=Built-Root/BuiltSupport_067182029689 awslogin mysql-login --db demo-cla-bapi8-us-east-1 --dbuser SamlDbReadAccess'
alias db_demo_soa='AWS_PROFILE=Built-Root/BuiltSupport_067182029689 awslogin mysql-login --db demo-cla-soa8-us-east-1 --dbuser SamlDbReadAccess'

# Built Functions
function ecr_login() {
  echo "logging into AWS ECR"

  if ! type jq >/dev/null; then
    echo "jq command not found. Please install jq."
    exit 1
  fi

  ACCOUNT=$(aws sts get-caller-identity)
  echo $ACCOUNT
  echo ---------------

  ACCOUNTNUMBER=$(echo $ACCOUNT | jq -r '.Account')
  echo $ACCOUNTNUMBER

  aws ecr get-login-password --region us-east-1 | docker login \
    --username AWS \
    --password-stdin $ACCOUNTNUMBER.dkr.ecr.us-east-1.amazonaws.com

  echo "Done"
}

k8sup() {
  kubectl --namespace $(whoami | sed 's/\./-/g') scale deployments -l "app.kubernetes.io/managed-by=Helm" --replicas=1
}

#compdef built_repo_checks
_built_repo_checks_completion() {
  eval $(env _TYPER_COMPLETE_ARGS="${words[1, $CURRENT]}" _BUILT_REPO_CHECKS_COMPLETE=complete_zsh built_repo_checks)
}

compdef _built_repo_checks_completion built_repo_checks

# awslogin completions
autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc
