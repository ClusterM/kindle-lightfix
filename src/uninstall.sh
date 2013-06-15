#!/bin/sh
##
#
# lightfix installer (c) Cluster aka Alexey Avyukgin
# mailto: clusterrr@clusterrr.com
#
##

# Pull some helper functions for logging
source /etc/upstart/functions

[ -f utils.tar.gz ] && {
	tar xvf utils.tar.gz
	rm -f utils.tar.gz
}

# Pull some helper functions for progress bar handling
source consts/patchconsts
source ui/blanket
source ui/progressbar

LOG_DOMAIN=lightfix
SCALING=1
FILECOUNT=1

logmsg()
{
	f_log $1 ${LOG_DOMAIN} $2 "$3" "$4"
}

HACKNAME="${LOG_DOMAIN}"
HACKVER="0.0.1"

temp_crontab=`mktemp`
cat /etc/crontab/root | grep -v FrontLight > ${temp_crontab}
mv ${temp_crontab} /etc/crontab/root
update_percent_complete_scaled 1

logmsg "Lightfix uninstalled"

return 0
