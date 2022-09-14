import argparse
import json
import sys
import pandas as pd


def main(args):
    # -------------------------------------------------------------------------
    #  Parse input

    with open(args.input) as opends_file:
        opends_json = json.load(opends_file)
        opends_dataframe = pd.json_normalize(opends_json)

        # -------------------------------------------------------------------------
        #  Print

        opends_csv = opends_dataframe.to_csv(index=False)
        print(opends_csv)


def parse_args(raw_args):
    parser = argparse.ArgumentParser(prog='OpenDS to CSV',
                                     description='Options for the opends-to-csv wrapper')
    parser.add_argument('--input' , required=True)

    args = parser.parse_args(raw_args)
    return args


if __name__ == "__main__":
    args = parse_args(sys.argv[1:])
    main(args)

