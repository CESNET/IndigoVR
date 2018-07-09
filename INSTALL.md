Indigo vRouter installation guide
=================================

This document describes steps for vRouter instalation.


1. Prepare IP address and parameters
------------------------------------

Prepare IP plan and basic parameters for other steps:

	* CENTRALPOINT IP:			......................
	* vRouter 1 IP / local network:		...................... / ......................
	* ...
	* vRouter N IP / local network:		...................... / ......................

For communication between CENTRALPOINT and vRouters we use private subnet 192.168.255.0/24. This subnet is reserved. For each vRouter's local network is possible to use
other private address space - for example 192.168.0.0/24 - 192.168.254.0/24.

2. Generate configuration directories
-------------------------------------

The directory structure is given as follows (<cert-name> can be customized):

```
conf_dir
├── centralpoint          ; contains IP address of centralpoint
└── certs
    ├── <cert-name>.key   ; private key for openvpn
    ├── <cert-name>.crt   ; certificate for openvpn
    └── ca.crt            ; CA certificate for openvpn
```

One configuration directory can be used for multiple vRouters and even centralpoint by using different certificate names.


3. Start ansible
--------------------------------------------------------
Start ansible playbook in ansible-scripts directory for vRouter deployment:

```
vRouter:
ansible-playbook -i 'vrouters,' -l vrouters -e 'ansible_connection=local conf_dir=<config-directory> cert_name=<cert-name>' install.yml

centralpoint:
ansible-playbook -i 'centralpoint,' -l centralpoint -e 'ansible_connection=local conf_dir=<config-directory> cert_name=<cert-name>' install.yml
```

For example:

```
ansible-playbook -i 'vrouters,' -l vrouters -e 'ansible_connection=local conf_dir=/home/user/IndigoVR/ cert_name=vrouter05' install.yml
```

4. Routing configuration (only applies to centralpoint)
--------------------------------------------------------

Modify the OpenVPN server configuration files with IP routing rules for each vRouter (directory /etc/openvpn/ccd).

The configuration file contains only one line "iroute <local-network-behind-vRouter> <network-mask>". Each vRouter has its own config file with filename being the same as certificate filename (for example vrouter05).

5. Connectivity check
--------------------------------------------------------

Try ping to all vRouter OpenVPN interface and ping to IP addresses in local network behind all vRouters.


