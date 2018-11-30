# Ansible win_domain_groups role

This is an [Ansible](http://www.ansible.com) role which manages windows domain groups through the [`win_domain_group`](https://docs.ansible.com/ansible/latest/modules/win_domain_group_module.html) module.

## Requirements

[Ansible 2.7+](http://docs.ansible.com/ansible/latest/intro_installation.html)

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
    - amtega.win_domain_groups
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
      - name: your_group
        state: present
```


## Testing

Tests are based on vagrant virtual machines. You can setup vagrant engine
quickly using the role [amtega.vagrant_engine](https://galaxy.ansible.com/amtega/vagrant_engine).

Once you have vagrant and virtualbox, you can run the tests with the following
commands:

```shell
$ cd amtega.win_domain_groups/tests
$ ansible-playbook main.yml
```
It will create two vagrant machines (Domain controler and server) and execute
the tests on them

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
