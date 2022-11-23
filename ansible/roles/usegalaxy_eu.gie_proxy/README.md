usegalaxy-eu.gie-proxy
======================

Install and configure the proxy server used by [Galaxy][galaxy] for [Interactive Environments][gie] and [Interactive
Tools][gxit].

[galaxy]: https://galaxyproject.org/
[gie]: https://docs.galaxyproject.org/en/latest/admin/special_topics/
[gxit]: https://docs.galaxyproject.org/en/latest/admin/special_topics/

Requirements
------------

None

Role Variables
--------------

See the [defaults file](defaults/main.yml) for full details


Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- name: Install GIE Proxy
  hosts: galaxyservers
  vars:
    gie_proxy_dir: /srv/gie-proxy/proxy
    gie_proxy_setup_nodejs: nodeenv
    gie_proxy_nodejs_version: "10.13.0"
    gie_proxy_virtualenv: /srv/gie-proxy/venv
    gie_proxy_setup_service: systemd
    gie_proxy_port: 4002
    gie_proxy_verbose: true
    gie_proxy_sessions_path: "/srv/galaxy/var/data/interactivetools_map.sqlite"
  roles:
    - usegalaxy_eu.gie_proxy
```

License
-------

MIT

Author Information
------------------

- [Helena Rasche](https://github.com/erasche/)
- [Nate Coraor](https://github.com/natefoo/)
