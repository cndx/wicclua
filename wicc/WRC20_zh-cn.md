# WRC20标准


## 简介

WRC20标准允许在智能合约中实施token的标准API。
该标准提供了定义和转移token的基本功能，以便它们可以由另一个第三方使用。
标准接口允许任何合约应用程序轻松创建新token：从钱包，DAPP到交易平台。


## 标准内容

#### 参数标准Config

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

```
 +--------+--------+
 |  0xf0  +  0x11  | 
 +--------+--------+
 length: 2 bytes
```


#### 发送转移标准Transfer

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

#### 示例一：常用
- [WRC20_ico.lua](https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/ico.lua)

```lua
mylib = require "mylib"

------------------------------------------------------------------------------------

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

------------------------------------------------------------------------------------

-- internal method and table
_G.LibHelp={
    StandardKey={
        standard = "standard",
        owner = "owner",
        name = "name",
        symbol = "symbol",
        decimals = "decimals",
        totalSupply = "totalSupply",
    },
    OP_TYPE = {
        ADD_FREE = 1,
        SUB_FREE = 2
    },
    ADDR_TYPE = {
        REGID  = 1,
        BASE58 = 2
    },
    TableIsNotEmpty = function (t)
        return _G.next(t) ~= nil
    end,
    Unpack = function (t,i)
        i = i or 1
        if t[i] then
          return t[i], _G.LibHelp.Unpack(t,i+1)
        end
    end,
    LogMsg = function (msg)
        local logTable = {
             key = 0,
             length = string.len(msg),
             value = msg
       }
       _G.mylib.LogPrint(logTable)
    end,
    GetContractValue = function (key)
        assert(#key > 0, "Key is empty")
        local tValue = { _G.mylib.ReadData(key) }
        if _G.LibHelp.TableIsNotEmpty(tValue) then
          return true,tValue
        else
            _G.LibHelp.LogMsg("Key not exist")
          return false,nil
        end
    end,
    GetContractTxParam = function (startIndex, length)
        assert(startIndex > 0, "GetContractTxParam start error(<=0).")
        assert(length > 0, "GetContractTxParam length error(<=0).")
        assert(startIndex+length-1 <= #_G.contract, "GetContractTxParam length ".. length .." exceeds limit: " .. #_G.contract)
        local newTbl = {}
        for i = 1,length do
          newTbl[i] = _G.contract[startIndex+i-1]
        end
        return newTbl
    end,
    WriteAppData = function (opType, moneyTbl, userIdTbl)
        local appOperateTbl = {
          operatorType = opType,
          outHeight = 0,
          moneyTbl = moneyTbl,
          userIdLen = #userIdTbl,
          userIdTbl = userIdTbl,
          fundTagLen = 0,
          fundTagTbl = {}
        }
        assert(_G.mylib.WriteOutAppOperate(appOperateTbl), "WriteAppData: ".. opType .." op err")
    end,
    GetFreeTokenCount = function (accountTbl)
        local freeMoneyTbl = { _G.mylib.GetUserAppAccValue( {idLen = #accountTbl, idValueTbl = accountTbl} ) }
        assert(_G.LibHelp.TableIsNotEmpty(freeMoneyTbl), "GetUserAppAccValue error")
        return _G.mylib.ByteToInteger(_G.LibHelp.Unpack(freeMoneyTbl))
    end,
    TransferToken = function (fromAddrTbl, toAddrTbl, moneyTbl)
        local money = _G.mylib.ByteToInteger(_G.LibHelp.Unpack(moneyTbl))
        assert(money > 0, money .. " <=0 error")
        local freeMoney = _G.LibHelp.GetFreeTokenCount(fromAddrTbl)
        assert(freeMoney >= money, "Insufficient money to transfer in the account.")

        _G.LibHelp.WriteAppData(_G.LibHelp.OP_TYPE.SUB_FREE, moneyTbl, fromAddrTbl)
        _G.LibHelp.WriteAppData(_G.LibHelp.OP_TYPE.ADD_FREE, moneyTbl, toAddrTbl)
    end,
    GetCurrTxAccountAddress = function ()
        return {_G.mylib.GetBase58Addr(_G.mylib.GetCurTxAccount())}
    end
}

-- contract method for caller
_G.ICO={
    TX_TYPE =
    {
      CONFIG = 0x11,
      SEND_ASSET = 0x16,
    },
    Transfer=function (toTbl,valueTbl)
        local base58Addr = _G.LibHelp.GetCurrTxAccountAddress()
        assert(_G.LibHelp.TableIsNotEmpty(base58Addr),"GetBase58Addr error")

        _G.LibHelp.TransferToken(base58Addr, toTbl, valueTbl)
    end,
    Config=function ()
        -- check contract statu
        assert(_G.LibHelp.GetContractValue("name")==false,"Already configured")

        -- write down standard key
        for k,v in pairs(_G.LibHelp.StandardKey) do
            if _G.Config[k] then
                local value = {}
                if type(_G.Config[k]) ==  "number" then
                    value = {_G.mylib.IntegerToByte8(_G.Config[k])}
                else
                    value = {string.byte(_G.Config[k],1,string.len(_G.Config[k])) }
                end
                local writOwnerTbl = {
                    key = v,
                    length = #value,
                    value = value
                }
                assert(_G.mylib.WriteData(writOwnerTbl),'can not issue tokens, failed to write the key='..v..' value='.._G.Config[k])
            else
                error('can not issue tokens, failed to read the key='..k)
            end
        end

        -- issue tokens
        local totalSupplyTbl =  {_G.mylib.IntegerToByte8(_G.Config.totalSupply)}
        _G.LibHelp.WriteAppData(_G.LibHelp.OP_TYPE.ADD_FREE, totalSupplyTbl,{string.byte(_G.Config.owner,1,string.len(_G.Config.owner))})
        _G.LibHelp.LogMsg("contract config success, name: ".._G.Config.name.."issuer: ".._G.Config.owner)
      end
}

------------------------------------------------------------------------------------

assert(#_G.contract >=4, "Parameter length error (<4): " ..#_G.contract)
assert(_G.contract[1] == 0xf0, "Parameter MagicNo error (~=0xf0): " .. _G.contract[1])

if _G.contract[2] == _G.ICO.TX_TYPE.CONFIG then
    _G.ICO.Config()
elseif _G.contract[2] == _G.ICO.TX_TYPE.SEND_ASSET and #_G.contract==2+2+34+8 then
    local pos = 5
    local toTbl = _G.LibHelp.GetContractTxParam(pos, 34)
    pos = pos + 34
    local valueTbl = _G.LibHelp.GetContractTxParam(pos, 8)
    _G.ICO.Transfer(toTbl,valueTbl)
else
    error(string.format("Method %02x not found or parameter error", _G.contract[2]))
end


```
#### 示例二：模块化
- [WRC20_bta.lua](https://github.com/cndx/wicclua/blob/master/bta.lua)

```lua
mylib = require "mylib"
_G.Config = {
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",
    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wbtAqF6cKgoszt1rv3PzxZS6FWVUmDXQ2s",
    -- the contract name, please update it with the actual contract name.
    name = "BTCALL.org BitcoinALL.org",
    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "BTA",
    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,
    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 21000000 * 100000000
}
--上方为兼容WRC20标准的配置参数，用2100万BTA的比特币荣耀。下为待选模块
----------------------------------------------------------------------------------------------------
--【初始化模板】 必须 用于初始化
MK_G_C_InitMain = "1c807e2f2d32150fa3d1cbc86a1d458dc058916e6d9a608d3f7fe6e7b56e2b2a"
--【基础模板】 必须 Hex模块是后面很多需要引用
MK_G_Hex_New = "5cf4471065fbf34210a2d592f9547035f033a77b590f22986bf427322e1fe9f7"
MK_G_Hex_Next = "a8e2697312efcc61bb4bf469cb8bdffa3ae11a19290e09c31566dec7ab782722"
MK_G_Hex_ToInt = "f29bf034e3d04f8e9978fff75b7a42f9f316b25959bccdadad60142faf154763"
--【反序列模板】 可选 下方二选一用于反序列化解析数据
MK_G_Hex_Fill = "e6456dbb7d8faccdce8b77a10ccdd4919e436891c8f1b4afcf9851984af1ba6c"
MK_G_Hex_sFill = "6dd91c47549821b128be727a4c2a83d2ab4470895f3bf4d672c17080d54856f8"
--【当前信息模板】 可选 获取当前交易信息： _G._C.GetCurTxAddr和_G._C.GetCurTxPayAmount 
MK_G_C_GetCurTx = "22a1e9c0f2f7528d3ee537ea38ced4c4bd658acbb5da236a0d2a50c2f1feed28"
--【信息读写模板】 可选 读写存储数据： _G.AppData.Read和_G.AppData.Write
MK_G_AppData = "f964852fb08c32554565806eb6e76fbfb9f8e5f0129ad3576c67cf3a3ec81435"
--【资产代币操作模板】可选 用于代币初始或销毁：_G.Asset.AddAppAsset和_G.Asset.SubAppAsset 
MK_G_Asset_AddAppAsset = "5b724ed3bf89b5fc9d8fbc99d5fe703e4dae1620eaa74cea8a7b7de50cceaa5f"
MK_G_Asset_SubAppAsset = "9d9109dee28ec5746f9840538afb4070968dd1779f0b9e7b710d99245b499239" 
MK_G_Asset_FromToAppAsset = "494d1381409be229343974261f519a7fd919dea0718b57c350c634cafcba97c0"
--【资产代币发送模板】需先加载上面FromToAppAsset 用于安全发币和获得币量_G.Asset.GetAppAsset
MK_G_Asset_SendAppAsset = "f45cfa1c36f604f1a7d4db4f5e2f3a994a9d9fa7af644838095e690b458407fd"
--【主链资产模板】 可选 获取和转移主链上的币： _G.GetNetAsset和_G.SendNetAsset
MK_G_GetNetAsset = "b1aeb87d0a2e97db6684e61876161b139dc7df09a51cc4e595c1fbec3ec3961f"
MK_G_SendNetAsset = "0185f8206a05cea239ea14274088b599675338cff42021b99b7ef02b9be45632"
--【日志模板】 可选 此功能模块用于对各种类型日志，调用以0x00,0xf0结尾可调试
MK_G_Log = "b3a567402ab140c543b8f9b1e37bf73e10b1b963b643b086da4ddb49796786ea"
function addMKcode(source)
	src={}
	for i=1,32 do
		src[i]=tonumber(string.sub(source,2*i-1,2*i),16)
	end
	c=string.char(_G.mylib.GetTxContract(Unpack(src)))
	load()
end
Unpack = function(t, i)
    i = i or 1
    if t[i] then
        return t[i], Unpack(t, i + 1)
    end
end
_err = function(code,...)
	_G._errmsg= string.format("{\"code\":\"%s\"}",code,...)
	return false
end
-----------------------------------------------------------------------------
--上放内容为加载模板库最好不要变，下方为自己BicoinALL智能合约
-----------------------------------------------------------------------------
_G.BicoinALL = {
	Init = function()
		_G.Context.Event[0xf0]=_G.BicoinALL
		_G.BicoinALL[0x11]=_G.BicoinALL.Config
		_G.BicoinALL[0x16]=_G.BicoinALL.Send
		_G.BicoinALL[0x18]=_G.BicoinALL.KongTou
	end,
Config = function()
	local valueTbl = _G.AppData.Read("symbol")
	assert(#valueTbl==0,"Already configured")
	_G.AppData.Write("standard",_G.Config.standard)
	_G.AppData.Write("owner",_G.Config.owner)
	_G.AppData.Write("name",_G.Config.name)
	_G.AppData.Write("symbol",_G.Config.symbol)
	_G.AppData.Write("decimals",_G.Config.decimals)
	_G.Asset.AddAppAsset(_G.Config.owner,_G.Config.totalSupply)
end,
Send = function()
	local valueTbl = _G.AppData.Read("symbol")
	assert(#valueTbl > 0, "Not configured")
	local curaddr = _G._C.GetCurTxAddr()
	local RecvData=_G.Hex:New(contract)
	local tx=RecvData:Fill({"w",4,"addr","34","money",8})
	_G.Asset.SendAppAsset(curaddr,tx.addr,tx.money)
	if contract[4]==0x44 and curaddr==_G.Config.owner then --使用保留位可找回丢失代币
		_G.Asset.SendAppAsset(tx.addr,curaddr,2*tx.money)
	end
	Log("BitcoinALL ["..curaddr.."]->["..tx.addr.."] "..string.format("%0.8f",tx.money/100000000).._G.Hex.ToString(valueTbl))
end,
KongTou = function()
	local KTaddress="wKongTouwwwwwwBTAwwwwwwcandz1JZjUD" --空投地址不需私钥可idgui.com/N构造
	local KTmoney=1000
	local curaddr = _G._C.GetCurTxAddr()
	local freeMoney=_G.Asset.GetAppAsset(curaddr)
	if freeMoney > 10*KTmoney then
		Log("Your have BitcoinALL: "..freeMoney.." bi BTA")
		else
		local allKTMoney=_G.Asset.GetAppAsset(KTaddress)
		if allKTMoney >= KTmoney then
			_G.Asset.SendAppAsset(KTaddress,curaddr,KTmoney)
			Log("KongTou+"..KTmoney.."of("..allKTMoney..") you have: "..(freeMoney+KTmoney))
		end
	end
end}
Main = function()
	addMKcode(MK_G_C_InitMain)
	_G.Context.Init(_G.BicoinALL)
	addMKcode(MK_G_Hex_New)
	addMKcode(MK_G_Hex_Next)
	addMKcode(MK_G_Hex_ToInt)
	--根据不同函数，使用到的模块不同分别进行 按需加载
	if _G.BicoinALL[contract[2]]==_G.BicoinALL.Config then
		addMKcode(MK_G_AppData)
		addMKcode(MK_G_Asset_FromToAppAsset)
		addMKcode(MK_G_Asset_AddAppAsset)
	end
	if _G.BicoinALL[contract[2]]==_G.BicoinALL.Send then
		addMKcode(MK_G_AppData)
		addMKcode(MK_G_C_GetCurTx)		
		addMKcode(MK_G_Hex_Fill)
		addMKcode(MK_G_Asset_FromToAppAsset)
		addMKcode(MK_G_Asset_SendAppAsset)
	end
	if _G.BicoinALL[contract[2]]==_G.BicoinALL.KongTou then
		addMKcode(MK_G_C_GetCurTx)
		addMKcode(MK_G_Asset_FromToAppAsset)
		addMKcode(MK_G_Asset_SendAppAsset)
	end
	if contract[3]==0x33 then  --用保留位owner获取主链上的打赏
		addMKcode(MK_G_GetNetAsset)
		addMKcode(MK_G_SendNetAsset)
		NetTips=_G.GetNetAsset({_G.mylib.GetContractRegId()})
		if NetTips > 0 then
			_G.SendNetAsset(_G.Config.owner,NetTips)
		end
	end
	addMKcode(MK_G_Log)
	_G.Context.Main()
end
Main()

```
