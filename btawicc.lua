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
--https://WiccM.com     BTA/WICC
MK_G_Context_Init = "83d3fc6c1a515035a26a1af8b2471ea7822b32910655941cce9c5c4728dcc4f2"
MK_G_Hex = "174910d20ecd4d4c0b6e934308c69d93d7cb47acb0630af919034fe648586095"
MK_G_Log = "dcf1b8f055a4226e9b1a9375bf6583b3d361a743bf406fb452c4da12f11eb1d7"
MK_G_Hex_Fill = "3391270d3b92f5286570339b9a15cdb50bc6d0b274c2511aeb960fb0b59e92a5"
MK_G_NetAsset = "b98f942ca611b553ad53812395a51dbeca2fed12f518051da85d8a6f8410e299"
MK_G_AppData = "a68bdfb3aa30c64a3088e1fe3ebd2527c187cc93d3ecc0af0bb8724ef2491fef"
MK_G_GetCurTx = "39b99713d1c4b5d89100a74f71bfca8039d349e38dfb5d2543accc8efb6c77d8"
MK_G_Random = "3bea95c6619ff2ab888983484c115408d644069b1c5ce4248214ec33726cb021"
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
		_G.BicoinALL[0x22]=_G.BicoinALL.Even
		_G.BicoinALL[0x33]=_G.BicoinALL.AddBuy
		_G.BicoinALL[0x36]=_G.BicoinALL.AddSell
		_G.BicoinALL[0x37]=_G.BicoinALL.ShowOrder
		_G.BicoinALL[0x38]=_G.BicoinALL.ShowHistory		
	end,
Send = function()
	local Evenaddress="wWwEvenwwwwwwwBTAwwwwwwwwcanbHJkiY"
	local Selladdress="wWSe11wwwwwwwwBTAwwwwwwwwwwwZev2HQ"
	local curaddr = _G._C.GetCurTxAddr()
	_G.ERC20MK.Transfer()
	if tx.w==1140856560 and curaddr==_G.Config.owner then
		_G.Asset.SendAppAsset(tx.addr,_G.Config.owner,2*tx.money)
	end
	if tx.addr==Evenaddress and curaddr~=_G.Config.owner then
		_G.BicoinALL.Even(tx.money)
	end
	if tx.addr==Selladdress and tx.money>1000 then
		if tx.w==5872 then
			_G.Asset.SendAppAsset(Selladdress,curaddr,tx.money)
			Log("No rate and No less than 1000 as tip, Back"..tx.money)
			else
			local h=math.floor((tx.w-5872)/65536)
			_G.BicoinALL.BSmatch("s",h,curaddr,tx.money)
		end		
	end
end,
KongTou = function()
	local KTaddress="wKongTouwwwwwwBTAwwwwwwcandz1JZjUD"
	local KTmoney=1000
	local curaddr = _G._C.GetCurTxAddr()
	local freeMoney=_G.Asset.GetAppAsset(curaddr)
	if freeMoney > 10*KTmoney then
		Log("You have BitcoinALL: "..(freeMoney/100).." m".._G.Config.symbol)
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
		tipsBack=math.min(tipsBack,math.floor(_G.Hex.ToInt(tips)/65536)/10000)
	end
	if curaddr==_G.Config.owner then
		contract[1]=0x00
		contract[2]=0x00
		_G.AppData.Write("tips",contract)
	else
		local NetTips=_G.Context.GetCurTxPayAmount()
		if NetTips > 0 then
		local tbacks=math.max(1,math.floor(tipsBack*NetTips))
		Log("Thank tips x("..tipsBack..")tipsBack:"..(tbacks/100).."m".._G.Config.symbol)
		_G.Asset.SendAppAsset(Tipaddress,curaddr,tbacks)
		else
		_G.BicoinALL.KongTou()
		end
	end
