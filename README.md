# rosefish
audits debian based systems to an html page
---
# Usage

## Required Packages

- mlocate : used to list mediafiles 
- net-tools : used for netstat (viewing ports)
- nmap : used to scan open ports

## Setup

It is recommended that you modify the `locate` database configuration to reduce files listed under media files.

```
/etc/updatedb.conf

PRUNEPATHS="/tmp /var/spool /media /mnt /usr/lib /usr/share"
```

## Running

Be sure to run from the script directory! Otherwise, the html will not be formatted.

`$ ./rosefi.sh`

# Features

- Prints system information: user, hostname, operating system, kernel version, uptime, shell, & desktop environment
- (sudoers) Prints sudoers files
- (services) Lists services
- (mediafiles) Lists mediafiles
- (crontabs) Lists crontabs
- (users,groups) Prints user and group info
- (processes) Prints process information
- (port_scanner) Prints information on open/used ports
- (apt_history,dpkg_history,package_list) Package information
- (firewall) Firewall information

# Contributing

rosefi.sh - the bash script used to create the html page.\
	The script is divided into three parts. Variables, Functions, and
	HTML Print. When contributing, please put your contribution in the
	correct place. 
	
	Variables has mainly been used for system information, but that is
	just where I have seen a use for variables. Variable names must be
	in all caps and separated by underscores.
 
	Functions is for everything that generates output on for the audit.
	Functions must be named the same as the header of the section on
	the audit page. Function names must be in all lowercase and 
	underscores used as the delimeter.

	HTML Print is where the audit page is created. There is a large
	'here' doc that outputs to 'audit.html'. The syntax for adding a
	section to the page is as follows:
```html
<button class="collapsible">Section Header</button>
<div class="content">
<pre>
$(function)
</pre>
</div>
```

main.css - a boring stylesheet