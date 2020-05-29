FROM centos:7

LABEL maintainer="technoexpressnet@gmail.com"

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y wget \
    && rpm -Uvh http://repo.iotti.biz/CentOS/7/noarch/lux-release-7-1.noarch.rpm \
    && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-LUX \
    && wget -q http://www.webmin.com/jcameron-key.asc \
    && rpm --import jcameron-key.asc \
    && wget -q http://repo.issabel.org/issabel/RPM-GPG-KEY-Issabel \
    && rpm --import RPM-GPG-KEY-Issabel \
    && rm -f jcameron-key.asc && rm -f RPM-GPG-KEY-Issabel

COPY etc /etc/

RUN yum -y --disablerepo=iperfex install perl perl-Archive-Tar perl-Business-ISBN perl-Business-ISBN-Data perl-Carp perl-CGI perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-constant perl-Convert-BinHex perl-Crypt-OpenSSL-Bignum perl-Crypt-OpenSSL-Random perl-Crypt-OpenSSL-RSA perl-Data-Dumper perl-Date-Manip perl-DBD-MySQL perl-DB_File perl-DBI perl-devel perl-Digest perl-Digest-HMAC perl-Digest-MD5 perl-Digest-SHA perl-Encode perl-Encode-Detect perl-Encode-Locale perl-Error perl-Exporter perl-ExtUtils-Install perl-ExtUtils-MakeMaker perl-ExtUtils-Manifest perl-ExtUtils-ParseXS perl-FCGI perl-File-Listing perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTML-Parser perl-HTML-Tagset perl-HTTP-Cookies perl-HTTP-Daemon perl-HTTP-Date perl-HTTP-Message perl-HTTP-Negotiate perl-HTTP-Tiny perl-IO-Compress perl-IO-HTML perl-IO-Socket-INET6 perl-IO-Socket-IP perl-IO-Socket-SSL perl-IO-Zlib perl-libs perl-libwww-perl perl-LWP-MediaTypes perl-macros perl-Mail-DKIM perl-Mail-IMAPClient perl-Mail-SPF perl-MailTools perl-MIME-tools perl-NetAddr-IP perl-Net-Daemon perl-Net-DNS perl-Net-HTTP perl-Net-LibIDN perl-Net-SMTP-SSL perl-Net-SSLeay perl-Package-Constants perl-parent perl-Parse-RecDescent perl-PathTools perl-PlRPC perl-Pod-Escapes perl-podlators perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Socket6 perl-Storable perl-Sys-Syslog perl-Test-Harness perl-Text-ParseWords perl-threads perl-threads-shared perl-TimeDate perl-Time-HiRes perl-Time-Local perl-URI perl-version perl-WWW-RobotRules

RUN yum -y --disablerepo=iperfex install python python-inotify python-backports python-backports-ssl_match_hostname python-cjson python-configobj python-crypto python-daemon python-decorator python-ecdsa python-eventlet python-greenlet python-iniparse python-libs python-lockfile python-paramiko python-pycurl python-pyudev python-setuptools python-six python-slip python-slip-dbus python-sqlalchemy python-tempita python-urlgrabber python-simplejson python-dns certbot python2-certbot python2-certbot-apache

RUN yum -y --disablerepo=iperfex install acl alsa-firmware alsa-lib alsa-tools-firmware apr apr-util tcpdump screen libXcomposite mod_ssl openfire avahi-devel bash-completion mc mdadm nss-mdns chrony cyrus-sasl cyrus-sasl-plain procmail dos2unix gdb hdparm httpd httpd-tools ipset lame lame-devel libxml2-devel mariadb mariadb-server opus vim git uuid-devel libuuid-devel libesd.so.0 flac mpg123 unixODBC unixODBC-devel libtool-ltdl libtool-ltdl-devel mysql-connector-odbc dmidecode openssh-server iptables-utils iptables-services initscripts elfutils-libelf elfutils-libs glances htop sysstat net-tools fail2ban-server fail2ban-hostsdeny denyhosts whois

RUN yum -y --disablerepo=iperfex install php-jpgraph php-fedora-autoloader php-IDNA_Convert php-Smarty php-PHPMailer php-pear-DB php-simplepie php-tcpdf php php-bcmath php-imap php-cli php-common php-soap php-devel php-mcrypt php-intl php-mysql php-pdo php-pear php-pecl-imagick php-process php-xml php-magpierss php-gd php-mbstring php-tidy php-adodb php-ldap php-google-apiclient

RUN yum -y --disablerepo=iperfex update

