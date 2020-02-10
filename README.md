# Setting up Primechain nodes

You can connect multiple non-seed nodes to a running Primechain blockchain. Login to a newly created Ubuntu VM that you will use as a non-seed node.
```
sudo git clone https://primechainuser@github.com/Primechain/primechain_nodes
cd primechain_nodes
sudo bash -e primechain_nodes_setup.sh <primechain-seed-node-ip>
```
This does 
1. hardens the operating system, 
2. sets up the blockchain on the non-seed server

After some time, you will something like the following:

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

Login to the Primechain Seed Node and run the following:
```
su primechain-user
cd ~
multichain-cli primechain grant 1aMiTQjLXABeoKtVgBcr5zzVXtT1eRvRTfY3RJ connect
```
**Note:** Don't forget to use the correct address in "multichain-cli primechain grant" above.

After this, you will see a transaction ID like `fae186b309cf396f3a5e0f8dddbdb7d9ab4dd8bd08c69d5b044be19f030f4fc7`

Wait a few seconds and then go to the command line of the non-seed node and type ```yes``` and press Enter.
Few seconds later, you will see something like this:
```
----------------------------------------
BLOCKCHAIN SUCCESSFULLY SET UP!
----------------------------------------
--------------------------------------------
PRIMECHAIN NODE CREDENTIALS
--------------------------------------------
rpcuser=Tzt5COtBS9jeADGOlwMRj9akTyWlCgkZDcqgkQZc
rpcpassword=fzQQMIMJa1mKlDfghQPBQ0uYxgmqdLaYHqjYtTxe

========================================
SET UP COMPLETED SUCCESSFULLY!
========================================
```
Note down the rpcuser and rpcpassword. 
