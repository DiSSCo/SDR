# SDR Workflow

## Tools

### Overview

Each tool has as input an OpenDS JSON object, updates the OpenDS JSON object, and outputs a modified OpenDS object.

A working example is provided - [sdr-example](https://github.com/DiSSCo/SDR/tree/galaxy-workflow/galaxy-workflow/tools/sdr-example)

The tool validates the OpenDS object against the OpenDS schema, as defined in the environment variable SDR_OPENDS_SCHEMA.

An `opends_property` macro allows each tool to define which OpenDS properties it requires using [jsonpath](https://goessner.net/articles/JsonPath/) syntax (via [jsonpath-ng](https://pypi.org/project/jsonpath-ng/))


For example:

```xml
<expand macro="opends_property" name="image" property="$.images.availableImages[0].source" />
```

Will take the openDS property at ```$.images.availableImages[0].source```: 

```json
{
  "images": {
      "availableImages": [{
              "source": VALUE,
          }
      ]
  },
}
```

And pass it as a parameter to the tool script

```sh
python '$__tool_directory__/main.py' -i '$input' -o '$output' --image VALUE
```

### Tool development

Each SDR tool will need to:

1. Define the OpenDS properties it requires in jsonpath syntax.

2. Provide a python file named ```main.py```, with a function ```__main__()``` to modify opends_json and then write it to ```output_file```.  The value of any opends_property will be available as named function parameters, containing the value from opends_json.  

```python

    def __main__(opends_json, output_file, image):
        ...
```


The [sdr-example](https://github.com/DiSSCo/SDR/tree/galaxy-workflow/galaxy-workflow/tools/sdr-example) tool will then be cloned, and updated with the OpenDS properties and ```main.py```, ready for run in the SDR workflow.



### TODO

- Docker container
- TBC: Validate OpenDS object post tool completion? 


