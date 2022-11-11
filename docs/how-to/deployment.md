# Deploying the SDR #

In this how-to guide we will detail how to deploy a new instance of the SDR using Ansible.

First, please ensure you meet the requirements for this guide.

## Requirements ##

### Technical Requirements ###

  * Target machine running Ubuntu 18.04[^1]
  * Host machine with Ansible installed
  * Generated SSL certificates

### Knowledge Requirements ###

  * A basic understanding of Ansible
    * Our short [guide](../explanation/ansible-deployment.md "SDR Ansible Guide") 
    * Galaxy Project's [guide](https://training.galaxyproject.org/training-material/topics/admin/tutorials/ansible/tutorial.html "Galaxy Ansible Guide")
  * Ability to generate (or procure) SSL certificates

## Procedure ##

To perform the deployment of the SDR, the following steps will be required:
  * Cloning of the SDR GitHub repository
  * Customisation of important parameters
  * Creation of an inventory file
  * Population of SSL certificates
  * Run deployment of base Galaxy instance
  * Run deployment of enhanced SDR features
  
Please note, this how-to assume that you will run Ansible on your own "host" machine, to deploy the SDR on a "target" machine, assumed to be remote and on which you must have superuser rights. 
  
### Cloning the SDR repository ###

Everything needed for setting up an instance of the SDR is present in our Github [repository](https://github.com/DiSSCo/SDR/ "SDR Repository").

To obtain the necessary files, clone the repository and then move into the relevant directory.

```console
foo@bar $ git clone https://github.com/DiSSCo/SDR.git
foo@bar $ cd SDR
```

### Customisation of SDR parameters ###

The SDR requires some, minimal configuration before you begin deployment.

#### Generic parameters ####

Generic (non-secret) parameters are set in `group_vars/sdr-config.yml`. Edit the parameters here to suit your needs, e.g.:
```console
foo@bar $ nano group_vars/sdr-config.yml
```
#### Secret parameters ####

The process for specifying secret parameters is more complex, as passwords and similar details should not be left in plain text files, and must not be pushed to version control records!

Ansible has functionality to prevent this. The process is below:

```console
foo@bar $ nano group_vars/sdr-secret.yml
foo@bar $ ansible-vault encrypt group_vars/sdr-secret.yml.template --output group_vars/sdr-secret.yml
foo@bar $ rm group_vars/sdr-secret.yml
```

These commands:
  * Allow you to populate the template
  * Perform the encryption of the populated template file
  * Remove the plaintext file with the sensitive content

### Creation of inventory file ###

Ansible requires you to specify the details of the machine on which the SDR is to be deployed. This is specified using an inventory file, which must be named "hosts" for the SDR deployment. To edit the hosts file you can for example:

```console
foo@bar $ nano hosts
```

In this file you must insert the specification of your target machine. An example specification is produced here.

```ini
[remoteservers]
sdr.target.ac.uk ansible_connection=ssh ansible_ssh_user=auser ansible_ssh_pass='{{ target_ssh_pass }}' ansible_become_pass='{{ target_su_pass }}'
```
  * `sdr.target.ac.uk` should be replaced with the address of the target machine you are using (an IP address is acceptable)
  * `ansible_connection=ssh` specifies that an ssh connection will be made and should **not** be changed
  * `ansible_ssh_user=auser` allow you to specify your username on the target machine and **should** be changed
  * `ansible_ssh_pass='{{ target_ssh_pass }}'` draws the ssh password from the encrypted config file created earlier and should **not** be changed
  * `ansible_become_pass='{{ target_su_pass }}'` draws the superuser password from the encrypted config file created earlier and should **not** be changed

### Population of certificates ###

To deploy the SDR, SSL certificates are required to allow the server to provide a secure HTTPS connection. It is expected that the user of this guide will be familiar with the generation of acquisition of such certificates.

With a key pair of a certificate file `foo.crt` and private key `foo.key` you are ready to proceed with this guide.

The files should be placed on the **target** machine:
  *  `foo.crt` in `/etc/ssl/certs`
  *  `foo.key` in `/etc/ssl/priv`

### Run deployment of base Galaxy instance ###

With the customised variables in place, the next stage of deployment is to launch the creation of a standard Galaxy instance. This can be achieved simply with the command:

```console
foo@bar $ ansible-playbook deploy-galaxy.yml
```

This command will take a considerable time to run. If you experience any problems (network dropouts etc) then the deploy command can be safely rerun.

### Run deployment of enhanced SDR features ###


```console
foo@bar $ ansible-playbook deploy-sdr.yml
```

### Completion ###

The SDR should now be up and running on the target machine! Visit the machines address and you should be presented with the Galaxy log-in screen.

[^1]: The deployment may work on other platforms but this is untested. 
