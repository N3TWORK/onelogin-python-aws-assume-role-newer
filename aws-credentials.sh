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
ONELOGIN_SDK_JSON="$SCRIPT_DIR/onelogin.sdk.json"

# checks for the developer emails
if ! is_valid_email "$EMAIL"; then
  echo "Error: Missing required developer's email account, in the aws-credentials.sh script CLI"
  exit 1
fi

# checks if the onelogin.sdk.json file exists
if [[ ! -f $ONELOGIN_SDK_JSON ]]; then
  echo "Error: onelogin.sdk.json file not found in the script directory. Please create one at this path: $SCRIPT_DIR"
  exit 1
fi

python3 -m venv $SCRIPT_DIR/venv
source $SCRIPT_DIR/venv/bin/activate
pip3 install -r $SCRIPT_DIR/requirements.txt

# for output in stdout
python3 $SCRIPT_DIR/src/onelogin/aws-assume-role/aws-assume-role.py -a 843789 -d n3twork -z 43200 -u $EMAIL --aws-region us-east-1 --onelogin-password $(security find-internet-password -a $EMAIL -s onelogin -w) --role_order
# use this to add password: security add-internet-password -a $EMAIL -s onelogin -w
# also remember to add the files onelogin.sdk.json and accounts.yaml inside onelogin-python-aws-assume-role folder

# if you want to save it on default profile
# python3 src/onelogin/aws-assume-role/aws-assume-role.py --profile default -a 843789 -d n3twork -z 43200 -u $EMAIL --aws-region us-east-1 --onelogin-password $(security find-internet-password -a $EMAIL -s 
# onelogin -w) --role_order