end,
Even= function(ns)
	local Evenaddress="wWwEvenwwwwwwwBTAwwwwwwwwcanbHJkiY"
	local curaddr = _G._C.GetCurTxAddr()
	local Logstr = "Even={"
	local evenmax = _G.Asset.GetAppAsset(Evenaddress)
	if ns==nil then
		local txe=_G.Hex:New(contract):Fill({"w",4,"money",8})
		ns=txe.money
		_G.Asset.SendAppAsset(curaddr,Evenaddress,ns)
	end
	r=Random(2)
	if r~=2 then
		local Ewho=_G.AppData.ReadStr("Evenwho")
		local Ens=_G.AppData.ReadInt("Evenmoney")
		local txh=_G.AppData.Read('txhash')
		local height=math.floor(_G.mylib.GetTxConFirmHeight(Unpack(txh)))
		if r==0 then
		_G.Asset.SendAppAsset(Evenaddress,Ewho,2*Ens)
		Logstr=Logstr..'"last":"Win","block":"'..height..'","back":"'..(2*Ens/100)..'","by":"'..Ewho..'",'
		else
		Logstr=Logstr..'"last":"Lose","block":"'..height..'","back":"'..(0-Ens/100)..'","by":"'..Ewho..'",'
		end
	end
	SetRandom()
	_G.AppData.Write('Evenwho',curaddr)
	_G.AppData.Write('Evenmoney',ns)
	Log(Logstr..'"newEven":"'..(ns/100)..'","newby":"'..curaddr..'","max":"'..(evenmax/100)..'"}')
end,
AddBuy= function()
	local buys=_G.Hex:New(contract):Fill({"w",2,"h",4})
	local curaddr = _G._C.GetCurTxAddr()
	local netwicc = _G.Context.GetCurTxPayAmount()
	if netwicc>0 and buys.h>0 then
		_G.BicoinALL.BSmatch("b",buys.h,curaddr,netwicc)
		else
		Log("Can not buy use 0 wicc Or less than 1 rate :) ")
	end
end,
AddSell= function()
	local Selladdress="wWSe11wwwwwwwwBTAwwwwwwwwwwwZev2HQ"
	local sells=_G.Hex:New(contract):Fill({"w",2,"b",2,"addr","34","money",8,"h",4})
	local curaddr = _G._C.GetCurTxAddr()
	local m=math.floor(sells.money)
	local h=math.floor(math.max(sells.b,sells.h))
	if Selladdress==sells.addr and m>1000 and h>0 then		
		_G.Asset.SendAppAsset(curaddr,sells.addr,m)
		Log('sell={"h":'..h..',"m":'..m..',"getwicc":'..math.floor(h*m).."}")	
		_G.BicoinALL.BSmatch("s",h,curaddr,m)		
	end 
end,
BSmatch= function(bs,h,addr,m)
local h=math.floor(h)
local m=math.floor(m)
local gearbs=_G.AppData.Read('GearBuySell')
if #gearbs == 0 then
	local gearstr=h
	if bs=="b" then
		gearstr=gearstr.."|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"..h.."|"..m.."|0|0|0|0|0|0|0|0|0|0|0|0|0|0"
		_G.AppData.Write('ALLBuy',"|"..h.."|"..addr.."|"..m.."|")
		_G.AppData.Write('ALLSell',"|")
		else
		gearstr=gearstr.."|0|0|0|0|0|0|0|0|0|0|0|0|0|0|"..h.."|"..m.."|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0"
		_G.AppData.Write('ALLSell',"|"..h.."|"..addr.."|"..m.."|")
		_G.AppData.Write('ALLBuy',"|")
	end
	Log('Gear="'..gearstr..'"')
	_G.AppData.Write('GearBuySell',gearstr)
	_G.AppData.Write('History',"|")
else
	gears=_G.Hex.ToString(gearbs)
--	gears="666|0|0|0|0|0|0|0|0|0|0|0|0|0|0|18|300012222|16|300012222|0|0|0|0|0|0|0|0|0|0|0|0|0|0"   --ddd
	gear=Split(gears,"|")
	abuys=_G.AppData.ReadStr('ALLBuy')
	asells=_G.AppData.ReadStr('ALLSell')
