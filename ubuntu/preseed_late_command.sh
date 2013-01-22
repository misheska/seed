#!/bin/bash
# preseed_late_command.sh

# Install Chef omnibus
/usr/bin/wget -q -O - https://www.opscode.com/chef/install.sh | /usr/bin/sudo /bin/bash 1>>/var/log/preseed_late_command 2>&1

# Configure the hostname.  Modify the HOSTNAME_FQDN variable.
/bin/echo "Configuring hostname" 1>>/var/log/preseed_late_command 2>&1
HOSTNAME_FQDN=myhost.example.com
HOSTNAME=`/bin/echo "$HOSTNAME_FQDN" | cut -f1 -d.`
# Write out the /etc/hostname file value
/bin/echo "$HOSTNAME" > /etc/hostname
# Write out /etc/hosts
# Heredocs can't write out tab characters without some fancy syntax.
# To make this script more straightforward, write out the values that need
# tabs first, then use a heredoc to write out all the rest.
/bin/echo -e "127.0.0.1\tlocalhost" > /etc/hosts
/bin/echo -e "127.0.1.1\t$HOSTNAME_FQDN\t$HOSTNAME" >> /etc/hosts
/bin/cat >> /etc/hosts <<_EOF_

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
_EOF_

/bin/echo "Configuring static IP" 1>>/var/log/preseed_late_command 2>&1
# Configure static networking.  Fill in the appropriate values below.
/bin/cat > /etc/network/interfaces <<_EOF_
# This file describes the network interfaces available on your system
# and how to activate them.  For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
address 192.168.1.10
netmask 255.255.255.0
network 192.168.1.0
broadcast 192.168.1.255
gateway 192.168.1.1
dns-nameservers 192.168.1.5
dns-search mydomain.com
_EOF_
