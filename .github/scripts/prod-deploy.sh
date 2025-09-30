#!/bin/bash
set -e

echo "Starting Production deployment..."

cd ..
# clone deployment playbook
git clone --single-branch --branch main git@github.com:tulibraries/ansible-playbook-gencon50.git
cd ansible-playbook-gencon50

# install playbook requirements
pipenv install
# install playbook role requirements
pipenv run ansible-galaxy install -r requirements.yml

# setup vault password
echo "$ANSIBLE_VAULT_PASSWORD" > ~/.vault

# deploy to production using ansible-playbook
echo "Running: pipenv run ansible-playbook -i inventory/prod playbook.yml --vault-password-file=~/.vault -e rails_app_git_branch=$RAILS_APP_GIT_BRANCH"
pipenv run ansible-playbook -i inventory/prod playbook.yml --vault-password-file=~/.vault -e rails_app_git_branch="$RAILS_APP_GIT_BRANCH"

echo "Production deployment completed successfully!"
