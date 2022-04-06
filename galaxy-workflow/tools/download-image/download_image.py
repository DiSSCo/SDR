import argparse
import hashlib
import json
import os
from PIL import Image
import ssl
import sys
from urllib import request


def main(args):
    with open(args.opends_path) as open_DS_file:

        open_DS = json.load(open_DS_file)

        image_uri = open_DS["images"]["availableImages"][0]["source"]

        # -----------------------------------------------------------------------------
        #  Write image to file

        # Create SSL context
        ssl._create_default_https_context = ssl._create_unverified_context

        # Get hashed filename
        hash_object = hashlib.sha1(image_uri.encode())
        filename_hash = hash_object.hexdigest()

        # Retrieve the URI
        (filename, headers) = request.urlretrieve(image_uri,
                                                  filename=f'/srv/galaxy/images/{filename_hash}')

        # -----------------------------------------------------------------------------
        #  Populate metadata

        image = Image.open(filename)

        open_DS['payloads'] = {
            'name': 'original image',
            'filename': filename,
            'width': image.width,
            'height': image.height,
            'mediaType': headers.get_content_type(),
            'size n': os.stat(filename).st_size
        }

        # -----------------------------------------------------------------------------
        #  Print
        
        open_DS_json = json.dumps(open_DS)
        print(open_DS_json)


def parse_args(raw_args):
    parser = argparse.ArgumentParser(prog='Download Image',
                                     description='Options for the download_image wrapper')
    parser.add_argument('--opends-path', required=True)

    args = parser.parse_args(raw_args)
    return args


if __name__ == '__main__':
    args = parse_args(sys.argv[1:])
    main(args)
    print(args.opends_path)


# -----------------------------------------------------------------------------
#  Parse command line options


