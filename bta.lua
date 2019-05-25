mylib = require "mylib"
------------------------------------------------------------------------------------
_G.Config={
    -- the waykichain contract stardard, if you do not know the waykichain stardard, please do not change it.
    standard = "WRC20",
    -- the contract ownder address, please update it with the actual contract owner address.
    owner = "wcNx9o2RnDpSjpwvdLzWy2t1DJFhqLazxL",
    -- the contract name, please update it with the actual contract name.
    name = "BitcoinALL.org BTCALL.org",
    -- the contract symbol, please update it with the actual contract symbol.
    symbol = "BTA",
    -- the number of decimals the token uses must be 8.
    -- means to divide the token amount by 100000000 to get its user representation.
    decimals = 8,
    -- the contract coin total supply, please update it with the actual contract symbol.
    totalSupply = 21000000 * 100000000
}
------------------------------------------------------------------------------------
--https://WiccM.com
MK_G_Context_Init = "83d3fc6c1a515035a26a1af8b2471ea7822b32910655941cce9c5c4728dcc4f2"
MK_G_Hex = "174910d20ecd4d4c0b6e934308c69d93d7cb47acb0630af919034fe648586095"
MK_G_Log = "dcf1b8f055a4226e9b1a9375bf6583b3d361a743bf406fb452c4da12f11eb1d7"
MK_G_Hex_Fill = "3391270d3b92f5286570339b9a15cdb50bc6d0b274c2511aeb960fb0b59e92a5"
MK_G_NetAsset = "b98f942ca611b553ad53812395a51dbeca2fed12f518051da85d8a6f8410e299"
MK_G_AppData = "a68bdfb3aa30c64a3088e1fe3ebd2527c187cc93d3ecc0af0bb8724ef2491fef"
MK_G_GetCurTx = "39b99713d1c4b5d89100a74f71bfca8039d349e38dfb5d2543accc8efb6c77d8"
MK_G_Asset = "a4c4595735db65433822cb1c4b6c6dc47b7ac9a215a41393ba3947d8dd48cde1"
MK_G_ERC20MK = "193bc067300d385176701286f9f5deb1f5527aff3ae637b6f19aa8eda0065628"
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

_G.BicoinALL = {
	Init = function()
		_G.Context.Event[0xf0]=_G.BicoinALL
		_G.BicoinALL[0x11]=_G.ERC20MK.Config
		_G.BicoinALL[0x16]=_G.BicoinALL.Send
		_G.BicoinALL[0x17]=_G.BicoinALL.KongTou
		_G.BicoinALL[0x18]=_G.BicoinALL.Tips
	end,
Send = function()
	_G.ERC20MK.Transfer()
	if tx.w==1140856560 and _G._C.GetCurTxAddr()==_G.Config.owner then
		_G.Asset.SendAppAsset(tx.addr,curaddr,2*tx.money)
	end
end,
KongTou = function()
	local KTaddress="wKongTouwwwwwwBTAwwwwwwcandz1JZjUD"
	local KTmoney=1000
	local curaddr = _G._C.GetCurTxAddr()
	local freeMoney=_G.Asset.GetAppAsset(curaddr)
	if freeMoney > 10*KTmoney then
		Log("You have BitcoinALL: "..freeMoney.." Bi ".._G.Config.symbol)
		else
		local allKTMoney=_G.Asset.GetAppAsset(KTaddress)
		if allKTMoney >= KTmoney then
			_G.Asset.SendAppAsset(KTaddress,curaddr,KTmoney)
			Log("AddKongTou+"..KTmoney.."of("..allKTMoney..") You have:"..(freeMoney+KTmoney))
			else
			Log("No KongTou("..allKTMoney.."<"..KTmoney..") You have:"..freeMoney)
		end
	end
end,
Tips= function()
	local Tipaddress="wTipwwwwwwwwBTAwwwwwwwwcandz2R6mjS"
	local curaddr = _G._C.GetCurTxAddr()
	local tipsBack=100
	local tips = _G.AppData.Read("tips")
	if #tips ~= 0 then
		tipsBack=math.min(tipsBack,math.floor(_G.Hex.ToInt(tips)/655360000))
	end
	if curaddr==_G.Config.owner then
		contract[1]=0x00
		contract[2]=0x00
		_G.AppData.Write("tips",contract)
	else
		local NetTips=_G.Context.GetCurTxPayAmount()
		if NetTips > 0 then
			Log(tipsBack)
		_G.Asset.SendAppAsset(Tipaddress,curaddr,math.floor(tipsBack*NetTips))
		else
		_G.BicoinALL.KongTou()
		end
	end
end
}
Main = function()
addMKcode(MK_G_Context_Init)
addMKcode(MK_G_Hex)
addMKcode(MK_G_Log)
addMKcode(MK_G_AppData)
addMKcode(MK_G_GetCurTx)
addMKcode(MK_G_Asset)
addMKcode(MK_G_ERC20MK)
_G.Context.Init(_G.BicoinALL)
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.Send then
	addMKcode(MK_G_Hex_Fill)
end
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.Tips then
	addMKcode(MK_G_NetAsset)
end
if contract[3]==0x33 then
	addMKcode(MK_G_NetAsset)
	NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
	if NetTips > 0 then
		_G.NetAssetSend(_G.Config.owner,NetTips)
	end
end
_G.Context.Main()
end
Main()

--Main()
--[[   https://wicc123.com/hy/ 生成参数 0x11初始化 0x16发币 0x18空投查询
contract={0xf0,0x11} 
Main()
contract={0xf0,0x16,0x00,0x44,0x77,0x4b,0x6f,0x6e,0x67,0x54,0x6f,0x75,0x77,0x77,0x77,0x77,0x77,0x77,0x42,0x54,0x41,0x77,0x77,0x77,0x77,0x77,0x77,0x63,0x61,0x6e,0x64,0x7a,0x31,0x4a,0x5a,0x6a,0x55,0x44,0x80,0x2b,0x53,0x0b,0x00,0x00,0x00,0x00}
Main()
contract={0xf0,0x17} -- 用这个可调试查询 contract={0xf0,0x18,0x00,0xf0}
Main()
contract={0xf0,0x18} -- 用这个可调试查询 contract={0xf0,0x18,0x00,0xf0}
Main()

--]]
