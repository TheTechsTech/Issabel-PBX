#!/bin/bash
export SSHPORT
export WEBMINPORT
export HTTPPORT
export SSLPORT

if [ -f "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" ]
then
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/cert1.pem" /etc/pki/tls/certs/localhost.crt
    ln -sf "/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem" /etc/pki/tls/private/localhost.key
fi

source /etc/container.ini
if [[ $SSLPORT =~ ^[0-9]+$ ]] && [ "$SSL" != "$SSLPORT" ]
then  
    sed -i "s#Listen $SSL#Listen $SSLPORT#" /etc/httpd/conf.d/ssl.conf
    sed -i "s#_:$SSL#_:$SSLPORT#" /etc/httpd/conf.d/ssl.conf
    sed -i "s#SSL=$SSL#SSL=$SSLPORT#" /etc/container.ini
    systemctl restart httpd
fi
if [[ $HTTPPORT =~ ^[0-9]+$ ]] && [ "$HTTP" != "$HTTPPORT" ]
then  
    sed -i "s#Listen $HTTP#Listen $HTTPPORT#" /etc/httpd/conf/httpd.conf 
    sed -i "s#HTTP=$HTTP#HTTP=$HTTPPORT#" /etc/container.ini
    systemctl restart httpd
fi

if [[ $SSHPORT =~ ^[0-9]+$ ]] && [ "$SSH" != "$SSHPORT" ]
then 
    service sshd stop
    sed -i "s#Port $SSH#Port $SSHPORT#" /etc/ssh/sshd_config
    sed -i "s#$SSH#$SSHPORT#" /etc/container.ini
    service sshd start
elif [ "$SSHPORT" == "off" ]
then
    systemctl.original disable sshd-keygen.service sshd.service
    service sshd stop    
    systemctl stop sshd-keygen 
elif [[ $SSHPORT =~ ^[0-9]+$ ]] && ! pgrep -x "sshd" >/dev/null
then 
    systemctl.original enable sshd-keygen.service sshd.service
    systemctl start sshd-keygen 
    service sshd start   
fi

source <( grep port /etc/webmin/miniserv.conf ) 
if [[ $WEBMINPORT =~ ^[0-9]+$ ]] && [ "$WEBMINPORT" != "$port" ]
then  
    systemctl stop webmin
    sed -i "s#$port#$WEBMINPORT#" /etc/webmin/miniserv.conf
    systemctl start webmin
fi