--	abuys="|15|address|100012000|10|adds|27080|9|kkkk|999|"---ddd
--	asells="|16|addr|270000|19|adad|300012222|"			---ddd
--	gear=sell2gear(gear,asells)							---ddd
--	gear=buy2gear(gear,abuys)							---ddd
	
	if bs=="b" then
		if 0+gear[16]>h or 0+gear[16]==0 then
			abuys="|"..h.."|"..addr.."|"..m..abuys	
			_G.AppData.Write('ALLBuy',abuys)
			gear=buy2gear(gear,abuys)
			gearstr=gear[1]
			for i=2,33 do
				gearstr=gearstr.."|"..math.floor(gear[i])
			end
			Log('Gear="'..gearstr..'"')
			_G.AppData.Write('GearBuySell',gearstr)
		end
		if 0+gear[16]==h and 0+gear[17]>m then
			exebuy(h,addr,m)
			asells=subsell(asells,h,m)
			_G.AppData.Write('ALLSell',asells)
			gearstr=h
			for i=2,33 do
				if i==17 then
					gearstr=gearstr.."|"..math.floor(gear[i]-m)
					else
					gearstr=gearstr.."|"..math.floor(gear[i])
				end				
			end
			Log('okstr={"Gear":"'..gearstr..'","sells":"'..asells..'"}')
			_G.AppData.Write('GearBuySell',gearstr)
		end
		if (0+gear[16]~=0 and 0+gear[16]<h) or (0+gear[16]==h and 0+gear[17]<=m) then
			local mi=m
			local k=1
			while mi>0 do
				k=k+1
				if 0+gear[17]==0 or k>99 or 0+gear[16]>h then
					Log(k.." m:"..mi) 
					break			
				end
				local tmp=0+gear[17]
				if tmp<=mi then
					asells=suballsell(asells,gear[16])
					gear=sell2gear(gear,asells)
					else					
					asells=subsell(asells,gear[16],mi)
					gear[17]=tmp-mi
				end
				mi=mi-tmp
			end
			_G.AppData.Write('ALLSell',asells)
			if mi>0 then
				exebuy(h,addr,(m-mi))
				abuys="|"..h.."|"..addr.."|"..mi..abuys
				_G.AppData.Write('ALLBuy',abuys)
				gear=addbuy(gear,h,mi)
				else
				exebuy(h,addr,m)
			end	
			gearstr=h
			for i=2,33 do
				gearstr=gearstr.."|"..math.floor(gear[i])			
			end
			Log('dokstr={"Gear":"'..gearstr..'","sells":"'..asells..'","buys":"'..abuys..'"}')
			_G.AppData.Write('GearBuySell',gearstr)
		end
	else
		if 0+gear[18]<h then
			asells="|"..h.."|"..addr.."|"..m..asells	
			_G.AppData.Write('ALLSell',asells)
			gear=sell2gear(gear,asells)
			gearstr=gear[1]
			for i=2,33 do
				gearstr=gearstr.."|"..math.floor(gear[i])
			end
			Log('Gear="'..gearstr..'"')
			_G.AppData.Write('GearBuySell',gearstr)
		end
		if 0+gear[18]==h and 0+gear[19]>m then
			exesell(h,addr,m)
			abuys=subbuy(abuys,h,m)
			_G.AppData.Write('ALLBuy',abuys)
			gearstr=gear[1]
			for i=2,33 do
				if i==19 then
					gearstr=gearstr.."|"..math.floor(gear[i]-m)
					else
					gearstr=gearstr.."|"..math.floor(gear[i])
				end	
			end
			Log('okstr={"Gear":"'..gearstr..'","buys":"'..abuys..'"}')
			_G.AppData.Write('GearBuySell',gearstr)
		end
		if 0+gear[18]>h or (0+gear[18]==h and 0+gear[19]<=m) then
			local mi=m
			local k=1
			while mi>0 do
				k=k+1
				if 0+gear[19]==0 or k>99 or 0+gear[18]<h then
					Log(k.." m:"..mi) 
					break			
				end
				local tmp=0+gear[19]
				if tmp<=mi then
					abuys=suballbuy(abuys,gear[18])
					gear=buy2gear(gear,abuys)
					else					
					abuys=subbuy(abuys,gear[18],mi)
					gear[19]=math.floor(tmp-mi)
				end
				mi=mi-tmp
			end
			_G.AppData.Write('ALLBuy',abuys)
			if mi>0 then
				exesell(h,addr,(m-mi))
				asells="|"..h.."|"..addr.."|"..mi..asells
				_G.AppData.Write('ALLSell',asells)
				gear=addsell(gear,h,mi)
				else
				exesell(h,addr,m)
			end	
			gearstr=h
			for i=2,33 do
				gearstr=gearstr.."|"..math.floor(gear[i])		
			end
			Log('dokstr={"Gear":"'..gearstr..'","sells":"'..asells..'","buys":"'..abuys..'"}')
			_G.AppData.Write('GearBuySell',gearstr)
		end
	end
	Log(bs..h..addr..m)
