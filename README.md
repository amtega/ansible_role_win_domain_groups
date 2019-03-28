# Ansible win_domain_groups role

This is an [Ansible](http://www.ansible.com) role which manages windows domain groups through the [`win_domain_group`](https://docs.ansible.com/ansible/latest/modules/win_domain_group_module.html) module.

## Requirements

[pywinrm 0.3.0+](https://pypi.org/project/pywinrm) on the control host.
[requests-credssp 1.0.2+](https://pypi.org/project/requests-credssp) on the control host.

## Role Variables

A list of all the default variables for this role is available in `defaults/main.yml`.

## Example Playbook

This is an example playbook:

```yaml
---

- hosts: windows_ad
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

To run test you must pass in the command line the variable `win_domain_groups_tests_host` pointing to a windows host fullfilling the ansible requirements documented in https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html. Also, you must define in the inventory for this host the neccessary variables to connect.

Additionally the tests requires the following set of variables that can be defined in the inventory or passed in the command line:

- `win_domain_groups_tests_domain_name`: windows domain name
- `win_domain_groups_tests_ad_ou`: OU to use during tests
- `win_domain_groups_tests_ad_group`: testing group name
- `win_domain_groups_tests_ad_user`: testing user name
- `win_domain_groups_tests_ad_password`: password for the testing user

One way to provide all the previois information is calling the testing playbook passing the host to use and an additional vault inventory plus the default one provided for testing, as it's show in this example:

```shell
$ cd amtega.win_domain_groups/tests
$ ansible-playbook main.yml -e "win_domain_groups_tests_host=test_host" -i inventory -i ~/mycustominventory.yml --vault-id myvault@prompt
```

## License

Copyright (C) 2019 AMTEGA - Xunta de Galicia

This role is free software: you can redistribute it and/or modify it under the terms of:

GNU General Public License version 3, or (at your option) any later version; or the European Union Public License, either Version 1.2 or – as soon they will be approved by the European Commission ­subsequent versions of the EUPL.

This role is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details or European Union Public License for more details.

## Author Information

- Daniel Sánchez Fábregas
