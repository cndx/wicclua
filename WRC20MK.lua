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
MK_G_C_InitMain = "1c807e2f2d32150fa3d1cbc86a1d458dc058916e6d9a608d3f7fe6e7b56e2b2a"
MK_G_Hex_New = "5cf4471065fbf34210a2d592f9547035f033a77b590f22986bf427322e1fe9f7"
MK_G_Hex_Next = "a8e2697312efcc61bb4bf469cb8bdffa3ae11a19290e09c31566dec7ab782722"
MK_G_Hex_ToInt = "f29bf034e3d04f8e9978fff75b7a42f9f316b25959bccdadad60142faf154763"
MK_G_Hex_Fill = "e6456dbb7d8faccdce8b77a10ccdd4919e436891c8f1b4afcf9851984af1ba6c"
MK_G_Hex_sFill = "6dd91c47549821b128be727a4c2a83d2ab4470895f3bf4d672c17080d54856f8"
--_G._C.GetCurTxAddr _G._C.GetCurTxPayAmount 
MK_G_C_GetCurTx = "22a1e9c0f2f7528d3ee537ea38ced4c4bd658acbb5da236a0d2a50c2f1feed28"
--_G.AppData.Read _G.AppData.Write
MK_G_AppData = "f964852fb08c32554565806eb6e76fbfb9f8e5f0129ad3576c67cf3a3ec81435"
MK_G_Asset_AddAppAsset = "5b724ed3bf89b5fc9d8fbc99d5fe703e4dae1620eaa74cea8a7b7de50cceaa5f"
MK_G_Asset_SubAppAsset = "9d9109dee28ec5746f9840538afb4070968dd1779f0b9e7b710d99245b499239" 
MK_G_Asset_FromToAppAsset = "494d1381409be229343974261f519a7fd919dea0718b57c350c634cafcba97c0"
--Need FromToAppAsset    _G.Asset.GetAppAsset
MK_G_Asset_SendAppAsset = "f45cfa1c36f604f1a7d4db4f5e2f3a994a9d9fa7af644838095e690b458407fd"
MK_G_GetNetAsset = "b1aeb87d0a2e97db6684e61876161b139dc7df09a51cc4e595c1fbec3ec3961f"
MK_G_SendNetAsset = "0185f8206a05cea239ea14274088b599675338cff42021b99b7ef02b9be45632"
MK_G_Log = "b3a567402ab140c543b8f9b1e37bf73e10b1b963b643b086da4ddb49796786ea"
function addMKcode(source)
	local src={}
	for i=1,32 do
		src[i]=tonumber(string.sub(source,2*i-1,2*i),16)
	end
	local c=string.char(_G.mylib.GetTxContract(Unpack(src)))
	if loadstring then print(c) loadstring(c)()
	else load(c)() end
end
Unpack = function(t, i)
    local i = i or 1
    if t[i] then
        return t[i], Unpack(t, i + 1)
    end
end
_err = function(code,...)
	_G._errmsg= string.format("{\"code\":\"%s\"}",code,...)
	return false
