#!/bin/bash
#
# This script will prepare Debian or Ubuntu distribution environment
# for running a virtual Indigo router.
# 
# 2017-05: Puma, init version
#
# -----------------------------------------------------------------------
#
# Copyright 2017 CESNET - INDIGO-DataCloud
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
# -----------------------------------------------------------------------
#
# --- EDIT IT ---------------
OPENVPNCFG="client.conf"				# OpenVPN config file
LOCALNET4="eth1 10.11.12.1 10.11.12.0 255.255.255.0"	# LOCALNET4="interface router-IP network netmask"
# --- /EDIT IT --------------

PACKAGES="openvpn isc-dhcp-server"
CNO=`tput sgr0`
CRED=`tput setaf 1`
CBOLD=`tput bold`

cat << EOF

${CBOLD}Indigo virtual router installation script${CNO}
-----------------------------------------

This script require Debian GNU/Linux or Ubuntu distribution. Script will
install and configure these packages from official sources:

	${CRED}${PACKAGES}${CNO}

EOF

# Checking

if [ "$OPENVPNCFG" = "" ]; then
	echo "ERROR: You must specify OPENVPNCFG."
	exit
fi

if [ "$LOCALNET4" = "" ]; then
	echo "ERROR: You must specify LOCALNET4."
	exit
fi

INTERFACE=`echo ${LOCALNET4} | awk '{print $1}'`
IP=`echo ${LOCALNET4} | awk '{print $2}'`
NET=`echo ${LOCALNET4} | awk '{print $3}'`
NETMASK=`echo ${LOCALNET4} | awk '{print $4}'`


cat << EOF
Current settings:

	OpenVPN file:	${OPENVPNCFG}
	LAN interface:	${INTERFACE}
	LAN IP:		${IP}
	LAN NET:	${NET}
	LAN netmask:	${NETMASK}

EOF

# User confirmation ----------------------------------
read -n1 -p "Do you want to continue? [y/N] " A 
case "$A" in
	y|Y) ;;
	*) echo; echo "Exiting..."; exit;;
esac
echo

# Installing packages -------------------------------
echo "Installing packages: ${PACKAGES}"
apt-get update && apt-get install ${PACKAGES}

# Enabling IPv4 forwarding --------------------------
echo
echo "Enabling IPv4 forwarding..."
sysctl net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# Preparing OpenVPN config file ---------------------
echo
echo "Preparing OpenVPN..."
echo "	Copying config file ${OPENVPNCFG} to /etc/openvpn..."
cp ${OPENVPNCFG} /etc/openvpn

# Enabling OpenVPN service --------------------------
echo
echo "	Enabling OpenVPN service..."
OSERVICE="`echo ${OPENVPNCFG} | sed 's/.conf$//'`"
systemctl enable openvpn@${OSERVICE}

# User confirmation ----------------------------------
echo
echo "Do you want to connect over VPN?"
echo "${CRED}Warning: you can lost this connection!${CNO}"
read -n1 -p "[y/N] " A 
case "$A" in
	y|Y) systemctl start openvpn@${OSERVICE} ;;
	*) ;;
esac

cat << EOF

Command for OpenVPN service:
${CRED}systemctl start openvpn@${OSERVICE}${CNO}

EOF


# Configuring network --------------------------------
echo
echo "Configuring /etc/network/interfaces ..."
echo "	Creating /etc/network/interface.backup"
cp /etc/network/interfaces /etc/network/interfaces.backup
echo "	Adding interface ${INTERFACE} ${IP}/${NETMASK} to /etc/network/interfaces"
cat << EOF >> /etc/network/interfaces
auto ${INTERFACE}
iface ${INTERFACE} inet static
	address ${IP}
	netmask ${NETMASK}'

EOF

# Configuring ISC DHCP server ------------------------
echo
echo "Configuring ISC DHCP server..."
echo "	Creating /etc/dhcp/dhcpd.conf.backup"
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup
NET4="`echo ${IP} | cut -d. -f1-3`"
cat << EOF >> /etc/dhcp/dhcpd.conf

subnet ${NET4}.0 netmask ${NETMASK} { option routers ${IP}; allow unknown-clients; range ${NET4}.16 ${NET4}.254; }

EOF

