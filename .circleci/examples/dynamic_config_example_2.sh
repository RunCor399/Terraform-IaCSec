#!/bin/bash 
set -o pipefail

TF_VERSION=$1 #Terraform CLI Version to install
DOCTL_VERSION=$2 #Digital Ocean CLI Version to install

mkdir configs/
cat << EOF > configs/generated_config.yml
version: 2.1
orbs:
  docker: circleci/docker@1.5.0
  node: circleci/node@4.2.0
  snyk: snyk/snyk@0.0.12
  terraform: circleci/terraform@2.0.0  
jobs:
  scan_app:
    docker:
      - image: circleci/node:12
    steps:
      - checkout
      - run: echo "TF_VERSION and DOCTL_VERSION variables \ 
                   can be used as parameters of this configuration"

workflows:
  scan_deploy:
    jobs:
      - scan_app
EOF