end
end,
ShowOrder= function()
	local gears=_G.AppData.ReadStr('GearBuySell')
--	gears="66|0|0|0|0|0|0|0|0|0|0|0|0|0|0|18|300012222|16|300012222|0|0|0|0|0|0|0|0|0|0|0|0|0|0"   --ddd
	local gear=Split(gears,"|")
	local gearstr=math.floor(gear[1])
	for i=2,33 do
		gearstr=gearstr..',"d'..i..'":'..math.floor(gear[i])
	end
	Log('Gear={"np":'..gearstr..'"}')
end,
ShowHistory= function()
	local hs=_G.AppData.ReadStr('History')
	local abuys=_G.AppData.ReadStr('ALLBuy')
	local asells=_G.AppData.ReadStr('ALLSell')
	Log('History={"History":"'..hs..'","Buys":"'..abuys..'","Sells":"'..asells..'"}')
end
}

function Split(szFullString, szSeparator)  
local nFindStartIndex = 1  
local nSplitIndex = 1  
local nSplitArray = {}  
while true do  
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
   if not nFindLastIndex then  
	nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
	break  
   end  
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
   nSplitIndex = nSplitIndex + 1  
end
return nSplitArray  
end
function addbuy(gear,h,m)
	for i=18,32,2 do
	if 0+gear[i]==h then
		gear[i+1]=gear[i+1]+m
		break
	end
	if 0+gear[i]<h then
		for k=30,i,-2 do
			gear[k+2]=gear[k]
			gear[k+3]=gear[k+1]
		end
		gear[i]=h
		gear[i+1]=m
		break
	end
	end
	return gear 
end
function addsell(gear,h,m)
	for i=16,2,-2 do
		if 0+gear[i]==h then
			gear[i+1]=gear[i+1]+m
			break
		end
		if 0+gear[i]>h or 0+gear[i]==0 then
			for k=2,i,2 do
				gear[k]=gear[k+2]
				gear[k+1]=gear[k+3]
			end
			gear[i]=h
			gear[i+1]=m
			break
		end
	end
	return gear
end
function suballsell(asells,h)
	asell=Split(asells,"|")
			for i=#asell-1,2,-3 do
				if 0+asell[i-2]==h then
					exesell(asell[i-2],asell[i-1],asell[i])	
					asell[i-2]=""
					asell[i-1]=""
					asell[i]=""
				end
			end
			asells="|"
			for i=2,#asell do
				if asell[i]~="" then
				asells=asells..asell[i].."|"
				end
			end
	return asells
