import argparse
from bioblend.galaxy import GalaxyInstance
import os
from pprint import pprint
import requests
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--username' , required=True)
parser.add_argument('--password' , required=True)
parser.add_argument('--server'   , required=True)
parser.add_argument('--tool-path', required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get API key

auth_url = f'{args.server}/api/authenticate/baseauth'
api_response = requests.get(auth_url, data={}, auth=(args.username, args.password))
print(api_response.text)
api_key = api_response.json()['api_key']

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=api_key)

# -----------------------------------------------------------------------------
# Import workflows

workflow_files = os.listdir(args.tool_path)
for workflow_file in workflow_files:
    gi.workflows.import_workflow_from_local_path(f"{args.tool_path}/{workflow_file}")

# -----------------------------------------------------------------------------
# Share workflows

workflows = gi.workflows.get_workflows()

for workflow in workflows:
    result = gi.workflows.update_workflow(workflow['id'],
                                          published=True,
                                          menu_entry=True)

workflows = gi.workflows.get_workflows()
for workflow in workflows:
    print(f"{workflow['name']} pub: {workflow['published']}")
    pprint(workflow)
