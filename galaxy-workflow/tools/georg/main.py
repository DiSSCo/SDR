#!/usr/bin/env python

import logging
import requests
import argparse
import json
import sys


log = logging.getLogger(__name__)


GEORG_API_SEARCH_ENDPOINT = 'https://georg-stage.nrm.se/api/search'

def __main__(input, output):
    
    log.debug("Running GEORG Search")
    
    with open(input) as open_input:
        open_DS = json.load(open_input)
    
        locality = open_DS.get('locality')
        country_code = open_DS.get('countryCode')
        
        if not locality:
            raise Exception("Specimen locality string not present in open digital specimen object (expected at $.locality)")  
        
        georg_result = georg_do_search(locality, country_code)
        
        if errors := georg_result['geocoding'].get('errors'):
            raise Exception(errors)  
        
        log.debug("Selecting 1st result out of %d returned from GEORG Search API", len(georg_result['features']))
        
        open_DS['geocoding'] = georg_result['features'][0]

        # Georg result includes geocoding information, which is relevant to specimen provenance
        open_DS.setdefault("provenance", {})    
        open_DS['provenance']['geocoding'] = georg_result['geocoding']
        print(open_DS)
   
def georg_do_search(text, country_code=None):
    params = {'text': text}
    if country_code: params['countryCode'] = country_code
    
    print(params)
    
    r = requests.get(GEORG_API_SEARCH_ENDPOINT, params=params, verify=False)
    r.raise_for_status()
    return r.json()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-i','--input', required=True)
    parser.add_argument('-o','--output', required=True)
    
    args = parser.parse_args()

    __main__(args.input, args.output)
