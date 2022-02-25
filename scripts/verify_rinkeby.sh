#!/usr/bin/env bash

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##
## !!   Create a .env file with:                                                 !! ##
## !!   ETH_RINKEBY_RPC_URL=xxx                                                  !! ##
## !!   PROFIT_ADDR=xxx                                                          !! ##
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##

## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##
## !!   Alternatively, prepend to the deploy script command like so:             !! ##
## !!   ETH_RINKEBY_RPC_URL=x PROFIT_ADDR=0xdeafbeaf... sh ./scripts/deploy.sh   !! ##
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ##
# --rpc-url $ETH_RINKEBY_RPC_URL

forge verify-contract ./src/Boomerang.sol:Boomerang 0x715da5e53526bedac9bd96e8fdb7efb185d1b6ca "Boomerang" "BOOM" 10000