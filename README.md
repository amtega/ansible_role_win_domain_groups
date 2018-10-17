# Ansible win_domain_users role

This is an [Ansible](http://www.ansible.com) role which manages windows domain groups through the [`win_domain_group`](https://docs.ansible.com/ansible/latest/modules/win_domain_group_module.html) module.

## Requirements

[Ansible 2.6+](http://docs.ansible.com/ansible/latest/intro_installation.html)

## Role Variables

A list of all the default variables for this role is available in `defaults/main.yml`.

## Dependencies

None.

## Example Playbook

This is an example playbook:

```yaml
---

- hosts: windows_command_host
  roles:
    - amtega.win_domain_users
  vars:
    win_domain_groups_defaults:
      scope: global
      category: security
      path: OU=test_groups,DC=mydomain,DC=local      
    win_domain_groups:
      - name: my_group
        state: present

      - name: our_group
        state: present
```


## Testing

A description of how to run tests of the role if available.

## License

Copyright (C) 2018 AMTEGA - Xunta de Galicia

This role is free software: you can redistribute it and/or modify
it under the terms of:
GNU General Public License version 3, or (at your option) any later version;
or the European Union Public License, either Version 1.2 or – as soon
they will be approved by the European Commission ­subsequent versions of
the EUPL;

This role is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details or European Union Public License for more details.

## Author Information

- Daniel Sánchez Fábregas