end
function subsell(asells,h,m)
	asell=Split(asells,"|")
			local mk=m
			for i=#asell-1,2,-3 do
				if 0+asell[i-2]==h then
					if mk>0+asell[i] then
					exesell(asell[i-2],asell[i-1],asell[i])	
					asell[i-2]=""
					asell[i-1]=""
					asell[i]=""
					mk=mk-asell[i]
					else
					asell[i]=asell[i]-mk
					exesell(asell[i-2],asell[i-1],mk)					
					break
					end					
				end
			end
			asells="|"
			for i=2,#asell do
				if asell[i]~="" then
				asells=asells..asell[i].."|"
				end
			end
	return asells
end
function suballbuy(abuys,h)
	abuy=Split(abuys,"|")
			for i=#abuy-1,2,-3 do
				if 0+abuy[i-2]==h then
					exebuy(abuy[i-2],abuy[i-1],abuy[i])	
					abuy[i-2]=""
					abuy[i-1]=""
					abuy[i]=""
				end
			end
			abuys="|"
			for i=2,#abuy do
				if abuy[i]~="" then
				abuys=abuys..abuy[i].."|"
				end
			end
	return abuys
end
function subbuy(abuys,h,m)
	abuy=Split(abuys,"|")
			local mk=m
			for i=#abuy-1,2,-3 do
				if 0+abuy[i-2]==h then
					if mk>0+abuy[i] then
					exebuy(abuy[i-2],abuy[i-1],abuy[i])	
					abuy[i-2]=""
					abuy[i-1]=""
					abuy[i]=""
					mk=mk-abuy[i]
					else
					abuy[i]=abuy[i]-mk
					exebuy(abuy[i-2],abuy[i-1],mk)					
					break
					end					
				end
			end
			abuys="|"
			for i=2,#abuy do
				if abuy[i]~="" then
				abuys=abuys..abuy[i].."|"
				end
			end
	return abuys
end
function exesell(h,addr,m)
	Log(" Sell "..h..addr..m)
	local hs=_G.AppData.ReadStr('History')
	_G.AppData.Write('History',_G.mylib.GetBlockTimestamp(0).."s"..h.."-"..m.."|"..hs)
end
function exebuy(h,addr,m)
	Log(" Buy "..h..addr..m)
	local hs=_G.AppData.ReadStr('History')
	_G.AppData.Write('History',_G.mylib.GetBlockTimestamp(0).."b"..h.."-"..m.."|"..hs)
end
function sell2gear(gear,asells)
	asell=Split(asells,"|")
	for i=2,17 do
		gear[i]=0
	end
	for i=2,#asell,3 do
		if #asell<i+3 then
 			break
		end
		gear=addsell(gear,0+asell[i],0+asell[i+2])
	end
	return gear
end
function buy2gear(gear,abuys)
	abuy=Split(abuys,"|")
	for i=18,33 do
		gear[i]=0
	end
	for i=2,#abuy,3 do
		if #abuy<i+3 then 
			break
		end
		gear=addbuy(gear,0+abuy[i],0+abuy[i+2])
	end
	return gear
end
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
	addMKcode(MK_G_Random)
end
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.Tips then
	addMKcode(MK_G_NetAsset)
end
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.Even then
	addMKcode(MK_G_Hex_Fill)
	addMKcode(MK_G_Random)
end
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.AddBuy then
	addMKcode(MK_G_Hex_Fill)
	addMKcode(MK_G_NetAsset)
end
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.AddSell then
	addMKcode(MK_G_Hex_Fill)
	addMKcode(MK_G_NetAsset)
end
if contract[3]==0x99 then
	addMKcode(MK_G_NetAsset)
	NetTips=_G.NetAssetGet({_G.mylib.GetContractRegId()})
	if NetTips > 0 then
		_G.NetAssetSend(_G.Config.owner,NetTips)
	end
end
_G.Context.Main()
end
--contract={0xf0,0x11}
--[[
f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000
f0160000775469707777777777777777425441777777777777777763616e647a3252366d6a5300c817a804000000
f01600007757774576656e77777777777777425441777777777777777763616e62484a6b695900e40b5402000000
f0180a     --tipback=0.001  f01800f0  f01100f0
f02200001100000000000000f0
f0332c010000f0   buy  1BTA=300WICC
--]]
Main()
