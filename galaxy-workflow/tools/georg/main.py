#!/usr/bin/env python

import logging
import requests

from utils import parse_args, write_opends_to_output_file


log = logging.getLogger(__name__)


GEORG_API_SEARCH_ENDPOINT = 'https://georg-stage.nrm.se/api/search'


@parse_args
def __main__(opends_json, output_file, locality, country_code):
    
    log.debug("Running GEORG Search")
    
    georg_result = georg_search(locality, country_code)
    
    if errors := georg_result['geocoding'].get('errors'):
        raise Exception(errors)  
    
    log.debug("Selecting 1st result out of %d returned from GEORG Search API", len(georg_result['features']))
    
    opends_json['geocoding'] = georg_result['features'][0]
    
    # TODO: Georg result includes geocoding information, which is relevant to specimen provenance
    opends_json.setdefault("provenance", {})    
    opends_json['provenance']['geocoding'] = georg_result['geocoding']
   
    write_opends_to_output_file(opends_json, output_file)    
    

def georg_search(text, country_code=None):
    params = {'text': text}
    if country_code: params['countryCode'] = country_code
    
    r = requests.get(GEORG_API_SEARCH_ENDPOINT, params=params, verify=False)
    r.raise_for_status()
    return r.json()


if __name__ == "__main__":
    georg_result = georg_search('lyme regis', 'GB')        
    print(georg_result)    
