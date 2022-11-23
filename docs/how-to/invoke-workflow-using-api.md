# Invoking the SDR workflow using the API #

It is often useful to be able launch workflows without the use of the Galaxy GUI. In this guide we will give details of **an** approach to automating this task, specific to the SDR. 

There are several ways to invoke Galaxy workflows using the Galaxy API, including:
  * Using the raw API
  * Using the [BioBlend](https://bioblend.readthedocs.io/en/latest/ "bioblend") wrapper library 
  * Using the [Parsec](https://github.com/galaxy-iuc/parsec/ "parsec") CLI

Galaxy provide a general [tutorial](https://training.galaxyproject.org/training-material/topics/dev/tutorials/bioblend-api/tutorial.html "Galaxy API Training") on this topic which details how to move from the basics of invoking the API ([including API key acquisition](https://training.galaxyproject.org/training-material/topics/dev/tutorials/bioblend-api/tutorial.html#interacting-with-histories-in-galaxy-api "API key acquisition")), to developing scripts for workflow invocation, to using the BioBlend library to provide an object oriented approach.

In this document, however, we will focus solely on the SDR use-case.

## Invoking the main SDR workflow ##

### Requirements ###
  * A user account on an instance of the SDR
  * An input file (see [reference file](reference-file.csv "SDR reference file") or [How to: create a new input file](docs/how-to/create-new-input-file.md "how to create input file"))
  * A Python virtual environment with BioBlend installed

