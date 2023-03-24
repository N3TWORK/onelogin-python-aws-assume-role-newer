
cd ~/Desktop/platform/onelogin-python-aws-assume-role # CHANGE IT TO YOUR CLONE REPOSITORY FOLDER
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt

# for output in stdout
python3 src/onelogin/aws-assume-role/aws-assume-role.py -a 843789 -d n3twork -z 43200 -u fapablaza@n3twork.com --aws-region us-east-1 --onelogin-password $(security find-internet-password -a fapablaza@n3twork.com -s onelogin -w) --role_order
# use this to add password: security add-internet-password -a fapablaza@n3twork.com -s onelogin -w
# also remember to add the files onelogin.sdk.json and accounts.yaml inside onelogin-python-aws-assume-role folder

# if you want to save it on default profile
# python3 src/onelogin/aws-assume-role/aws-assume-role.py --profile default -a 843789 -d n3twork -z 43200 -u fapablaza@n3twork.com --aws-region us-east-1 --onelogin-password $(security find-internet-password -a fapablaza@n3twork.com -s 
# onelogin -w) --role_order