# Fixes issue with running systemD inside docker builds
# From https://github.com/gdraheim/docker-systemctl-replacement
COPY systemctl.py /usr/bin/systemctl.py

RUN cp -f /usr/bin/systemctl /usr/bin/systemctl.original \
    && chmod +x /usr/bin/systemctl.py \
    && cp -f /usr/bin/systemctl.py /usr/bin/systemctl \
    && ln -s /usr/lib/systemd/system/mariadb.service /usr/lib/systemd/system/mysqld.service \
    && echo "#\!/bin/bash" > /etc/init.d/mysqld \
    && sed -i 's|\\||' /etc/init.d/mysqld \
    && echo "service mariadb \$1" >> /etc/init.d/mysqld \
    && chmod +x /etc/init.d/mysqld

RUN systemctl.original enable mariadb.service httpd.service \
    && systemctl start httpd \
    && systemctl start mariadb \
    && mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('iSsAbEl.2o17')" \
	&& mysql -piSsAbEl.2o17 -e "create database mya2billing;" \
    && mysql -piSsAbEl.2o17 -e "create database asteriskcdrdb; use asteriskcdrdb; create table cdr ( calldate datetime NOT NULL default '0000-00-00 00:00:00', clid varchar(80) NOT NULL default '', src varchar(80) NOT NULL default '', dst varchar(80) NOT NULL default '', dcontext varchar(80) NOT NULL default '', channel varchar(80) NOT NULL default '', dstchannel varchar(80) NOT NULL default '', lastapp varchar(80) NOT NULL default '', lastdata varchar(80) NOT NULL default '', duration int(11) NOT NULL default '0', billsec int(11) NOT NULL default '0', disposition varchar(45) NOT NULL default '', amaflags int(11) NOT NULL default '0', accountcode varchar(20) NOT NULL default '', uniqueid varchar(32) NOT NULL default '', userfield varchar(255) NOT NULL default '' ); " \
    && mysql -piSsAbEl.2o17 -e "GRANT ALL PRIVILEGES ON mya2billing.* TO root@localhost;" \
	&& mysql -piSsAbEl.2o17 -e "GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost;" \
    && mysql -piSsAbEl.2o17 -e "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost;" \
    && adduser asterisk -m -c "Asterisk User" \
    && yum -y --disablerepo=iperfex install ftp://ftp.pbone.net/mirror/rnd.rajven.net/centos/7.0.1406/os/x86_64/libresample-0.1.3-22cnt7.x86_64.rpm \
    && yum -y --disablerepo=iperfex install asterisk13 \
    && mkdir -p /var/www/db \
    && mkdir -p /var/log/asterisk/mod \
    && touch /var/www/db/fax.db /var/www/db/email.db /var/www/db/control_panel_design.db /var/log/asterisk/issabelpbx.log /var/lib/asterisk/moh \
    && chown -R asterisk.asterisk /var/www/html \
    && chown -R asterisk.asterisk /etc/asterisk \
    && chown -R asterisk.asterisk /var/lib/asterisk \
    && chown -R asterisk.asterisk /var/log/asterisk \
    && sed -i 's@ulimit @#ulimit @' /usr/sbin/safe_asterisk \
    && systemctl stop httpd \
    && systemctl stop mariadb

COPY mya2billing_schema.sql /tmp/
COPY mya2billing_update.sql /tmp/
RUN systemctl start httpd \
    && systemctl start mariadb \
    && mysql -piSsAbEl.2o17 < /tmp/mya2billing_schema.sql \
    && mysql -piSsAbEl.2o17 < /tmp/mya2billing_update.sql \
    && yum -y --disablerepo=iperfex install issabel issabel-a2billing issabel-a2billing-callback_daemon issabel-addons issabel-agenda issabel-asterisk-sounds issabel-email_admin issabel-endpointconfig2 issabel-extras issabel-fax issabel-firstboot issabel-framework issabel-im issabel-my_extension issabel-pbx issabel-portknock issabel-reports issabel-security issabel-system \
    && systemctl stop httpd \
    && systemctl stop mariadb \
    && rm -f /etc/yum.repos.d/Issabel.repo

RUN systemctl start httpd \
    && systemctl start mariadb \
    # && mv /etc/asterisk/extensions_custom.conf.sample /etc/asterisk/extensions_custom.conf \
    && yum -y --disablerepo=iperfex install issabel-callcenter fop2 issabel-roomx \
    && systemctl stop httpd \
    && systemctl stop mariadb \
    && systemctl stop mysqld

RUN yum -y --disablerepo=iperfex install webmin yum-versionlock \
    && yum versionlock systemd

