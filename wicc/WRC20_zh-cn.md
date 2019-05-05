# WRC20标准


## 简介

  WRC20标准允许在智能合约中实施token的标准API。
该标准提供了定义和转移token的基本功能，以便它们可以由另一个第三方使用。
标准接口允许任何合约应用程序轻松创建和交流新token：例如钱包，DAPP和交易平台等。

## WRC20标准内容

#### 参数标准 Config

定义token的管理者owner,名称name,符号symbol,小数位decimals和总量totalSupply。

``` lua
_G.Config={
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",

    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wMHkGQKHf4CXdZRRoez8b9YgYnPzGxbs3j",

    -- the contract name, please update it with the actual contract name.
    name = "WRC20N",

    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "WRC20S",

    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,

    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 210000000 * 100000000
}
```
调用标准为：
```
 +--------+--------+
 |  0xf0  +  0x11  | 
 +--------+--------+
 length: 2 bytes
```


#### 发送转移标准 Transfer

用于`value`数量的tokens转移，来源是调用合约的地址，而转移到的地址是 `address `

*Note* 空白没有具体定义，可以自由发挥，地址和币量长度严格是34位和8位。

```
 +--------+---------+-----------------+------------------------------+-------------------+
 |  0xf0  +  0x16   |  0x00  +  0x00  |       address (34 bytes)     |  value (8 bytes)  | 
 +--------+---------+-----------------+------------------------------+-------------------+
 length: 2+2+34+8 = 46 bytes
```

***Notice:只需要魔法数为0xf0，配置参数函数序号为0x11，而转移发送函数为0x16且满足上面格式即可满足WRC20标准***

## 具体实现

#### 示例一：常用WRC20
- [WRC20_ico.lua](https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/ico.lua)


#### 示例二：模块化设计WRC20
- [WRC20_bta.lua](https://github.com/cndx/wicclua/blob/master/bta.lua)

新增加了空投模块，调用格式为：
```
 +--------+--------+
 |  0xf0  +  0x18  | 
 +--------+--------+
 length: 2 bytes
```
