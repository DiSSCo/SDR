import argparse
import json
import jsonschema
import sys


def main(args):
    # -----------------------------------------------------------------------
    # Check OpenDS is valid JSON

    opends_json = ''
    try:
        with open(args.opends_path, 'r') as opends_file:
            opends_json = json.load(opends_file)
    except Exception as errormsg:
        sys.stderr.write(f'ERROR! OpenDS specified is not a valid json object.\n'
                         f'{errormsg}\n'
                         )
        return False

    # -------------------------------------------------------------------------
    # Validate OpenDS using jsonschema

    #    try:
    try:
        with open('opends_schema.json', 'r') as opends_schema_file:
            opends_schema = json.load(opends_schema_file)
            jsonschema.validate(instance=opends_json,
                                schema=opends_schema)
    except Exception as errormsg:
        sys.stderr.write(f'ERROR! validate_opends: Failed to validate OpenDS.\n\n'
                         f'{errormsg} \n')
        return False

    # -------------------------------------------------------------------------
    # If valid json and correct against schema, return true

    return True


def parse_args(raw_args):
    parser = argparse.ArgumentParser(prog='Validate OpenDS',
                                     description='Options for the validate_opends wrapper')
    parser.add_argument('--opends-path', required=True)
    args = parser.parse_args(raw_args)
    return args


if __name__ == '__main__':
    args = parse_args(sys.argv[1:])
    valid = main(args)
    print(valid)
