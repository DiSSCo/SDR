galaxyproject.tusd
==================

Install the tusd server.

Requirements
------------

This role does not build tusd from source, so binaries for your platform must be available from the [tusd Releases
page][tusd-releases]

[tusd-releases]: https://github.com/tus/tusd/releases/

Role Variables
--------------

See [defaults/main.yml](defaults/main.yml).

Dependencies
------------

None

Example Playbook
----------------

```yaml
- name: Install and configure tusd
  hosts: all
  vars:
    tusd_instances:
      - name: uploads
        # user that tusd will run as
        user: my-app-user
        # group that tusd will run as
        group: my-app-group
        # args passed to tusd
        args:
          - -host=localhost
          - -port=1080
          - -upload-dir=/data/uploads
          - -hooks-http=https://my-app.example.org/api/upload
          - -hooks-http-forward-headers=Cookie
  roles:
    - galaxyproject.tusd
```

License
-------

MIT

Author Information
------------------

[The Galaxy Project](https://galaxyproject.org/)
