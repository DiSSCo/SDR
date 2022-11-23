import argparse
from bioblend.galaxy import GalaxyInstance
import os
from pprint import pprint
import requests
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--server'       , required=True)
parser.add_argument('--admin-api-key', required=True)
parser.add_argument('--tool-path'    , required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=args.admin_api_key)

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
