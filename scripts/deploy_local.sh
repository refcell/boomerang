#!/usr/bin/env bash

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##
## !!   Create a .env file with:                                                 !! ##
## !!   ETH_LOCAL_RPC_URL=xxx                                                    !! ##
## !!   PROFIT_ADDR=xxx                                                          !! ##
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##
## !!   Alternatively, prepend to the deploy script command like so:             !! ##
## !!   ETH_LOCAL_RPC_URL=x PROFIT_ADDR=0xdeafbeaf... sh ./scripts/deploy.sh     !! ##
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##

## Fork Mainnet
make mainnet-fork &

## Wait for the fork to spawn before deploying
sleep 10 && forge create ./src/Boomerang.sol:Boomerang --private-key $DEPLOYER_PRIVATE_KEY --rpc-url $ETH_LOCAL_RPC_URL --constructor-args "Boomerang" --constructor-args "BOOM" --constructor-args 10000
