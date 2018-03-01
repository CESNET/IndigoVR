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

Please, generate manually SSL certificates for centrapoint and place it to 
"files/centralpoint/certs" directory:

	* CENTRALPOINT.crt
	* CENTRALPOINT.key
	* ca.crt


3. Prepare vRouter's OpenVPN config template.
--------------------------------------------------------

The template config file is available on  "files/vRouters/client.conf-template". Copy the template to vRouter config file (for example files/vRouters/client001.conf). Modify these config file parameters:

	1. Set up remote IP address for CENTRALPOINT [CENTRALPOINT IP] (line remote ...).
	2. Set up CA certificate part.
	3. Set up vRouter's public certificate part.
	4. Set up vRouter's private key part.

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
Start ansible playbook in ansible-scripts directory: ansible-playbook -i hosts install.yml .


7. Restart all virtual machines/routers.
--------------------------------------------------------

Now you need to restart all virtual machines.


8. Connectivity check
--------------------------------------------------------

Try ping to all vRouter OpenVPN interface and ping to IP addresses in local network behind all vRouters.





