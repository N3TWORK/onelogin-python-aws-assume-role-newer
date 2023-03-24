#!/bin/bash

function is_valid_email() {
  local email=$1
  local regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"

  if [[ $email =~ $regex ]]; then
    return 0
  else
    return 1
  fi
}

EMAIL=$1
SCRIPT_DIR=$(dirname -- "$0")
VENV_DIR="venv"
cd $SCRIPT_DIR
ONELOGIN_SDK_JSON="onelogin.sdk.json"

# configures local python environment
if [[ -d $VENV_DIR ]]; then
  source venv/bin/activate
else
  python3 -m venv venv
  source venv/bin/activate
  pip3 install -r requirements.txt
fi

# checks for the developer emails
if ! is_valid_email "$EMAIL"; then
  echo "Error: Missing required developer's email account, in the aws-credentials.sh script CLI"
  exit 1
fi

# checks if the onelogin.sdk.json file exists
if [[ ! -f $ONELOGIN_SDK_JSON ]]; then
  echo "Error: onelogin.sdk.json file not found in the script directory. Please create one at this (relative) path: ./$SCRIPT_DIR"
  exit 1
fi

# for output in stdout
python3 src/onelogin/aws-assume-role/aws-assume-role.py -a 843789 -d n3twork -z 43200 -u $EMAIL --aws-region us-east-1 --onelogin-password $(security find-internet-password -a $EMAIL -s onelogin -w) --role_order
# use this to add password: security add-internet-password -a $EMAIL -s onelogin -w
# also remember to add the files onelogin.sdk.json and accounts.yaml inside onelogin-python-aws-assume-role folder

# if you want to save it on default profile
# python3 src/onelogin/aws-assume-role/aws-assume-role.py --profile default -a 843789 -d n3twork -z 43200 -u $EMAIL --aws-region us-east-1 --onelogin-password $(security find-internet-password -a $EMAIL -s 
# onelogin -w) --role_order
