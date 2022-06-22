import argparse
import hashlib
import json
import os
from PIL import Image
import ssl
import sys
from urllib import request


def main(args):
    ###########################################################################
    #  Parse input

    input_list = ""
    with open(args.input, 'r') as input:
        input_list = input.read().split(",")

    if (len(input_list) <= 7):
        exit()
        
    catalog_number             = input_list[0]
    image_license              = input_list[1]
    image_uri                  = input_list[2]
    object_type                = input_list[3]
    rights_holder              = input_list[4]
    registered_institution_url = input_list[5]
    higher_classification      = input_list[6]

    person_name = ""
    person_identifier = ""
    if (len(input_list) == 9):
        person_name = input_list[7]
        person_identifier = input_list[8]
        
    ###########################################################################
    #  Populate openDS

    open_DS = {}

    open_DS['authoritative'] = {'physicalSpecimenId': catalog_number,
                                'institution': [rights_holder,
                                                registered_institution_url
                                                ],
                                'materialType': object_type
                                }

    open_DS['images'] = {'availableImages': [{'source': image_uri,
                                              'license': image_license}
                                             ]
                         }

    open_DS['higher_classification'] = higher_classification

    open_DS['person_name'] = person_name
    open_DS['person_identifier'] = person_identifier

    # -------------------------------------------------------------------------
    #  Write image to file

    # Create SSL context
    ssl._create_default_https_context = ssl._create_unverified_context

    # Get hashed filename
    hash_object = hashlib.sha1(image_uri.encode())
    filename_hash = hash_object.hexdigest()

    # Retrieve the URI
    (filename, headers) = request.urlretrieve(image_uri,
                                              filename=f'/srv/galaxy/images/{filename_hash}')

    # -------------------------------------------------------------------------
    #  Populate metadata

    image = Image.open(filename)
    open_DS['payloads'] = {
        'name': 'original image',
        'filename': filename_hash,
        'width': image.width,
        'height': image.height,
        'mediaType': headers.get_content_type(),
        'size n': os.stat(filename).st_size
    }

    # -------------------------------------------------------------------------
    #  Print

    open_DS_json = json.dumps(open_DS)
    print(open_DS_json)


def parse_args(raw_args):
    parser = argparse.ArgumentParser(prog='Create OpenDS',
                                     description='Options for the create_opends wrapper')
    parser.add_argument('--input' , required=True)

    args = parser.parse_args(raw_args)
    return args


if __name__ == "__main__":
    args = parse_args(sys.argv[1:])
    main(args)
