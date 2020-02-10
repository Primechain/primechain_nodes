#!/bin/bash

addr=$1
source primechain-api.conf

# Grant permissions
echo '----------------------------------------'
echo -e ${CYAN}${bold}'GRANTING PERMISSIONS:'${normal}${LIGHTYELLOW}
echo '----------------------------------------'

su -l $linux_admin_user -c 'multichain-cli '$chainname' grant '$addr' connect,send,receive,issue,create'

echo ''
echo ''
echo -e ${CYAN}${bold}'----------PERMISSIONS GRANTED----------'${normal}${NC}
echo ''
echo ''