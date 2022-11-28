import argparse
from bioblend.galaxy import GalaxyInstance
import random
import string
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add root user', description='')
parser.add_argument('--master-api-key', required=True)
parser.add_argument('--admin-email'   , required=True)
parser.add_argument('--admin-user'   , required=True)
parser.add_argument('--server'        , required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=args.master_api_key)

# -----------------------------------------------------------------------------
# Check for existing user, record or create API key if found and needed

api_key = -1

for existing_user in gi.users.get_users():
    if (existing_user['email'] == args.admin_email or
        existing_user['username'] == args.admin_user):
        api_key = gi.users.get_user_apikey(existing_user['id'])
        if (api_key == 'Not available.'):
            api_key = gi.users.create_user_apikey(existing_user['id'])

# -----------------------------------------------------------------------------
# If no existing user found, create user and get ID

if api_key == -1:
    random_pass = ''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(16))
    user = gi.users.create_local_user(args.admin_user,
                                      args.admin_email,
                                      str(random_pass))
    api_key = gi.users.create_user_apikey(user['id'])

# -----------------------------------------------------------------------------
# Print the API key

print(api_key)
