#!/usr/bin/env python

import logging
import os, platform
import ctypes
from ctypes import *
from utils import parse_args, write_opends_to_output_file


log = logging.getLogger(__name__)


@parse_args
def __main__(opends_json, output_file, image):
    
    log.debug("Running SDR Barcode Tool")

    # Load the libbardecode.so library
    cdll=CDLL('./lib/libbardecode.so' )

    # Create an instance of the bardecode toolkit
    cdll.mtCreateBarcodeInstance.restype = ctypes.c_void_p
    bardecode = cdll.mtCreateBarcodeInstance()
    
    cdll.mtSetLicenseKey(bardecode, os.getenv('BARDECODE_LICENCE_KEY'))

    # Read number of barcodes
    data = open(image, "rb").read()
    num_barcodes = cdll.mtScanBarCodeFromString(c_void_p(bardecode), data, data.__sizeof__())

    barcodes = []

    # Data list
    for x in range(1, num_barcodes + 1):
        cdll.mtGetBarString.restype = ctypes.c_char_p
        barcodeValue = cdll.mtGetBarString(c_void_p(bardecode), x)
        cdll.mtGetBarStringType.restype = ctypes.c_char_p
        barcodetype = cdll.mtGetBarStringType(c_void_p(bardecode), x)
        page = cdll.mtGetBarStringPage(c_void_p(bardecode), x)
        top_left_x = c_long()
        top_left_y = c_long()
        bottom_right_x = c_long()
        bottom_right_y = c_long()
        page = cdll.mtGetBarStringPos(c_void_p(bardecode), x, byref(top_left_x), byref(top_left_y), byref(bottom_right_x), byref(bottom_right_y))
        direction = cdll.mtGetBarStringDirection(c_void_p(bardecode), x)
        quality = cdll.mtGetBarStringQualityScore(c_void_p(bardecode), x)
        
        barcodes.append({
            'value': barcodeValue.decode("utf-8"),
            'type': barcodetype,
            'bbox': [top_left_x, top_left_y, bottom_right_x, bottom_right_y],
            'direction': direction,
            'quality': quality
        })
        
        cdll.mtDestroyBarcodeInstance(c_void_p(bardecode))
    
    
    
    opends_json['barcodes'] = barcodes


    write_opends_to_output_file(opends_json, output_file)    


if __name__ == "__main__":
    __main__()        