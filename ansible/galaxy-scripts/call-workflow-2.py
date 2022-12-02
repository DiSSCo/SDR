import argparse
from datetime import datetime
from pprint import pprint
import sys
import bioblend.galaxy.objects

# -----------------------------------------------------------------------------
# Parse arguments

parser = argparse.ArgumentParser(prog='Call SDR workflow', description='')
parser.add_argument('--api-key'   , required=True)
parser.add_argument('--server'    , required=True)
parser.add_argument('--input-file', required=True, type=str)

args = parser.parse_args(sys.argv[1:])

# -----------------------------------------------------------------------------
# Get galaxy instance

gi = bioblend.galaxy.objects.GalaxyInstance(url=args.server, api_key=args.api_key)

# -----------------------------------------------------------------------------
# Create history 

pprint(gi.histories.get_previews())

now = datetime.now()
now_str = now.strftime("%d/%m/%Y %H:%M:%S")
new_hist = gi.histories.create(name=f'De Novo Digitisation ({now_str})')

# -----------------------------------------------------------------------------
# Upload input file

hda = new_hist.upload_file("1.txt")
