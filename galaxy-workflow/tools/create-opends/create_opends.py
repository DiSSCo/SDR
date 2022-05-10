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
    #  Populate openDS

    open_DS = {}

    open_DS['authoritative'] = {'physicalSpecimenId': args.catalog_number,
                                'institution': [args.rights_holder,
                                                args.registered_institution_url
                                                ],
                                'materialType': args.object_type
                                }

    open_DS['images'] = {'availableImages': [{'source': args.image_uri,
                                              'license': args.image_license}
                                             ]
                         }

    open_DS['higher_classification'] = args.higher_classification

    open_DS['person_name'] = args.person_name
    open_DS['person_identifier'] = args.person_identifier

    # -------------------------------------------------------------------------
    #  Write image to file

    # Create SSL context
    ssl._create_default_https_context = ssl._create_unverified_context

    # Get hashed filename
    hash_object = hashlib.sha1(args.image_uri.encode())
    filename_hash = hash_object.hexdigest()

    # Retrieve the URI
    (filename, headers) = request.urlretrieve(args.image_uri,
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
    parser.add_argument('--catalog_number'             , required=True)
    parser.add_argument('--image_license'              , required=True)
    parser.add_argument('--image_uri'                  , required=True)
    parser.add_argument('--object_type'                , required=True)
    parser.add_argument('--rights_holder'              , required=True)
    parser.add_argument('--registered_institution_url' , required=True)
    parser.add_argument('--higher_classification'      , required=True)
    parser.add_argument('--person_name'                , required=False, default='')
    parser.add_argument('--person_identifier'          , required=False, default='')

    args = parser.parse_args(raw_args)
    return args


if __name__ == "__main__":
    args = parse_args(sys.argv[1:])
    main(args)
