import argparse
import os
from pathlib import Path
import shutil
import sys


# TODO should be replaced with env variable
galaxy_root = '/srv/galaxy/server/results/'


def main(args):
    rootdir      = f'{galaxy_root}/'
    batchdir     = f'{rootdir}/{args.batch_id}'
    file_listing = f'{rootdir}/files'

    opends_filename = os.path.basename(args.opends_path)
    outputfile   = f'{batchdir}/{opends_filename}'

    # Create path to output if needed
    Path(batchdir).mkdir(parents=True, exist_ok=True)

    # Copy OpenDS file to output
    shutil.copyfile(args.opends_path, outputfile)

    # Create file listing file
    with open(file_listing, 'w') as output:
        output.write(outputfile)

    return


def parse_args(raw_args):
    parser = argparse.ArgumentParser(prog='Save output',
                                     description='Options for the validate_opends wrapper')
    parser.add_argument('--opends-path', required=True)
    parser.add_argument('--batch-id', required=True)
    args = parser.parse_args(raw_args)
    return args


if __name__ == '__main__':
    args = parse_args(sys.argv[1:])
    main(args)
    print(args.opends_path)
