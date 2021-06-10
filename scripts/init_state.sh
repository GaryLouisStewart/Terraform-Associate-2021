#!/usr/bin/env bash
# initializes the terraform statefile using the local consul-backend

read -rp "Please enter the terraform state path..." TF_STATE_PATH

if [[ "${TF_STATE_PATH}" == "" ]]; then
  echo "Terraform state path is not set, exiting script..."
  exit 1
else
  echo "setting backend to: ${TF_STATE_PATH}..."
  terraform init -backend-config="path=${TF_STATE_PATH}"
fi
