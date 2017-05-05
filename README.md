# IndigoVR
The INDIGO Virtual Router Appliance facilitates creation of overlay networks across multiple federated cloud sites. It is being developed as a part of a cloud stack provided by the INDIGO-DataCloud project. It is network router appliance with the following features:

* Inter-site point to point VPN
* Redundant topologies
* Set up in userspace
* Configured on contextualization to enable network topology control by Platform as a Service (PaaS) orchestrators

This repository contains contextualization scripts to install and configure the INDIGO Virtual Router appliance in a plain Linux image.

Each Indigo vRouter Appliance create a secure connection to "Central point". "Central point" is dedicate vRouter which provides connection between all Indigo vRouter Appliances. Indigo vRouter Appliance has these requirements:

* Internet to reach the main router (also needed for installation), the public IPv4 address is not required
* two interfaces (Internet connectivity and internal network)

* Debian GNU/Linux (8.7 and newer) or Ubuntu Distribution (16.4 and newer)
* OpenVPN 2
* ISC DHCP server

