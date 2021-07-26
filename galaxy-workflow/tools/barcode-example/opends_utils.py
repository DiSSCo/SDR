
import logging
import json

def validate_input(trans, error_map, param_values, page_param_map):
    
    
    
    # Validate Open DS JSON
    
    opends = param_values['opends']
    
    open_ds_properties = []
    
    print(dir(opends.dataset))
    print(dir(opends))

    # Can I get the attributes?? The data-ref???
    
    # print(page_param_map['url'])
    # url = page_param_map['url']
    
    # print(url)
    # print(url.dict_collection_visible_keys())
    # print(page_param_map['url'])
    
    print(param_values)
    

    # error_map["opends"] = 'E2'
    
    # param_values['']
    
    
    pass


def get_opends_value(property):
    print(property)
    raise Exception('HEHEHEHEH')
    print('HEY')
    return 'ASDF'