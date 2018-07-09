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


2. CENTRALPOINT's certificates
------------------------------

Please, generate manually SSL certificates for centralpoint and place it to 
"certs" directory:

	* CENTRALPOINT.crt
	* CENTRALPOINT.key
	* ca.crt


3. vRouter's certificates
-------------------------

vRouter's certifacites (crt and key file) copy to "certs" directory. The name of these files must contains the vRouter's name. For example vrouter05.key and vrouter05.crt.

Notice: Each vRouter has own config file with own certificate.


4. Routing configuration
--------------------------------------------------------

Modify the OpenVPN server configuration files with IP routing rules for each vRouter (directory files/centralpoint/ccd).

The configuration file contains only one line "iroute <local-network-behind-vRouter> <network-mask>". Each vRouter has own config file. The file name has the same name as certificate name (for example client001).


5. The list of hosts for ansible
--------------------------------

Modify the ansible's host file (file ansible-scripts/hosts).

	1. Modify section "centralpoint" - change FQDN and login parameters.
	2. Modify section "vrouters" - change and add FQDNs and login parameters.


6. Start ansible
--------------------------------------------------------
Start ansible playbook in ansible-scripts directory for vRouter deployment:

ansible-playbook -i 'vrouters,' -l vrouters -e 'ansible_connection=local conf_dir=<config-directory> cert_name=<vrouter-name>' install.yml

For example:

ansible-playbook -i 'vrouters,' -l vrouters -e 'ansible_connection=local conf_dir=/home/user/IndigoVR/ cert_name=vrouter05' install.yml



7. Restart all virtual machines/routers.
--------------------------------------------------------

Now you need to restart all virtual machines.


8. Connectivity check
--------------------------------------------------------

Try ping to all vRouter OpenVPN interface and ping to IP addresses in local network behind all vRouters.


