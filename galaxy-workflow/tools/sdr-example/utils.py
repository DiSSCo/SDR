#!/usr/bin/env python

import argparse
import json
from functools import wraps


def parse_args(func):
    
    @wraps(func)
    def decorated():
        parser = argparse.ArgumentParser()
        
        parser.add_argument(
            '-i',
            '--input',
            required=True,
            help='')
        
        parser.add_argument(
            '-o',
            '--output',
            required=True,
            help='')
        
        args, unknown_args = parser.parse_known_args() 
        
        # Unpack the unknown_args into the params dictionary
        params = {unknown_args[i].replace('--', ''): unknown_args[i+1] for i in range(0,len(unknown_args),2)}
        
        with open(args.input) as json_file:    
            opends_json = json.load(json_file)    

        return func(opends_json, args.output, **params)
    
    return decorated

def write_opends_to_output_file(opends_json, output_file):
    with open(output_file, 'w') as f:
        json.dump(opends_json, f)    
