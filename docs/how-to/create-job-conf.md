# Creating the job configuration file for the SDR #

Galaxy, and therefore the SDR, requires users to specify what resources are available for the workflows to be executed on.

The SDR requires a slight specialisation of the general Galaxy configuration to allow it to use the containerised tools ubiquitous throughout the SDR tool-chain.

A standard configuration is provided which should get the majority of SDR users up and running. However, almost all instances of the SDR will benefit significantly from configuring the job engine for their specific compute platform. We will demonstrate this customisation in this how-to guide.

## Configuring that standard SDR template ##

Generally, tailoring the SDR's setup to a compute environment is a lightweight change and will need only slight adaptation from the standard template.

The template is located at `/path/to/SDR/templates/galaxy/config/job_conf.xml.j2`.

The full job configuration file is reproduced here:


``` xml
<?xml version="1.0"?>

<job_conf>
  <plugins>
    <plugin id="local" type="runner" load="galaxy.jobs.runners.local:LocalJobRunner" workers="4"/>
  </plugins>
  <destinations default="docker_local">
    <destination id="local" runner="local"/>
    <destination id="docker_local" runner="local">
      <param id="docker_enabled">true</param>
      <param id="docker_volumes"> $defaults,{{ galaxy_images }}:/images:ro</param>
      <param id="docker_run_extra_arguments">-\-entrypoint='' -\-env TEKLIA_MODEL_DECRYPTION_KEY=$TEKLIA_KEY</param>
      <param id="docker_sudo">false</param>
    </destination>
  </destinations>
</job_conf>
```

In this file there are two major sections, plugins and destinations. For the SDR, two destinations have been configured:
  * local: for running jobs natively on the server
  * docker_local: for running jobs on the server, in a Docker container
  
For most SDR use-cases, these should not be changed. 

### Customising the number of runners ###

The main adaptation that should be made for an instance of the SDR is setting the number of jobs which can simultaneously be executed. This is controlled by this section of XML:

``` xml
  <plugins>
    <plugin id="local" type="runner" load="galaxy.jobs.runners.local:LocalJobRunner" workers="NUMBER_OF_VCPUS"/>
  </plugins>
```

In the plugin tag, the workers attribute should be set to the number of CPU threads that can sensibly dispatched on your platform, in general, for complete utilisation this parameter should be set to the number of CPU threads available on the system.

### Rolling out the customisation ###

To apply this change, re-run the Galaxy deployment script:

```console
foo@bar $ ansible-playbook deploy-galaxy.yml
```

## Further changes ##

Details on more advanced customisation can be found in the Galaxy [training material](https://training.galaxyproject.org/ "galaxy training").

In particular this [lesson](https://training.galaxyproject.org/training-material/topics/admin/tutorials/job-destinations/tutorial.html "job desitination tutorial") provides details on modifying the job configuration.
