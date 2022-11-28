import argparse
from bioblend.galaxy import GalaxyInstance
import os
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--api-key'           , required=True)
parser.add_argument('--server'            , required=True)
parser.add_argument('--tool-path'         , required=False)
parser.add_argument('--new-user-name'     , required=True)
parser.add_argument('--new-user-email'    , required=True)
parser.add_argument('--new-user-password' , required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance using master key (cannot import workflows)

master_gi = GalaxyInstance(url=args.server, key=args.api_key)

# -----------------------------------------------------------------------------
# Check for existing user by same name or email, record or create API key if found and needed

user_api_key = -1
id_index = master_gi.users.get_users()

for existing_user in master_gi.users.get_users():
    if (existing_user['email'] == args.new_user_email or
        existing_user['username'] == args.new_user_name):
        user_api_key = master_gi.users.get_user_apikey(existing_user['id'])
        if (user_api_key == 'Not available.'):
            user_api_key = master_gi.users.create_user_apikey(existing_user['id'])
            
# -----------------------------------------------------------------------------
# Create the user

if user_api_key == -1:
    user = master_gi.users.create_local_user(username=args.new_user_name,
                                             user_email=args.new_user_email,
                                             password=args.new_user_password
                                             )
    user_api_key = master_gi.users.create_user_apikey(user['id'])

# -----------------------------------------------------------------------------
# Get galaxy instance as new user

gi = GalaxyInstance(url=args.server, key=user_api_key)

# -----------------------------------------------------------------------------
# Give the user access to the SDR workflows, via filepath if specified or using shared workflows if not

if args.tool_path is not None:
    workflow_files = os.listdir(args.tool_path)
    for workflow_file in workflow_files:
        gi.workflows.import_workflow_from_local_path(f"{args.tool_path}/{workflow_file}")
else:
    workflows = gi.workflows.get_workflows(published=True)
    for workflow in workflows:
        if workflow['published'] is True:
            gi.workflows.import_shared_workflow(workflow['id'])

# -----------------------------------------------------------------------------
# Print the API key

print(user_api_key)