RUN systemctl start httpd \
    && systemctl start mysqld \
	&& rm -f /etc/issabel.conf \
	&& mysql -piSsAbEl.2o17 -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('')" \
	&& issabel-admin-passwords --cli change 'iSsAbEl.2o17' 'issabel-4' \
    && systemctl stop httpd \
    && systemctl stop mysqld

RUN systemctl stop dbus \
    && systemctl.original disable dbus avahi-daemon chronyd ntpd dkms mdmonitor issabel-firstboot a2b-callback-daemon \
    && (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*; \
    rm -f /etc/dbus-1/system.d/*; \
    rm -f /etc/systemd/system/dbus-org.freedesktop.Avahi.service; \
    rm -f /etc/systemd/system/sockets.target.wants/*;

COPY postfix.main.cf /etc/postfix/main.cf
COPY postfix.master.cf /etc/postfix/master.cf

RUN chmod 6711 /usr/bin/procmail \
    && chown root:root /usr/bin/procmail \
    && chown -R postfix:postdrop /var/spool/postfix \
    && touch /etc/postfix/dependent.db /var/log/asterisk/full /var/log/secure /var/log/maillog /var/log/httpd/access_log /etc/httpd/logs/error_log /var/log/fail2ban.log \
    && sed -i 's#LE-SA-v1.1.1-August-1-2016#LE-SA-v1.2-November-15-2017#' /usr/libexec/webmin/webmin/acme_tiny.py \
    && sed -i "s#Listen 80#Listen 880#" /etc/httpd/conf/httpd.conf \
    && sed -i "s#Listen 443#Listen 4443#" /etc/httpd/conf.d/ssl.conf \
    && sed -i "s#_:443#_:4443#" /etc/httpd/conf.d/ssl.conf \
    && sed -i "s@#Port 22@Port 2122@" /etc/ssh/sshd_config \
    && sed -i "s#10000#9900#" /etc/webmin/miniserv.conf \
    && sed -i "s#9000 -j ACCEPT#9000 -j ACCEPT\n-A INPUT -p tcp -m multiport --dports 880 -j ACCEPT#" /etc/sysconfig/iptables \
    && sed -i "s#9000 -j ACCEPT#9000 -j ACCEPT\n-A INPUT -p tcp -m multiport --dports 4443 -j ACCEPT#" /etc/sysconfig/iptables \
    && sed -i "s#9000 -j ACCEPT#9000 -j ACCEPT\n-A INPUT -p tcp -m multiport --dports 2122 -j ACCEPT#" /etc/sysconfig/iptables \
    && sed -i "s#9000 -j ACCEPT#9900 -j ACCEPT\n-A INPUT -p udp -m multiport --dports 9900 -j ACCEPT#" /etc/sysconfig/iptables \
    && sed -i 's#issabeldialer.service webmin.service#issabeldialer.service\nAfter=crond.service\nAfter=postfix.service\nAfter=mariadb.service\nAfter=saslauthd.service\nAfter=cyrus-imapd.service\nAfter=httpd.service\nAfter=fail2ban.service\nAfter=denyhosts.service\nAfter=sshd-keygen.service\nAfter=sshd.service\nAfter=asterisk.service\nAfter=fop2.service\nAfter=hylafax.service\nAfter=wakeup_survey\nAfter=webmin.service#' /etc/systemd/system/containerstartup.service \
    && chown -R asterisk.asterisk /var/www/db

RUN systemctl.original enable denyhosts.service fail2ban.service mariadb.service asterisk.service httpd.service issabeldialer.  service fop2.service hylafax.service wakeup_survey crond.service postfix.service saslauthd.service cyrus-imapd.service

RUN sed -i 's#localhost.key#localhost.key\ncat \"/etc/letsencrypt/archive/$HOSTNAME/privkey1.pem\" \"/etc/letsencrypt/archive/$HOSTNAME/cert1.pem\" >/etc/webmin/miniserv.pem#' /etc/containerstartup.sh \
    && chmod +x /etc/containerstartup.sh \
    && mv -f /etc/containerstartup.sh /containerstartup.sh \
    && rm -f /tmp/mya2billing_* \
    && echo "root:issabel" | chpasswd

ENV container docker
ENV HTTPPORT=880
ENV SSLPORT=4443
ENV SSHPORT=2122
ENV WEBMINPORT=9900

EXPOSE 25 880 4443 465 2122 5038 5060/tcp 5060/udp 5061/tcp 5061/udp 8001 8003 8088 8089 9900/tcp 9900/udp 10000-10100/tcp 10000-10100/udp

ENTRYPOINT ["/usr/bin/systemctl","default","--init"]
