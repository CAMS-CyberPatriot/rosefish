# rosefish
audits debian based systems to an html page
---
# Goals
[x] Add expandable sections for readability
Will eventually output all of the following:
- [x] timestamp
- [x] user
- [x] hostname
- [x] OS
- [x] kernel
- [x] uptime
- [x] shell
  $0 gives process instead of shell sometimes
- [x] DE
  only compatible with xfce, kde, and gnome and doesn't work half the time
- [x] users
- [x] groups
- [x] /home tree
  uses tree command and can be bloated with cache and stuff
- [x] sudo users
- [x] media files
  currently uses find, should probably use locate for the indexing
- [x] process list
- [x] service list
  only works for systemd and upstart
- [x] application list
  only works with dpkg
- [x] ports
  uses netstat from the net-tools package
- [x] firewall status
  only works with ufw
- [x] crontabs
  lists user crontabs and cronjobs from /etc/cron.d/ /etc/cron.daily/ /etc/cron.hourly/ /etc/cron.monthly/ /etc/cron.weekly/ /etc/crontab
- [ ] Finds specific services and packages: php, apache, ssh, ftp, vnc, database, mysql
- [x] Filesystem Permissions
  /etc/fstab contents for mounting info, checks for world writable directories without sticky bit set
  Checks permissions for: /root /var/log/audit /etc/rc.d/init.d/iptables /sbin/iptables /etc/skel /etc/rsyslog.conf /etc/security/access.conf /etc/sysctl.conf 

