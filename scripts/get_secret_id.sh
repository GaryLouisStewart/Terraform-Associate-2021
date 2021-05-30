#!/usr/bin/env bash
# script to obtain the acl token ID for our users in terraform.


function write_secret_token() {

  read -rp "Please enter the file that contains your acl token..." ACL_TOKEN_FILE_NAME

  local acl_token_id="${ACL_TOKEN_FILE_NAME}"
  local query
  local file_path


  if [[ "${acl_token_id}" == "" ]]; then
    echo "Acl token id is null. exiting script...."
    exit 1
  else
    if [[ -f "${acl_token_id}" ]]; then
      echo "Obtaining acl token information"
      acl_token_id=$(cat "${ACL_TOKEN_FILE_NAME}")
      query=$(consul acl token read -id "${acl_token_id}" -format json | jq -r .SecretID )
      file_path="secret_token.txt"
      echo "${query}" > ./"${file_path}"
    else
      echo "Filename: ${acl_token_id},  does not exist in the current directory, please check that you have the correct filename, exiting script..."
      exit 1
    fi
  fi
}

function write_secret_id() {
  read -rp "Please enter the username that you wish to query information for..." CONSUL_USER

  local consul_username_id="${CONSUL_USER}"
  local tf_query
  local file_path

  if [[ "${consul_username_id}" == "" ]]; then
    echo "consul username is null, exiting script...."
    exit 1
  else
    echo "setting up terraform query....."
    file_path="./${consul_username_id}-secret_id.txt"
    tf_query=$(terraform output -json | jq -r .consul_acl_token_"${consul_username_id}".value)

    echo "Writing secret id to the following file: ${file_path}"
    echo "${tf_query}" > "${file_path}"
  fi
}

function usage() {
       echo "Usage: [ -tf, --terraform-query | -acl, --acl-query,  | -h, --help]"
       echo "-tf, --terraform-query, runs a terraform output with a JQ filter to give us the secret ID for our consul-user"
       echo "-acl, --acl-query, runs a consul acl token read command with the ID flag to give us the "
       echo "-h, --help, displays this help menu"
}

opt=$1
case $opt
in
     -tf | --terraform-query)
     write_secret_id
     ;;
     -acl | --acl-query)
     write_secret_token
     ;;
     -h | --help)
     usage
     ;;
     *)
     echo "Command unknown, for more information, ./get_secret_id.sh -h"
     exit
     ;;
esac