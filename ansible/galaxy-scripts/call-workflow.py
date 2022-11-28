import argparse
from bioblend.galaxy import GalaxyInstance
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
# Get workflow object

workflow = gi.workflows.get_workflows(name='ROCrate Output')
workflow_id = workflow[0]['id']

# -----------------------------------------------------------------------------
# Upload input file

now = datetime.now()
now_str = now.strftime("%d/%m/%Y %H:%M:%S")

history_id = gi.histories.create_history(f'Test workflow ({now_str})')['id']

uploaded_file = gi.tools.upload_file('/home/owool/Downloads/PinnedInsect-5Row-Example.csv',
                                     history_id)
uploaded_file_id = uploaded_file['outputs'][0]['id']
pprint(gi.datasets.wait_for_dataset(uploaded_file_id))

inputs = {'0': {'id': uploaded_file_id, 'src': 'hda'}}
invoke = gi.workflows.invoke_workflow(workflow_id=workflow_id,
                                      inputs=inputs,
                                      history_id=history_id,
                                      )
pprint(invoke)
