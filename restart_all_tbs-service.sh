#===============================================================================
cat << EOF > /root/restart_all_tbs_services.sh
#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
for SERVICE in \$(ls -1 /etc/systemd/system | grep tbs); do
    systemctl restart "\$SERVICE"
    echo "Restarted: "\$SERVICE
    sleep 2
done
EOF

#===============================================================================
cat << EOF >> /var/spool/cron/crontabs/root
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
0 * * * * /bin/bash /root/restart_all_tbs_services.sh
EOF

/etc/init.d/cron restart
/etc/init.d/cron status

#===============================================================================