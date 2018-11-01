Thread Level Process Monitoring
-------------------------------

**Introduction**

This toolkit script utilizes packaged utilities `ps` and `pgrep` to query kernel information on the threads of selected processes.  It creates a single dataview that lists the processes as you would see them in the processes view and utilizes the Geneos # syntax to group and indent the threads with their master process.  This package currently contains solutions for linux and solaris.

**Prerequisites**

*ps*

*pgrep: procps* v3.0.0 or greater pgrep (http://procps.sourceforge.net/changelog.html )

*sed*

*awk* for linux

*nawk* for solaris

**Tested Versions**

	Linux 2.6.32-504.el6.x86_64 Red Hat Enterprise Linux Server release 6.6 (Santiago)
	Linux 3.16.6-203.fc20.x86_64 Fedora release 20 (Heisenbug)
	Linux 2.6.32-358.el6.x86_64 CentOS release 6.4 (Final)
	Linux 2.6.18-400.1.1.el5.centos.plus x86_64 CentOS release 5.11 (Final)
	Generic_127127-11 SunOS 5.10 sun4v
	Generic_137111-03 SunOS 5.10 sun4v

**Usage**

The arguments are a space separated list of strings to match against.  If the search string has a space in it you need to double quote it.  By default the rownames are the patterns supplied to the argument.  If the pattern string is too complex for a rowname you can alias the rownames (e.g. `pattern=alias`).  If there are multiple equals signs the alias is the string after the last equals sign.

`threadstat_linux.sh ProcA ProcB "Proc C=C"`

	ProcA
		ProcA#1
		ProcA#2
	ProcB
		ProcB#1
		ProcB#2
	C
		C#1
		C#2

**Notes**

On solaris pgrep will only match against the first 80 characters of the command line.

If multiple PIDs match a single pattern then the oldest PID found is used.  
