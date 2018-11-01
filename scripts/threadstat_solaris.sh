#!/bin/bash
# note: pgrep is limited to the first 80 characters

psComm='ps -L -o user,pid,lwp,psr,pcpu,time,vsz,rss,pri,nice,comm -p'
# Print out the column headers first, get it from running pidstat against the script itself
${psComm} $$ | head -n 1 | sed -e 's/^ *//' -e 's/ *$//' -e 's/  */,/g' -e 's/^/name,/'

# Validate that there are command line arguments otherwise exit with an error
#  The exit code of 1 can be optional but should still exit if no pattern found
if [ $# -eq 0 ]; then exit 1; fi

# Store off pids that match shell script and its ancestors
#  Guards against false positives
array=(`pgrep -f $0`)

for option in "$@"
do
    # If there is an = in the option anything before the last = is the pattern
    #  Anything after the last = is the alias
    pattern=${option%=*}
    aliasR=${option##*=}

    # Find the pid matching this pattern.
    #  -f means look at full command line.  -o means take the oldest pid.
    #  This protects against pgrep finding the shell script but doesnt guarantee it
    rPID=`pgrep -o -f "${pattern}"`

    # Hack to make sure no positive matches on shell script
    case "${array[@]}" in *${rPID}*) pTest=1;; *) pTest=0;; esac

    # Make sure there is a pid and it is not the shell script
    #  if not (emptyPID or shell scriptPID)
    if ! [[ -z "${rPID}" || "${pTest}" -eq 1 ]]
    then
        # Take ps output and format it thru sed and awk
        #  Show thread info, remove first line, replace spaces with commas
        #  If it is the first line print grep string as pattern otherwise add #Index to rowname
	${psComm} ${rPID} |
	sed -e '1d' -e 's/^ *//' -e 's/  */,/g' |
	nawk -v Row="${aliasR}" '{ if(NR==1){ print Row","$0 } else { printf ("%s#%02d,%s\n",Row,NR-1,$0) } }'
    else
	# PID not found just print pattern
	echo "${aliasR},"
    fi
done

exit 0