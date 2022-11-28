#!/bin/bash

echo "====== Instanlling JDK 11 ======"
sudo yum install java-11-openjdk.x86_64 -y
sudo yum install wget -y
echo "====== Instanlling JDK 11 ======"



echo "====== Instanlling Tomcat 9 ======"
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
sudo tar xzvf /vagrant/apache-tomcat-9*tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R vagrant:vagrant /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'

sudo tee /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat 9 Service
After=syslog.target network.target

[Service]
Type=forking

User=vagrant
Group=vagrant

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms800M -Xmx1600M -XX:MaxPermSize=192m -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat
sudo systemctl status tomcat
echo "====== Instanlled Tomcat 9 ======"



echo "====== Instanlling xwiki 13.10.10 ======"
echo "Extract the XWiki WAR into a directory named xwiki in TOMCAT_HOME/webapps/"
cp /vagrant/xwiki-platform-distribution-war-13.10.10.war /opt/tomcat/webapps/xwiki.war
echo "====== Instanlling xwiki 13.10.10 ======"



echo "====== Instanlling Ppstgres 13 ======"
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum install -y postgresql13-server
sudo /usr/pgsql-13/bin/postgresql-13-setup initdb
sudo systemctl enable postgresql-13
sudo systemctl start postgresql-13
sudo systemctl status postgresql-13

PG_CONF="/var/lib/pgsql/13/data/postgresql.conf"
PG_HBA="/var/lib/pgsql/13/data/pg_hba.conf"

# Fix permissions
#echo "-------------------- fixing listen_addresses on postgresql.conf"
#sudo sed -i "s/#listen_address.*/listen_addresses '*'/" "$PG_CONF"

# Replace the ipv4 host line with the above line
echo "-------------------- fixing postgres pg_hba.conf file"
sudo mv /vagrant/pg_hba.conf /var/lib/pgsql/13/data/

sudo systemctl restart postgresql-13


psql -h localhost -U postgres << SQL
-- Create the database user:
CREATE USER xwiki PASSWORD 'xwiki' VALID UNTIL 'infinity';
-- Create the database:
CREATE DATABASE xwiki
WITH OWNER = xwiki
ENCODING = 'UNICODE'
TABLESPACE = pg_default;
SQL

cat /vagrant/hibernate.cfg.xml > /opt/tomcat/webapps/xwiki/WEB-INF/hibernate.cfg.xml
cd /opt/tomcat/webapps/xwiki/WEB-INF/lib
wget --no-check-certificate https://jdbc.postgresql.org/download/postgresql-42.5.0.jar
echo "====== Instanlled Ppstgres 13 ======"


echo "====== Setting xwiki permanentDirectory ======"
echo "Set the environment.permanentDirectory property in your xwiki.properties file"
sudo mkdir /var/lib/xwiki
sudo mkdir /var/lib/xwiki/data
sudo chown -R vagrant:vagrant /var/lib/xwiki
sed -i 's/# environment.permanentDirectory = \/var\/lib\/xwiki\/data\//environment.permanentDirectory = \/var\/lib\/xwiki\/data\//' /opt/tomcat/webapps/xwiki/WEB-INF/xwiki.properties
sudo systemctl restart tomcat
echo "====== Completed setting xwiki permanentDirectory ======"


echo "====== Provision completed!======"
echo "  Open http://localhost:18080/ for tomcat"
echo "  Open http://localhost:18080/xwiki for xwiki"
echo "Reference:"
echo "  https://www.xwiki.org/xwiki/bin/view/Documentation/AdminGuide/Installation/InstallationWAR/"
echo "  https://phoenixnap.com/kb/install-tomcat-9-on-centos-7"
echo "  https://linuxhostsupport.com/blog/how-to-install-xwiki-on-centos-7/"
echo "================================="