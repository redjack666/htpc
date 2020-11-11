#!/bin/bash
opensslver='1.1.1h'

sudo -i << EOF
apt-get 'update'
apt-get -y 'upgrade'

##安裝snap 套件

apt-get -y install 'snap' 'cmake' 'ffmpeg'

#安裝vlc 最新版本
snap install vlc

##安裝openssl 新版

wget -nc -P '/tmp' "https://www.openssl.org/source/openssl-$opensslver.tar.gz"

tar zxvf '/tmp/openssl-1.1.1h.tar.gz' -C '/usr/local' > '/tmp/openssl_install.log' 2>&1

cd '/usr/local'

mv "openssl-$opensslver" 'openssl'

cd '/usr/local/openssl'

./config >> '/tmp/openssl_install.log' 2>&1
make >> '/tmp/openssl_install.log' 2>&1
make install >> '/tmp/openssl_install.log' 2>&1

ldconfig

##修改預設1024連線數
echo '* soft nofile 10240' >> /etc/security/limits.conf
echo '* hard nofile 10240' >> /etc/security/limits.conf


##開啟bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

##開啟視窗放大縮小
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

EOF


##開啟視窗放大縮小

gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

echo 5秒後進行重啟

sleep 5

sudo reboot

