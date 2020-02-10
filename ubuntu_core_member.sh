#!/bin/bash

source primechain-api.conf

seed_node_ip=$1
rpcuser=$2
rpcpassword=$3

if ! id $linux_admin_user >/dev/null 2>&1; then
	echo $linux_admin_user" does not exist!" 1>&2
	exit 10
fi

homedir=`su -l $linux_admin_user -c 'echo ~'`

echo '----------------------------------------'
echo -e 'INSTALLING PREREQUISITES.....'
echo '----------------------------------------'

sudo apt-get install -y curl


echo -e '----------------------------------------'
echo -e 'PREREQUISITES SUCCESSFULLY SET UP!'
echo -e '----------------------------------------'


sudo apt-get --assume-yes update
sudo apt-get --assume-yes install jq

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

sleep 3
echo '----------------------------------------'
echo -e 'CONFIGURING FIREWALL.....'
echo '----------------------------------------'

sudo ufw allow $networkport
sudo ufw allow $rpcport

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo -e '----------------------------------------'
echo -e 'FIREWALL SUCCESSFULLY CONFIGURED!'
echo -e '----------------------------------------'

echo '----------------------------------------'
echo -e 'INSTALLING & CONFIGURING MULTICHAIN.....'
echo '----------------------------------------'

wget --no-verbose http://www.multichain.com/download/multichain-$multichainVersion.tar.gz
sudo bash -c 'tar xvf multichain-'$multichainVersion'.tar.gz'
sudo bash -c 'cp multichain-'$multichainVersion'*/multichain* /usr/local/bin/'

if [ ! -d $datadir ]; then
  sudo mkdir -p $datadir;
fi

sudo chown $linux_admin_user: $datadir

echo '-------------------------------------------'
echo -e 'INITIATING CONNECTION TO BLOCKCHAIN.....'
echo '-------------------------------------------'
echo ''
echo ''

set +e
su -l $linux_admin_user -c 'multichaind '$chainname'@'$seed_node_ip':'$networkport' -daemon -datadir='$datadir
set -e

x="no"
while [ $x != "yes" ]
do
	echo -e 'GRANT PERMISSION FROM THE SEED NODE AND TYPE yes TO CONTINUE...'
	read x
done

su -l $linux_admin_user -c 'echo rpcuser='$rpcuser' > '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo rpcpassword='$rpcpassword' >> '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo rpcport='$rpcport' >> '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo rpcallowip='10.0.0.0/255.0.0.0' >> '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo rpcallowip='172.16.0.0/255.255.0.0' >> '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo rpcallowip='192.168.0.0/255.255.0.0' >> '$datadir'/'$chainname'/multichain.conf'

su -l $linux_admin_user -c 'echo "txindex=0" >> '$datadir'/'$chainname'/multichain.conf'
su -l $linux_admin_user -c 'echo "autosubscribe=assets,streams" >> '$datadir'/'$chainname'/multichain.conf'

echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''

echo '----------------------------------------'
echo -e 'RUNNING BLOCKCHAIN.....'
echo '----------------------------------------'

su -l $linux_admin_user -c 'multichaind '$chainname'@'$seed_node_ip':'$networkport' -daemon -datadir='$datadir''


echo ''
echo ''
echo '----------------------------------------'
echo ''
echo ''
echo ''
echo ''


echo '----------------------------------------'
echo -e 'SYNCRONIZING INITIAL BLOCKS.....'
echo '----------------------------------------'

sleep 3

blockchaininfo=`curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/json;' http://127.0.0.1:$rpcport | jq -r '.result'`

current_blocks_count=`echo $blockchaininfo | jq -r '.headers'`

synced_count=`echo $blockchaininfo | jq -r '.blocks'`

target_sync_count=$( (( $current_blocks_count <= 100 )) && echo $current_blocks_count || echo 100 )

echo 'Target count: '$target_sync_count

while (( $synced_count < $target_sync_count ))
do
	echo 'Synced count: '$synced_count' blocks'
	synced_count=`curl -s --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/json;' http://127.0.0.1:$rpcport | jq -r '.result["blocks"]'`
	
	sleep 0.3
done

echo ''
echo ''
echo 'SYNCRONIZED SUCCESSFULLY!'
echo ''
echo ''

echo '----------------------------------------'
echo -e 'SUBSCRIBING TO STREAMS.....'
echo '----------------------------------------'


# SUBSCRIBE STREAMS
# --------- -------

su -l $linux_admin_user -c  "multichain-cli "$chainname" -datadir="$datadir" subscribe VERIFIED_USER_MASTERLIST"
su -l $linux_admin_user -c  "multichain-cli "$chainname" -datadir="$datadir" subscribe TOKEN_MASTERLIST"
su -l $linux_admin_user -c  "multichain-cli "$chainname" -datadir="$datadir" subscribe OFFER_DETAIL_STREAM"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe FILE_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe FILE_SIGNATURE_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe DATA_SIGNATURE_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe DATA_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe ONBOARD_USERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe GREAT"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe AUTH_USERS_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe OFFER_STATUS_STREAM"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe DIRECTORY_STREAM"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe INVOICE_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe KYC_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe REVIEW_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe TRADE_DOCS_MASTERLIST"
su -l $linux_admin_user -c "multichain-cli "$chainname" -datadir="$datadir" subscribe CHARGE_MASTERLIST"

echo -e '----------------------------------------'
echo -e 'BLOCKCHAIN SUCCESSFULLY SET UP!'
echo -e '----------------------------------------'