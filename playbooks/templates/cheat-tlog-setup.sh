    
#!/bin/bash

echo ""

echo "# Installing tlog packages: 'yum install -y tlog cockpit-session-recording'"
yum install -y tlog cockpit-session-recording

sleep

echo "# Enabling system service: 'systemctl enable cockpit.socket'"
systemctl enable cockpit.socket --now

sleep 3

echo "# Starting system service: 'systemctl start cockpit.socket'"
systemctl start cockpit.socket

sleep 3

echo "# The configuration file was deployed during the lab setup"
echo "# Here is what it looks like"

cat /etc/sssd/conf.d/sssd-session-recording.conf

