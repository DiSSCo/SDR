#!/usr/bin/env python

import logging
from utils import parse_args, write_opends_to_output_file


log = logging.getLogger(__name__)


@parse_args
def __main__(opends_json, output_file, taxon, image):
    
    log.debug("Running SDR Example Tool")
    
    ####### Tool to do it's thing and modify opends_json #######
    opends_json['example_output'] = taxon
    opends_json['example_image'] = image
    
    # TODO: Should we validate the output of the tool against openDS schema
    
    ####### Write the modified opends_json to the output_file #######
    write_opends_to_output_file(opends_json, output_file)    


if __name__ == "__main__":
    __main__()        