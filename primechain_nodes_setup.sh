#!/bin/bash

source primechain-api.conf

seed_node_ip=$1
outputfilepath=~/primechain-api.out

rm -rf $outputfilepath

rpcuser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c40; echo`
rpcpassword=`< /dev/urandom tr -dc A-Za-z0-9 | head -c40; echo`

bash -e ubuntu_hardening.sh
bash -e ubuntu_core_member.sh $seed_node_ip $rpcuser $rpcpassword

echo -e \
'--------------------------------------------'"\n"\
'PRIMECHAIN NODE CREDENTIALS'"\n"\
'--------------------------------------------'"\n"\
'rpcuser='$rpcuser"\n"\
'rpcpassword='$rpcpassword"\n\n"\
 > $outputfilepath

cat $outputfilepath
 
echo ''
echo ''

echo -e '========================================'
echo -e 'SET UP COMPLETED SUCCESSFULLY!'
echo -e '========================================'
echo ''
echo ''
echo ''