import argparse
from bioblend.galaxy import GalaxyInstance
from bioblend.galaxy.toolshed import ToolShedClient
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--api-key'      , required=True)
parser.add_argument('--server'       , required=True)
parser.add_argument('--toolshed-url' , required=True)
parser.add_argument('--tool-name'    , required=True)
parser.add_argument('--tool-owner'   , required=True)
parser.add_argument('--tool-revision', required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=args.api_key)

# -----------------------------------------------------------------------------
# Get toolshed instance and install tool

ts = ToolShedClient(gi)

output = ts.install_repository_revision(tool_shed_url=args.toolshed_url,
                                        name=args.tool_name,
                                        owner=args.tool_owner,
                                        changeset_revision=args.tool_revision,
                                        install_tool_dependencies=True,
                                        install_repository_dependencies=True,
                                        tool_panel_section_id=None,
                                        new_tool_panel_section_label=None
                                        )
print(output)
