# Specimen Data Refinery (SDR)

The Specimen Data Refinery (SDR) provides an easy to deploy, open source, web-based interface to multiple workflows that enable a user to create new or enhance existing natural history specimen records. The SDR uses the Galaxy workflow platform as the basis for managing data analysis, and where possible, using existing Galaxy community tools and approaches 

We have developed a library of domain-specific tools including semantic segmentation, optical character recognition, hand-written text recognition, barcode reading and natural language processing. These tools have been designed to work on standardised images of specimens, specifically herbarium sheets, pinned insects and microscope slides.

This README details some of the ways you can get started with the SDR, provides reference documentation and gives details of our open project management approach.

### New digitiser ###

If you are a new user and would like to use an already existing version of the SDR please visit our [reference instance](http://sdr.nhm.ac.uk/ "SDR"). Here you can apply for a login and start digitising images. We suggest you follow our [tutorial](docs/tutorials/tutorial.md "SDR tutorial") to get started.

### New admin ###

If you wish to host your own instance of the SDR, we provide a detailed [how-to](docs/how-to/deployment.md "SDR deployment") guide on deploying the SDR.

### Documentation Contents ###

#### Tutorial ####
  * [SDR tutorial](docs/tutorials/tutorial.md "SDR tutorial")
#### How-to ####
  * [How to: create a new input file](docs/how-to/create-new-input-file.md "how to create input file")
  * [How to: deploy a new instance of the SDR](docs/how-to/deployment.md "how to deploy SDR")
  * [How to: invoke the SDR workflow using the Galaxy API](docs/how-to/invoke-workflow-using-api.md "how to invoke SDR using API")
  * [How to: configure the SDR job submission engine](docs/how-to/create-job-conf.md "how to create job conf")
  * [How to: add new tools for the SDR](docs/how-to/add-new-tool.md "how to add new tool")
#### Explanation ####
  * [Explanation: SSL certificates](docs/explanation/ssl-certs.md "ssl certificates")
#### Reference ####
  * [Reference: SDR tools](docs/reference/sdr-tools.md "sdr tools")
  * [Reference: Deployment Variables](docs/reference/deploy-vars.md "SDR deployment variables")

# Project management details
We are using this repo for both SDR project management and technical development work.

Ben and Laurence are transfering the next steps from the Minimum Viable Product (MVP) document into GitHub [issues](https://github.com/DiSSCo/SDR/issues). 

We are using GitHub's simple Project Trello boards to track [Publications and Outputs](https://github.com/DiSSCo/SDR/projects/2) and development of the [MVP](https://github.com/DiSSCo/SDR/projects/1).

We have a separate repo for [SDR datasets](https://github.com/DiSSCo/sdr-datasets)

Our workflows are available on our [SDR WorkflowHub project](https://workflowhub.eu/projects/72)

## Communication channels and key documents:

   **Rolling Google Doc for our [regular meeting notes & minutes](https://docs.google.com/document/d/1iYDDnXsDy34HSTFqjIbJeYXe0J4bHp-8VZHzOVTY8Yw)**
-   We have a **Slack channel in DiSSCo-dev** (please message me for access) to avoid mass emailing and for short questions/queries.
-   **[Project Google Drive](https://drive.google.com/drive/folders/13le9Ns5prwy1Zs1dV4YZ2ykXkXnaqTJg?usp=sharing)**
-   [Teamwork](https://dissco.teamwork.com/#/tasklists/1782802) (will be used for formal communication and project administration)
-   [SDR contacts list](https://docs.google.com/spreadsheets/d/1L2nJ4DMrUGAG3GjB2R9D9wPRz9cUzhXkGzaMDngdix8)
-   [SDR minimum viable product plan](https://docs.google.com/document/d/1sNclNbnMJrIVWeV1-9Rikd3SUX00T2x3L5-Lwqcyx6A)
