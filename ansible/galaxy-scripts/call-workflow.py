import argparse
from bioblend.galaxy import GalaxyInstance
from datetime import datetime
from pprint import pprint
import sys

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Call SDR workflow', description='')
parser.add_argument('--api-key'   , required=True)
parser.add_argument('--server'    , required=True)
parser.add_argument('--input-file', required=True, type=str)

args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = GalaxyInstance(url=args.server, key=args.api_key)

# -----------------------------------------------------------------------------
# Get workflow object

workflow = gi.workflows.get_workflows(name='De novo digitisation')
workflow_id = workflow[0]['id']
print(f"Call workflow: workflow_id = {workflow_id}")

# -----------------------------------------------------------------------------
# Create history 

now = datetime.now()
now_str = now.strftime("%d/%m/%Y %H:%M:%S")

history_id = gi.histories.create_history(f'De Novo Digitisation ({now_str})')['id']
print(f"Call workflow: history_id = {history_id}")

# -----------------------------------------------------------------------------
# Upload input file

uploaded_file = gi.tools.upload_file(args.input_file, history_id)
# uploaded_file_id = uploaded_file['outputs'][0]['id']
# print(f"Call workflow: uploaded_file_id = {uploaded_file_id}, uploading...")

# # Await upload
# pprint(gi.datasets.wait_for_dataset(uploaded_file_id))
# print(f"Call workflow: uploaded_file_id = {uploaded_file_id}, uploaded")

# # -----------------------------------------------------------------------------
# # Invoke workflow

# inputs = {'0': {'id': uploaded_file_id, 'src': 'hda'}}
# invoke = gi.workflows.invoke_workflow(workflow_id=workflow_id,
#                                       inputs=inputs,
#                                       history_id=history_id,
#                                       )
# pprint(invoke)