end
_G.WRC20MK = {
	Init = function()
		_G.Context.Event[0xf0]=_G.WRC20MK
		_G.WRC20MK[0x11]=_G.WRC20MK.Config
		_G.WRC20MK[0x16]=_G.WRC20MK.Send
		_G.WRC20MK[0x18]=_G.WRC20MK.KongTou
	end,
Config = function()
	local valueTbl = _G.AppData.Read("symbol")
	local curaddr = _G._C.GetCurTxAddr()
	if #valueTbl>0 and curaddr==_G.Config.owner then
		contract[1]=0x20
		contract[2]=0x20
		if #contract>8  then
			_G.AppData.Write("name",_G.Hex.ToString(contract))
		elseif #contract<8  then
			_G.AppData.Write("symbol",_G.Hex.ToString(contract))
		else
			_G.AppData.Write("decimals",math.floor((_G.Hex.ToInt(contract)-8224)/65536))
		end
	end
	if #valueTbl>0 then 
		local info = "\"standard\":\"".._G.Config.standard.."\""
		info=info..",\"owner\":\"".._G.Config.owner.."\""
		info=info..",\"name\":\"".._G.Hex.ToString(_G.AppData.Read("name")).."\""
		info=info..",\"symbol\":\"".._G.Hex.ToString(valueTbl).."\""
		info=info..",\"decimals\":".._G.Hex.ToInt(_G.AppData.Read("decimals"))
		info=info..",\"totalSupply\":".._G.Config.totalSupply
		Log("Config={"..info.."}")
	else
		_G.AppData.Write("standard",_G.Config.standard)
		_G.AppData.Write("owner",_G.Config.owner)
		_G.AppData.Write("name",_G.Config.name)
		_G.AppData.Write("symbol",_G.Config.symbol)
		_G.AppData.Write("decimals",_G.Config.decimals)
		_G.Asset.AddAppAsset(_G.Config.owner,_G.Config.totalSupply)
	end
end,
Send = function()
	local valueTbl = _G.AppData.Read("symbol")
	assert(#valueTbl > 0, "Not configured")
	local curaddr = _G._C.GetCurTxAddr()
	local tx=_G.Hex:New(contract):Fill({"w",4,"addr","34","money",8})
	_G.Asset.SendAppAsset(curaddr,tx.addr,tx.money)
	local m=tx.money
	local a=_G.Asset.GetAppAsset(tx.addr)
	if m~=a then
		m=" ["..a.."] +"..m/10^_G.Hex.ToInt(_G.AppData.Read("decimals"))
	end
	Log("["..curaddr.."]->["..tx.addr.."]"..m.._G.Hex.ToString(valueTbl))
end,
KongTou = function()
	local KTaddress="wKongTouwwwwwwCNDXwwwwwwcane2L4wyW"
	local KTmoney=1000
	local curaddr = _G._C.GetCurTxAddr()
	local freeMoney=_G.Asset.GetAppAsset(curaddr)
	if freeMoney > 10*KTmoney then
		Log("You have BitcoinALL: "..freeMoney.." Bi ".._G.Config.symbol)
		else
		local allKTMoney=_G.Asset.GetAppAsset(KTaddress)
		if allKTMoney >= KTmoney then
			_G.Asset.SendAppAsset(KTaddress,curaddr,KTmoney)
			Log("KongTou+"..KTmoney.."of("..allKTMoney..") You have:"..(freeMoney+KTmoney))
			else
			Log("No KongTou("..allKTMoney.."<"..KTmoney..") You have:"..freeMoney)
		end
	end
end}
Main = function()
	addMKcode(MK_G_C_InitMain)
	_G.Context.Init(_G.WRC20MK)
	addMKcode(MK_G_Hex_New)
	addMKcode(MK_G_Hex_Next)
	addMKcode(MK_G_Hex_ToInt)
	addMKcode(MK_G_C_GetCurTx)	
	if _G.WRC20MK[contract[2]]==_G.WRC20MK.Config then
		addMKcode(MK_G_AppData)
		addMKcode(MK_G_Asset_AddAppAsset)
	end
	if _G.WRC20MK[contract[2]]==_G.WRC20MK.Send then
		addMKcode(MK_G_AppData)
		addMKcode(MK_G_Hex_Fill)
		addMKcode(MK_G_Asset_FromToAppAsset)
		addMKcode(MK_G_Asset_SendAppAsset)
	end
	if _G.WRC20MK[contract[2]]==_G.WRC20MK.KongTou then
		addMKcode(MK_G_Asset_FromToAppAsset)
		addMKcode(MK_G_Asset_SendAppAsset)
	end
	if contract[3]==0x33 then
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
-- https://wicc123.com/hy/  0x11 Config  0x16 Send 0x18 KongTou
-- contract={0xf0,0x11} 
Main()
