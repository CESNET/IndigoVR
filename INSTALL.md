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

2. Generate configuration
-------------------------

Configuration of each node can be adjustet by variables of the indigo-dc.indigovr role. Description and default values of all variables can be seen in `roles/indigo-dc.indigovr/defaults/main.yml`.


3. Start ansible
--------------------------------------------------------
Start corresponding ansible playbook (`install_centralpoint.yml`, `install_standalone.yml` or `install_vrouter.yml`) or use the role from https://github.com/indigo-dc/ansible-role-indigovr directly in your playbook.


4. Routing configuration (only applies to centralpoint)
--------------------------------------------------------

Modify the OpenVPN server configuration files with IP routing rules for each vRouter (directory /etc/openvpn/ccd).

The configuration file contains only one line "iroute <local-network-behind-vRouter> <network-mask>". Each vRouter has its own config file with filename being the same as certificate filename (for example vrouter05).

5. Connectivity check
--------------------------------------------------------

Try ping to all vRouter OpenVPN interface and ping to IP addresses in local network behind all vRouters.

