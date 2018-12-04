#!/bin/bash

# Prints sudoers files
function sudoers {
  grep -v '#' /etc/sudoers | awk 'NF'
}

# Lists services on systems with systemd and Upstart
function services {
  if hash systemctl 2>/dev/null; then
    systemctl -r --type service --all
  elif hash service 2>/dev/null; then
    service --status-all
  else
    echo "rosefish is not compatible with your init system"
  fi
}

# Lists mediafiles
function lismedia {
  for filetype in *.jpeg , *.mp4 , *.webm , *.mkv , *.flv , *.vob , *.omv , *.ogg , *.drc , *.gif , *.gifv , *.mng , *.avi , *.mov , *.qt , *.wmv , *.yuh , *.rm , *.rmvb , *.asf , *.amv , *.mp4 , *.m4p , *.m4v , *.mpg , *.m4v , *.mpg , *.mp2 , *.mpeg , *.mpe , *.mpv , *.m2v , *.svi , *.3gp , *.3g2 , *.mxf , *.roq , *.nsv , *.flv , *.f4p , *.f4a , *.f4b , *.aif , *.iff , *.m3u , *.m4a , *.mid , *.mp3 , *.mpa , *.wav , *.wma , *.bmp , *.dds , *.jpg , *.png , *.psd , *.pspimage , *.tga , *.thm , *.tif , *.tiff , *.yuv , *.flac
  do
    find /home -iname $filetype -type f
  done
}

# Determines the DE and makes it the $desktop variable
if [ "$XDG_CURRENT_DESKTOP" = "" ]
then
  desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
else
  desktop=$XDG_CURRENT_DESKTOP
fi
desktop=${desktop,,}

# Lists crontabs for each user account
function crontabs {
  # Prints user crontabs
  cut -f1 -d: /etc/passwd | while read -r user; do
    if [[ $user  = *"no crontab for"* ]];
    then
      :
    else
      crontab -u $user -l
    fi
  done

  # cron.d/ cron.daily/ cron.hourly/ cron.monthly/ cron.weekly/
  # Prints jobs from /etc/crontab
  echo "/etc/crontab"
  cat /etc/crontab

  # Prints Daily cronjobs
  echo "Daily Jobs"
  cat /etc/cron.daily/*

  # Prints Weekly cronjobs
  echo "Weekly Jobs"
  cat /etc/cron.weekly/*

  # Prints Monthly cronjobs
  echo "Monthly Jobs"
  cat /etc/cron.monthly/*

  # Prints package specific cronjobs
  echo "Package Jobs"
  cat /etc/cron.d/*
}

cat << _EOF_ > ./audit.html
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="icon" type="image/png" href="./favicon.png"/>
  <link rel="stylesheet" type="text/css" href="./main.css" media="screen">
  <title>System Audit</title>
</head>

<body>
  <!-- HEADER-->
  <div id="header">
    <pre>
<a class=title name="top">System Audit</a>
  <a class="subtitle">Page created $(date +"%H:%M:%S")</a>

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	</pre>

  </div>
  <!--ACTUAL CONTENTS-->
  <div id="main">

<pre>
$(whoami)@$(hostname)
OS: $(grep 'PRETTY_NAME' < /etc/os-release | sed 's/"//g' | sed 's/PRETTY_NAME=//')
Kernel: $(uname -r)
Uptime: $(uptime -p)
Shell: $0
DE: $desktop
</pre>

<button class="collapsible">Users</button>
<div class="content">
<pre>
$(grep sh < /etc/passwd)
</pre>
</div>

<button class="collapsible">Groups</button>
<div class="content">
<pre>
$(< /etc/group)
</pre>
</div>

<button class="collapsible">Sudo Users</button>
<div class="content">
<pre>
$(sudoers)
</pre>
</div>

<button class="collapsible">Home Directories</button>
<div class="content">
<pre>
$(tree /home -a -I '.cache' --charset unicode)
</pre>
</div>

<button class="collapsible">Media Files</button>
<div class="content">
<pre>
$(lismedia)
</pre>
</div>

<button class="collapsible">Processes</button>
<div class="content">
<pre>
$(ps aux)
</pre>
</div>

<button class="collapsible">Service List</button>
<div class="content">
<pre>
$(services)
</pre>
</div>

<button class="collapsible">Package History a.k.a. what did they leave behind?</button>
<div class="content">
<h2>dpkg logs</h2>
<pre>
$(grep 'install ' /var/log/dpkg.log* | sort | cut -f1,2,4 -d' ')
</pre>
<h2>apt logs</h2>
<pre>
$(cat /var/log/apt/history.log)
</pre>
</div>

<button class="collapsible">Installed Applications</button>
<div class="content">
<pre>
$(dpkg-query -l)
</pre>
</div>

<button class="collapsible">Open Ports</button>
<div class="content">
<pre>
$(if hash netstat 2>/dev/null; then
  netstat -tulpn
else
  echo "net-tools not installed (apt install net-tools)"
fi)
$(nmap -sT -O localhost)
</pre>
</div>

<button class="collapsible">Firewall Configuration</button>
<div class="content">
<pre>
$(ufw status verbose)
</pre>
</div>

<button class="collapsible">Filesystem Permissions</button>
<div class="content">
<h2>Mounting</h2>
<pre>
$(cat /etc/fstab)

Ensure nodev, nosuid, noexec has been added to all removable media.
</pre>
<h2>World writable directories without sticky bit set</h2>
<pre>
$(df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null)

Use 'df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | xargs chmod a+t' to remediate this!
</pre>
<h2>File Permissions</h2>
<pre>
$(stat -c "%a %n" /root)
/root - Should be 700!
$(stat -c "%a %n" /var/log/audit)
/var/log/audit - Should be 700!
$(stat -c "%a %n" /etc/rc.d/init.d/iptables)
/etc/rc.d/init.d/iptables - Should be 740!
$(stat -c "%a %n" /sbin/iptables)
/sbin/iptables - Should be 740!
$(stat -c "%a %n" /etc/skel)
/etc/skel - Should be 700!
$(stat -c "%a %n" /etc/rsyslog.conf)
/etc/rsyslog.conf - Should be 600!
$(stat -c "%a %n" /etc/security/access.conf)
/etc/security/access.conf - Should be 640!
$(stat -c "%a %n" /etc/sysctl.conf)
/etc/sysctl.conf - Should be 600!
<button class="collapsible">Crontabs</button>
<div class="content">
<pre>
$(crontabs)
</pre>
</div>

  </div>

  <!--FOOTER-->
  <div id="footer">
    <pre>

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

<a class=link href="#top">Top</a>
    </pre>
  </div>

<script>
var coll = document.getElementsByClassName("collapsible");
var i;

for (i = 0; i < coll.length; i++) {
  coll[i].addEventListener("click", function() {
    this.classList.toggle("active");
    var content = this.nextElementSibling;
    if (content.style.display === "block") {
      content.style.display = "none";
    } else {
      content.style.display = "block";
    }
  });
}
</script>

</body>

</html>
_EOF_
