#authored by: Gary Louis Stewart
#Date: 26/05/2021


function exit_error () {
   # call this function internally. Throws an error when the exit code is not '0' does nothing if no error code is passed to it.	
   local exit_code=$1
   shift
   [[ $exit_code ]] &&
      ((exit_code != 0)) && {
        printf 'ERROR: %s \n' "$@" >&2
        exit "$exit_code"
      }
}


function export_aws_keys () {
    read -p "please enter your aws access key id here: " USER_AWS_ACCESS_KEY_ID
    read -p "please enter your aws secret access key here: " USER_AWS_SECRET_ACCESS_KEY
    # evaluate both variables to see if they are empty, if one variable is empty than throw an error.
    local access_key_id="$USER_AWS_ACCESS_KEY_ID"
    local secret_access_key="$USER_AWS_SECRET_ACCESS_KEY"

    if [[ ${access_key_id} == "" ]] || [[ ${secret_access_key} == "" ]]; then
	   echo "One or more values not set, exiting script..."
	   exit_error "$@"
    else
          echo "setting up aws access keys....."
          export AWS_ACCESS_KEY_ID=${access_key_id}	  
          export AWS_SECRET_ACCESS_KEY=${secret_access_key}
    fi	  
}

function test_aws_connectivity() {
  aws sts get-caller-identity
}

function usage() {
      echo "Usage: [ -s, --set-creds | -t, --test,  | -h, --help]"
       echo "-s, --set-creds, sets our aws credentials"
       echo "-t, --test, tests our aws credentials we have set with sts get-caller-identity method"
       echo "-h, --help, displays this help menu"

}
opt=$1
case $opt in
    -s | --set-creds)
    export_aws_keys
    ;;
    -t | --test)
    test_aws_connectivity
    ;;
    -h | --help)
    usage
    ;;
    *)
      usage
      exit
      ;;
esac

