#========================================================================
#Variables
#------------------------------------------------------------------------
BIND_IP=0.0.0.0
SRT_PORT=3306
#------------------------------------------------------------------------
SSH_DST_IP=sp1.c0r.ir
SSH_DST_PORT=2222
SSH_DST_USER=root
#------------------------------------------------------------------------
DST_IP=uk1.c0r.ir
DST_PORT=3306
#------------------------------------------------------------------------
SERVICE_NAME=tbs-${SRT_PORT}
RESTART_MIN=55
TYPE=tbs-connection

#========================================================================
cat <<EOF > /etc/systemd/system/${SERVICE_NAME}.service
[Unit]
Description=$TYPE
After=network.target
[Service]
ExecStart=/usr/bin/ssh -p ${SSH_DST_PORT} -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -nNT -L ${BIND_IP}:${SRT_PORT}:${DST_IP}:${DST_PORT} ${SSH_DST_USER}@${SSH_DST_IP}
RestartSec=15
Restart=always
KillMode=mixed
[Install]
WantedBy=multi-user.target
EOF
#========================================================================
systemctl stop ${SERVICE_NAME}
systemctl disable ${SERVICE_NAME}
rm -rf /etc/systemd/system/${SERVICE_NAME}
rm -rf /etc/systemd/system/multi-user.target.wants/${SERVICE_NAME}

#========================================================================
if ! grep -q ${SERVICE_NAME} /var/spool/cron/crontabs/root; then
#cat << EOF >> /var/spool/cron/crontabs/root
#*/${RESTART_MIN} * * * * /usr/bin/systemctl restart ${SERVICE_NAME}
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
EOF
fi

/etc/init.d/cron restart

#========================================================================
systemctl deamon-reload
systemctl enable ${SERVICE_NAME}
systemctl restart ${SERVICE_NAME}
sleep 3
systemctl status ${SERVICE_NAME}

#========================================================================
