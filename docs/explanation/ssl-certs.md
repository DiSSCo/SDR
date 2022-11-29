# SDR approach to SSL certificates #

To serve the SDR securely, SSL certificates are required to facilitate HTTPS traffic without browser blocks / warnings. 

It is expected that users will provide both a URL by which their instance of the SDR can be accessed as well as valid certificates. At present, the SDR deployment makes no effort to support acquiring, installing or updating certificates.

### Population of certificates directories ###

A key pair of a certificate file `foo.crt` and private key `foo.key` should be placed on the target machine in the appropriate folders i.e.:

  *  `foo.crt` in `/etc/ssl/certs`
  *  `foo.key` in `/etc/ssl/priv`
  
This setup will allow the SDR setup to complete successfully.
