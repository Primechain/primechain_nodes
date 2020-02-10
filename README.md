# Primechain nodes

## 1. Setting up other nodes 

Login to server as a sudo or root user.
```
sudo git clone https://primechainuser@github.com/Primechain/primechain_nodes
cd primechain_nodes
sudo bash -e primechain_nodes_setup.sh <primechain-master-node-ip>
```
This hardens the operating system, sets up multichain on the server and connects to a permissioned blockchain instance.

E.g. ```sudo bash -e primechain_nodes_setup.sh 52.172.139.41```

This hardens the operating system, sets up multichain on the server and connects to the permissioned blockchain instance on the PRIMECHAIN MASTER NODE. After some time, you will something like the following:

```
-------------------------------------------
INITIATING CONNECTION TO BLOCKCHAIN.....
-------------------------------------------

MultiChain 2.0.3 Daemon (latest protocol 20011)

Starting up node...

Retrieving blockchain parameters from the seed node 52.172.139.41:61172 ...
Blockchain successfully initialized.

Please ask blockchain admin or user having activate permission to let you connect and/or transact:
multichain-cli primechain grant 1aMiTQjLXABeoKtVgBcr5zzVXtT1eRvRTfY3RJ connect
multichain-cli primechain grant 1aMiTQjLXABeoKtVgBcr5zzVXtT1eRvRTfY3RJ connect,send,receive

GRANT PERMISSION FROM THE PRIMECHAIN MASTER NODE AND TYPE yes TO CONTINUE...
```
***Mining node***   
For setting up a mining node, execute the following command on the PRIMECHAIN MASTER NODE:
```
cd primechain_nodes/
sudo bash -e grant_permissions_mining_node.sh <primechain_address>
```

***Issuer node***   
For setting up an issuer node (it has send, receive, issue, connect, create permissions), execute the following command on the PRIMECHAIN MASTER NODE:
```
cd primechain_nodes/
sudo bash -e grant_permissions_issuer_node.sh <primechain_address>
```

***Non-issuer node***   
For setting up a non-issuer node (it has send, receive, connect, create permissions), execute the following command on the PRIMECHAIN MASTER NODE:
```
cd primechain_nodes/
sudo bash -e grant_permissions_non_issuer_node.sh <primechain_address>
```

***Regulator node***   
For setting up a non-issuer node (it has send, receive, connect permissions), execute the following command on the PRIMECHAIN MASTER NODE:
```
cd primechain_nodes/
sudo bash -e grant_permissions_regulator_node.sh <primechain_address>
```
***Operator node***   
For setting up an operator node (it has send, receive, issue, connect, create, admin, activate, mine permissions), execute the following command on the PRIMECHAIN MASTER NODE:
```
cd primechain_nodes1/
sudo bash -e grant_permissions_operator_node.sh <primechain_address>
```

After this, you will see: 
```
----------PERMISSIONS GRANTED----------
```
Wait a few seconds and then go to the command line of the mining node and type ```yes``` and press Enter.
Few seconds later, you will see something like this:
```
----------------------------------------
BLOCKCHAIN SUCCESSFULLY SET UP!
----------------------------------------
--------------------------------------------
API CREDENTIALS
--------------------------------------------
rpcuser=********
rpcpassword=******

========================================
SET UP COMPLETED SUCCESSFULLY!
========================================
```
Note down the rpcuser and rpcpassword. This will be needed when setting up the API server.
