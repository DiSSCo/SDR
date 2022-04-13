import argparse
from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy.toolshed import ToolShedClient
import requests
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--username'     , required=True)
parser.add_argument('--password'     , required=True)
parser.add_argument('--server'       , required=True)
parser.add_argument('--toolshed-url' , required=True)
parser.add_argument('--tool-name'    , required=True)
parser.add_argument('--tool-owner'   , required=True)
parser.add_argument('--tool-revision', required=True)
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
# Get toolshed instance and install tool

ts = ToolShedClient(gi)
ts.install_repository_revision(tool_shed_url=args.toolshed_url,
                               name=args.tool_name,
                               owner=args.tool_owner,
                               changeset_revision=args.tool-revision,
                               install_tool_dependencies=True,
                               install_repository_dependencies=True,
                               tool_panel_section_id=None,
                               new_tool_panel_section_label=None
                               )
