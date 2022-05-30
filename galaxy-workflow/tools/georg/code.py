import json
import re
import os
from jsonpath_ng import parse
import jsonschema



def validate_input(trans, error_map, param_values, page_param_map):
    
    # Validate Open DS JSON    
    input_opends = param_values['input']
    
    # Read the open DS raw JSON
    try:
        opends_data = json.loads(input_opends.get_raw_data())
    except json.decoder.JSONDecodeError as e:
        error_map['input'] = e
        return
    
    try:    
        validate_opends(opends_data)
    except FileNotFoundError as e:
        error_map['input'] = f'OpenDS schema file not found: {e}'
    except jsonschema.exceptions.ValidationError as e:
        error_map['input'] = f'OpenDS JSON does not validate against OpenDS schema: {e}'
        raise e
        pass

    opends_properties = {}
        
    # Extract the open ds properties from the param values
    for key, value in param_values.items():
        m = re.match('^opends.([a-z]+)', key)
        if m:
            param_name = m.group(1)
            # https://www.journaldev.com/33265/python-jsonpath-examples
            jsonpath_expression = parse(value)
            match = jsonpath_expression.find(opends_data)

            try:
                opends_properties[param_name] = match[0].value
            except IndexError:
                error_map['input'] = f'Tool requires {param_name} data within the OpenDS JSON object at {value}'

    param_values['opends_properties'] = opends_properties

def exec_before_job(app, inp_data, out_data, param_dict, tool):
    print('**exec_before_job**')

def validate_opends(opends_json):
    
    OPENDS_SCHEMA_PATH = os.environ['SDR_OPENDS_SCHEMA']
    
    with open(OPENDS_SCHEMA_PATH) as opends_schema_file:    
        opends_schema = json.load(opends_schema_file)  
        jsonschema.validate(instance=opends_json, schema=opends_schema)