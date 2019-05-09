---
title: WRC20 Token Standard
author: cndx
type: Standards
status: Final
created: 2019-05-06
---

# WRC20


## Abstract

The following standard allows for the implementation of a standard for tokens within waykichain LUA smart contracts.　This standard provides basic functionality to transfer tokens, as well as allows tokens to be approved so they can be spent by another third party, like Wallet , DAPP and Exchange.


## Standard

#### Config

The owner,name,symbol,decimals and totalSupply of the token.

``` lua
_G.Config={
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",

    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wMHkGQKHf4CXdZRRoez8b9YgYnPzGxbs3j",

    -- the contract name, please update it with the actual contract name.
    name = "WRC20 Name",

    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "WRC",

    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,

    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 210000000 * 100000000
}
```
#### Set_Config 0x11
```
 +--------+--------+
 |  0xf0  +  0x11  | 
 +--------+--------+
 length: 2 bytes
```
　1.Use `_G.mylib.WriteData` : every variable in `_G.Config` write to blockchain.
 
  2.Use `_G.mylib.WriteOutAppOperate` : add  `totalSupply` amount of tokens to `owner` address.
  
  ***Notice:Only run once , more times shoud skip.***

#### Transfer_Send 0x16

```
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 |  0xf0  +  0x16  |   0x00 + 0x00   |            address (34 bytes)         |    value (8 bytes)    | 
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 length: 2+2+34+8 = 46 bytes
```
  Transfers `value` amount of tokens form `_G.mylib.GetCurTxAccount` to `address `.
  
  White place 0x00 + 0x00 is not definded in WRC20 , you can use it in your contracts.

***Notice:Should set config frist , before transfer send tokens.***


## Implementation

#### Example implementations are available at
- [WRC20.lua](https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/ico.lua)
- [WRC20 Sample](https://www.wiccdev.org/book/zh-hans/Contract/ico_sample.html)

#### Example Modularization
- [WRC20_bta.lua](https://github.com/cndx/wicclua/blob/master/bta.lua)
```
 +--------+--------+
 |  0xf0  +  0x18  | 
 +--------+--------+
 length: 2 bytes
```

## Links

zh-cn Version：https://github.com/cndx/wicclua/blob/master/wicc/WRC20_zh-cn.md

WaykiChain Developer Documentation：https://www.wiccdev.org/book/zh-hans/Contract/ico_sample.html
