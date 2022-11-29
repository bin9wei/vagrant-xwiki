# vagrant-xwiki
A vagrant box (CentOS 7) to install XWiki

## How to use

 - Clone it to local
 ```
 git clone git@github.com:bin9wei/vagrant-xwiki.git
 ```

 - Download [tomcat 9.0.69](https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.69/bin/apache-tomcat-9.0.69.tar.gz) and [xwiki 13.10.10](https://nexus.xwiki.org/nexus/content/groups/public/org/xwiki/platform/xwiki-platform-distribution-war/13.10.10/xwiki-platform-distribution-war-13.10.10.war) place them under `/vagrant-xwiki`
Note: China user is blocked. Please make it on your own.

 - Navigate to `/vagrant-xwiki` and bring up virtual box
```
cd /vagrant-xwiki
vagrant up
```
 - Open [http://localhost:18080/](http://localhost:18080/). Wait 10+ mins for initialization.

 - Logon virtual box `vagrant ssh`

 - Shut down virtual box `vagrant halt`