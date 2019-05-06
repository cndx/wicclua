---
标题title: WRC20代币标准 WRC20 Token Standard
作者author: cndx
类型type: 标准类 Standards
状态status: 草稿 Draft
时间created: 2019-05-06
---

# WRC20代币标准


## 简介

  WRC20标准允许在智能合约中实施token的标准API。该标准提供了定义和转移token的基本功能，以便它们可以由另一个第三方使用。标准接口允许任何合约应用程序轻松创建和交流新token：例如钱包，DAPP和交易平台等。

## WRC20标准内容

#### 参数标准 Config

定义token的管理者owner,名称name,符号symbol,小数位decimals和总量totalSupply。
首个参数是standard标准，参数赋值是WRC20，用来告知代币采用的标准，不要修改。
``` lua
_G.Config={
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",
```
管理者owner，参数赋值是合约拥有者或者说管理者的币地址，将用来接收全部的代币。
``` lua
    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wMHkGQKHf4CXdZRRoez8b9YgYnPzGxbs3j",
```
名称name，参数赋值是合约名称或简单描述。
``` lua
    -- the contract name, please update it with the actual contract name.
    name = "WRC20N",
```
符号symbol，参数赋值是合约代币的符号缩写，建议一般为三位或四位大写字母。
``` lua
    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "WRC",
```
小数位decimals，参数赋值是数字，在ERC20标准下为8，即八位小数。除以1亿后为币量。
``` lua
    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,
```
总量totalSupply，参数赋值是总币量，因八位小数，建议可用乘法乘以1亿来表示，以便于看出总币量。
``` lua
    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 210000000 * 100000000
}
```

#### 初始化标准 0x11

调用合约的标准为：
```
 +--------+--------+
 |  0xf0  +  0x11  | 
 +--------+--------+
 length: 2 bytes
```
WRC20魔法数0xf0，方法是对应0x11，方法的内容是将上面的参数标准Config中的数据写入区块链。

#### 发送转移标准 0x16

调用合约的标准为：
```
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 |  0xf0  +  0x16  |   0x00 + 0x00   |            address (34 bytes)         |    value (8 bytes)    | 
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 length: 2+2+34+8 = 46 bytes
```

用于`value`数量的tokens代币转移，来源是调用合约的地址，而转移到的地址是 `address `

空白没有具体定义，可以自由发挥，地址和币量长度严格是34位和8位。


***Notice:只需要魔法数为0xf0，配置参数函数序号为0x11，而转移发送函数为0x16且满足上面格式即可满足WRC20标准***

## 具体实现

#### 示例一：常用WRC20
- [WRC20_ico.lua](https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/ico.lua)
- [WRC20 Sample](https://www.wiccdev.org/book/en/Contract/ico_sample.html)


#### 示例二：模块化设计WRC20
- [WRC20_bta.lua](https://github.com/cndx/wicclua/blob/master/bta.lua)

新增加空投模块，调用格式为：
```
 +--------+--------+
 |  0xf0  +  0x18  | 
 +--------+--------+
 length: 2 bytes
```
