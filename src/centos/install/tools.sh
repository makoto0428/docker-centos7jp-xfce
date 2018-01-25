#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common tools for further installation"

if [ ! "$PROXY" = "" ] ; then
  sed -i -e "/^\[main\]$/a proxy=http://10.100.208.25:80" /etc/yum.conf
fi
sed -i -e "s/#include_only=.nl,.de,.uk,.ie/include_only=.jp/g" /etc/yum/pluginconf.d/fastestmirror.conf

yum -y install epel-release
if [ ! "$PROXY" = "" ] ; then
  rpm -Uvh --httpproxy ${PROXY%%:*} --httpport ${PROXY##*:} http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
else
  rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
fi

yum -y update
yum -y install vim sudo wget which net-tools bzip2 

yum clean all

if [ ! "$PROXY" = "" ] ; then
  sed -i -e "s/proxy.yoyodyne.com:18023/10.100.208.25:80/" /etc/wgetrc
  sed -i -e "s/^#https_proxy/https_proxy/g" /etc/wgetrc
  sed -i -e "s/^#http_proxy/http_proxy/g" /etc/wgetrc
  sed -i -e "s/^#ftp_proxy/ftp_proxy/g" /etc/wgetrc
fi

### Locale Re-Install
yum -y reinstall glibc-common
env LANG=ja_JP.UTF-8
rm -f /etc/localtime
ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
