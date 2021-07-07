#!/bin/bash

step=$1

if [ "$step" == "" ]
then

echo 'LC_CTYPE="en_US.UTF-8"' >> /etc/sysconfig/i18n

clear
echo change root password
sleep 1
passwd


clear

echo 'sh lampstack.sh 2' >> ~/.bash_profile

echo Preparing Post Install, Server Will Reboot In Few Seconds And Continue Installation After Next Login


yum install -y wget epel-release telnet >> /tmp/lograh.log

# wget http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# yum localinstall remi-release-6.rpm

yum install yum-utils -y >> /etc/sysconfig/i18n

# yum-config-manager --enable remi-php54

echo "Enabling PHP 5.*"

sleep 2

reboot
fi

if [ "$step" == "2" ]
then

sed -i '/[[:space:]]\+lampstack.sh/d' .bash_profile

clear
echo "Running Post Install Module…"
echo 'Going to install the LAMP stack With phpmyadmin on your machine, here we go...'
echo '------------------------'

echo Please Wait….


yum install httpd php mysql mysql-server phpmyadmin php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-dom php-simplexml  >> /tmp/lograh.log

service mysqld restart > /tmp/lograh.log


read -p "Please Enter Desired root MySQL Password: " mysqlPassword
read -p "Please Mysql root Retype password: " mysqlPasswordRetype

while [[ "$mysqlPassword" = "" && "$mysqlPassword" != "$mysqlPasswordRetype" ]]; do
echo -n "Please enter the desired mysql root password: "
stty -echo
read -r mysqlPassword
echo
echo -n "Retype password: "
read -r mysqlPasswordRetype
stty echo
echo
if [ "$mysqlPassword" != "$mysqlPasswordRetype" ]; then
echo "Passwords do not match!"
fi
done

/usr/bin/mysqladmin -u root password $mysqlPassword

echo "--------------------------------"

echo "Make PhpMyadmin Accesible :"

read -p "Please Enter Your Ip So You Can Only Access PhpMyAdmin: " phpmyadminip
read -p "Please retype ip " phpmyadminipretype

while [[ "$phpmyadminip" = "" && "$phpmyadminip" != "$phpmyadminipretype" ]]; do
echo -n "Please Enter Your Ip So You Can Only Access PhpMyAdmin: "
stty -echo
read -r phpmyadminip
echo
echo -n "Retype IP: "
read -r phpmyadminipretype
stty echo
echo
if [ "$phpmyadminip" != "$phpmyadminipretype" ]; then
echo "IP do not match!"
fi
done


rm -rf /etc/httpd/conf.d/phpMyAdmin.conf

rm -rf /etc/httpd/conf.d/phpMyAdmin.conf
#ip=45.32.92.97 HARDCODE OPTION
echo '# phpMyAdmin - Web based MySQL browser written in php
#
# Allows only localhost by default
#
# But allowing phpMyAdmin to anyone other than localhost should be considered
# dangerous unless properly secured by SSL

Alias /phpMyAdmin /usr/share/phpMyAdmin
Alias /phpmyadmin /usr/share/phpMyAdmin

<Directory /usr/share/phpMyAdmin/>
AddDefaultCharset UTF-8

<IfModule mod_authz_core.c>
# Apache 2.4
<RequireAny>
Require ip 127.0.0.1
Require ip ::1
</RequireAny>
</IfModule>
<IfModule !mod_authz_core.c>
# Apache 2.2
Order Deny,Allow
Deny from All' > /etc/httpd/conf.d/phpMyAdmin.conf;

echo "Allow from 127.0.0.1 $phpmyadminip" >> /etc/httpd/conf.d/phpMyAdmin.conf;

echo  'Allow from ::1
</IfModule>
</Directory>

<Directory /usr/share/phpMyAdmin/setup/>
<IfModule mod_authz_core.c>
# Apache 2.4
<RequireAny>
Require ip 127.0.0.1
Require ip ::1
</RequireAny>
</IfModule>
<IfModule !mod_authz_core.c>
# Apache 2.2
Order Deny,Allow
Deny from All
Allow from 127.0.0.1
Allow from ::1
</IfModule>
</Directory>

# These directories do not require access over HTTP - taken from the original
# phpMyAdmin upstream tarball
#
<Directory /usr/share/phpMyAdmin/libraries/>
Order Deny,Allow
Deny from All
Allow from None
</Directory>

<Directory /usr/share/phpMyAdmin/setup/lib/>
Order Deny,Allow
Deny from All
Allow from None
</Directory>

<Directory /usr/share/phpMyAdmin/setup/frames/>
Order Deny,Allow
Deny from All
Allow from None
</Directory>

# This configuration prevents mod_security at phpMyAdmin directories from
# filtering SQL etc.  This may break your mod_security implementation.
#
#<IfModule mod_security.c>
#    <Directory /usr/share/phpMyAdmin/>
#        SecRuleInheritance Off
#    </Directory>
#</IfModule>' >> /etc/httpd/conf.d/phpMyAdmin.conf;







echo Okay.... apache, php and mysql Support is installed..
chkconfig mysqld on >> /tmp/lograh.log

chkconfig httpd on >> /tmp/lograh.log


echo Server Will reboot now in 10 seconds

sleep 10

reboot
fi
