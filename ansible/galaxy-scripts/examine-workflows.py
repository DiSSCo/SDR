import argparse
from bioblend.galaxy import GalaxyInstance
import copy
from datetime import datetime
from pprint import pprint
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Add workflows', description='')
parser.add_argument('--api-key' , required=True)
parser.add_argument('--server'   , required=True)
args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=args.api_key)

# -----------------------------------------------------------------------------
# List workflows

now = datetime.now()
now_str = now.strftime("%d/%m/%Y %H:%M:%S")

workflow = gi.workflows.get_workflows(name='Test2')[0]

workflow_id = workflow['id']
workflow_data = gi.workflows.show_workflow(workflow_id)

pprint(gi.workflows.show_workflow(workflow_id)['inputs'])

params = {'0': {'owdb': '20.5000.1025/64ae0cf0dacb7bd20ba5'}}
pprint(params)

invoke = gi.workflows.invoke_workflow(workflow_id=workflow_id,
                                      inputs=None,
                                      params=params,
                                      history_id=None,
                                      history_name=f'Testworkflow({now_str})',
                                      import_inputs_to_history=False,
                                      replacement_params=None,
                                      allow_tool_state_corrections=False,
                                      inputs_by=None,
                                      parameters_normalized=True)
