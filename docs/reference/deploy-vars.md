# Deployment variables #

When deploying an instance of the SDR, a user should customise several parameters for their needs. In this document we will dicuss "user space" variables which will need to be set in most cases. Users may also wish to edit variables in `ansible/group_vars/galaxyservers.yml` but these are more advanced and require detailed knowledge of both Ansible and Galaxy.

Two forms of user space variables will be discussed, those that do not require encryption and those that should be encrypted for storage.

#### Generic parameters ####

The generic parameters that should be set are stored in a regular file.

> File location: ansible/group_vars/sdr-config.yml

The parameters are:

  * sdr\_conf\_brand
    * Description: Text branding that will appear on the Galaxy web interface
    * Type: [str]
  * sdr\_conf\_admin_users
    * Description: Email addresses of users who will be granted administrator access 
    * Type: [str]

#### Secret parameters ####

The secret parameters should not be stored in a regular file, the variables should be encrypted using Ansible vault. The procedure is as follows:

```console
foo@bar $ nano ansible/group_vars/sdr-secret.yml.template # Edit the template file to populate the variables
foo@bar $ ansible-vault encrypt ansible/group_vars/sdr-secret.yml.template --output ansible/group_vars/sdr-secret.yml # Produce an encrypted file containing hashes of the variables
foo@bar $ rm ansible/group_vars/sdr-secret.yml.template # Remove the plain text variables
```

> IMPORTANT: some closed source / commercially produced tools are used in the standard SDR deployment. Users will need to obtain licence keys themselves to access the full range of SDR tools.

The parameters are:
  * master\_api\_key
    * Description: A hard coded API key for use during initial configuration. Suggested: random generated string
    * Type: [str]
  * bootstrap\_admin\_email:
    * Description: Email address used during startup and persisting as administrator, does not need to be functioning email address. Suggested: random generated email
    * Type: [str]
  * bootstrap\_admin\_user:
    * Description: User name associated with bootstrap admin account. Suggested: random string
    * Type: [str]
  * teklia\_decryption\_key
    * Description: Teklia provided licence key for decrypting their proprietary models
    * Type: [str]
  * bardecode\_licence\_key:
    * Description: [Bardecode](https://www.bardecode.com/en1/ "Bardocode") provided licence key for using barcode reading tool
    * Type: [str]
  * ansible\_ssh\_pass:
    * Description: Remote machine ssh user password
    * Type: [str]
  * ansible\_become\_pass
    * Description: Remote machine superuser password
    * Type: [str]
  * vault\_id\_secret
    * Description: Suggested: random generated string
    * Type: [str]

