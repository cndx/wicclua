---
标题title: WRC20代币标准 WRC20 Token Standard
作者author: cndx等
类型type: 标准类 Standards
状态status: 定稿 Final
时间created: 2019-05-06
---

# WRC20代币标准


## 简介

　　WRC20标准用于规范在维基链智能合约中实施发行token代币的标准。该标准主要提供了定义和转移token的基本功能内容要求，以便代币能规范统一，可方便地由第三方的接入使用。采用WRC20标准发行的代币，可以由任何应用轻松创建和流通新token，能广泛应用在钱包，DAPP应用和交易平台等场景。

## WRC20标准内容

#### 参数配置标准 Config

　　标准规定定义token代币的参数内容有：标准standard,管理者owner,名称name,符号symbol,小数位decimals和总量totalSupply。一般会放在_G.Config表中。

　　参数标准 standard，参数赋值是WRC20，用来告知代币所采用的标准，不要修改，若修改遵循其它标准了。
``` lua
_G.Config={
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",
```
　　参数管理者 owner，参数赋值是合约拥有者或者管理者的币地址，将用来接收全部的代币和管理合约。
``` lua
    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wMHkGQKHf4CXdZRRoez8b9YgYnPzGxbs3j",
```
　　参数名称 name，参数赋值是对本智能合约和代币名称命名或简短描述。
``` lua
    -- the contract name, please update it with the actual contract name.
    name = "WRC20 Name",
```
　　参数符号 symbol，参数赋值是合约代币的符号缩写，也会作为代币主单位，建议设为三位或四位大写字母。
``` lua
    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "WRC",
```
　　参数小数位 decimals，参数赋值是数字，在ERC20标准下为8，即八位小数。除以1亿后为显示币量。
``` lua
    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,
```
　　参数总量 totalSupply，参数赋值是总币量，因小数位参数为八位小数，建议用乘法乘1亿来表示，以便于看总币量。
``` lua
    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 210000000 * 100000000
}
```
　　在WRC20标准具体的实现中，需要将上面参数赋值的内容，写入到以参数名为名的数据中。以便一些应用可通过调用RPC命令时，可以用`getcontractdata`命令实现读取WRC20标准合约代币的参数信息。

#### 初始化标准 0x11

　　调用合约的标准为：
```
 +--------+--------+
 |  0xf0  +  0x11  | 
 +--------+--------+
 length: 2 bytes
```
　　WRC20标准要求魔法数0xf0，方法是对应0x11，方法的具体内容是将上面的参数标准_G.Config中的各参数数据，通过`_G.mylib.WriteOutAppOperate`函数以对应的变量名地写入区块链数据中。
  
　　同时需要将totalSupply总量的全部代币，通过`_G.mylib.WriteOutAppOperate`函数全部直接增加到管理者owner的地址。

　　***注意对这个调用，WRC20标准需要其方法内容只能运行一次，当再次运行时需要判断已经初始化而跳过。***

#### 发送转移标准 0x16

　　调用合约的标准为：
```
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 |  0xf0  +  0x16  |   0x00 + 0x00   |            address (34 bytes)         |    value (8 bytes)    | 
 +--------+--------+-----------------+---------------------------------------+-----------------------+
 length: 2+2+34+8 = 46 bytes
```
　　WRC20标准要求魔法数0xf0，方法是对应0x16，之后依次是0x00,0x00两字节的空白保留位，34字节的币地址`address`和8字节的发送`value`币数量。

　　方法的内容是进行`value`币量的tokens代币转移，币来源是当前调用合约的地址，而转移到的地址是 `address`

　　中间的两字节的空白位，在WRC20标准中没有具体定义功能，正常建议用0x00,0x00。具体合约中也可自由发挥，地址和币量长度需严格是34位和8位。

　　***注意Notice:在转移发送0x16之前，需要已经是初始化0x11后的状态，且有足够的币量可以用于去支付发送。***

## 具体实现

#### 示例一：常用WRC20实例链接
　　- [WRC20_ico.lua](https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/ico.lua)　　：代码简洁，经过了方法封装，且巧妙通过循环来写入参数变量。
  
　　- [WRC20 Sample](https://www.wiccdev.org/book/zh-hans/Contract/ico_sample.html)　　：维基链官方开发者文档中给出的示例，经过严格测试，被众多WRC20代币使用。


#### 示例二：模块化设计WRC20实例链接
　　- [WRC20_bta.lua](https://github.com/cndx/wicclua/blob/master/bta.lua)　　：模块化实现，能有更好的扩展，新增加空投方法，调用格式为：
```
 +--------+--------+
 |  0xf0  +  0x18  | 
 +--------+--------+
 length: 2 bytes
```

## 相关链接

　　英文版本：https://github.com/cndx/wicclua/blob/master/wicc/WRC20.md
  
　　开发者文档WRC20说明：https://www.wiccdev.org/book/zh-hans/Contract/ico_sample.html
