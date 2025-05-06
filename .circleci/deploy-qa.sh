#!/bin/bash
set -e

cd ..
# clone deployment playbook
git clone --single-branch --branch main git@github.com:tulibraries/ansible-playbook-gencon50.git
cd ansible-playbook-gencon50
# install playbook requirements
pipenv install
# install playbook role requirements
pipenv run ansible-galaxy install -r requirements.yml

# setup vault password retrieval from travis envvar

echo $ANSIBLE_VAULT_PASSWORD > ~/.vault
#chmod +x ~/.vault

# deploy to qa using ansible-playbook
echo "Running: pipenv run ansible-playbook -i inventory/qa playbook.yml --vault-password-file=~/.vault"
pipenv run ansible-playbook -i inventory/qa playbook.yml --vault-password-file=~/.vault
