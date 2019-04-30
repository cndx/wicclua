mylib = {}
		-- Form https://wicc123.com/mylib  代码后面有使用说明见：https://wicc123.com/lua
		-- Use https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/context.lua
	mylib.constant = "cndx MyLib v2.0.0"
	GetCurTxAccount="wWwvRtscu5Aho8nLfZKDctgXrstE3K8Soh"	--调用合约的用户地址	_G._C.GetCurTxAddr()
	GetCurTxPayAmount=100012222					--调用合约时向其转入WICC额  _G._C.GetCurTxPayAmount()
	AssetGetNetAsset=21000033330006			--指定地址中WICC币可用余额  _G.GetNetAsset(address)
	AssetGetAppAsset=33000022220000			--指定地址中代币可用余额   _G.Asset.GetAppAsset(address)	
	ReadnilData="needVote,pColorB,pStateB"	--将变量名称放在这，则读取数据时为空
	ReadDataconfig="config,sets,symbol"			--变量名称放在，读取数据时第一次为空，第二次则非空
	mylib.ReadDataTable=true				--若设为false需要下方的mylib.ReadData的返回时不加{}
	
	function mylib.ReadData(param)
		print("ReadData form param: " , param)
		if param=="name" then				--特定key返回读取下面数据		_G.AppData.Read(key)
			local readstr="BTA"
			local readstrTbl = {string.byte(readstr,1,string.len(readstr))}
			return readstrTbl
		elseif string.sub(param,1,4)=="pTxt" then			--特定key返回读取下面数据
			return {0x7C,0x3E,0xAC,0x7C,0x3E,0x01,0x7C,0x3E}
		elseif string.sub(param,1,8)=="needVote" then	--特定key返回读取下面数据
			return {0x02,0x03,0x01,0x02,0x01}
		elseif string.find(ReadnilData,param) then
			return nil
		elseif string.find(ReadDataconfig,param) then
			rtnconfig=cfg
			cfg={0x50,0x49,0x43}
			return rtnconfig
		end
		return {0x61,0x62,0x63,0x00,0x10,0x00,0x00,0x00}	--默认返回的读取内容
	end
	function mylib.IntegerToByte8(param)
		bt={param%256}
		for i=2,8 do
			bt[i]=math.floor(param/256^(i-1))%256
		end
		return bt[1],bt[2],bt[3],bt[4],bt[5],bt[6],bt[7],bt[8]
	end
	function mylib.ByteToInteger(...)
		ints=0
		temp = {...}
		arg = select("1",temp) 
		assert(#arg == 4 or #arg == 8 , "ByteToInteger only 4 or 8, Byte len=" .. #arg )
		for i=1,#arg do
			ints=ints+arg[i]*256^(i-1)
		end
		return ints
	end
	function mylib.GetBase58Addr(param)
		a={}
		for i=1,34 do
			a[i]=string.byte(GetCurTxAccount,i)
		end
		return Unpack(a)
	end
	function mylib.GetCurTxAccount()
		return 0x61, 0x62, 0x63, 0x64, 0x65, 0x66
	end
	function mylib.GetCurTxPayAmount()
		bt={GetCurTxPayAmount%256}
		for i=2,8 do
			bt[i]=math.floor(GetCurTxPayAmount/256^(i-1))%256
		end
		return bt[1],bt[2],bt[3],bt[4],bt[5],bt[6],bt[7],bt[8]
	end
	function mylib.GetUserAppAccValue(param)
		bt={AssetGetAppAsset%256}
		for i=2,8 do
			bt[i]=math.floor(AssetGetAppAsset/256^(i-1))%256
		end
		return bt[1],bt[2],bt[3],bt[4],bt[5],bt[6],bt[7],bt[8]
	end
	function mylib.LogPrint(logTable)
		print("LogPrint" , logTable.key , logTable.value)
	end
	function mylib.WriteOutAppOperate(param)
		print("WriteOutAppOperate ",param," param.userIdLen ",param.userIdLen)
		return true
	end
	function mylib.WriteOutput(param)
		print("WriteOutput ",param)
		return true
	end
	function mylib.GetScriptID()
		return 0x01, 0x02, 0x03, 0x04, 0x05, 0x06
	end
	function mylib.GetContractRegId()
		return 0x01, 0x02, 0x03, 0x04, 0x05, 0x06
	end
	function mylib.ModifyData(param)
		print("ModifyData: param.value" , param.value)
		return true
	end
	function mylib.WriteData(writeDbTbl)
		print("WriteDataKey:", writeDbTbl.key,"  #["..writeDbTbl.length.."]")
		return true
	end
	function mylib.DeleteData(deleteDbTbl)
		print("DeleteDataKey:", deleteDbTbl.key)
		return true
	end
	function mylib.QueryAccountBalance(param)
		bt={AssetGetNetAsset%256}
		for i=2,8 do
			bt[i]=math.floor(AssetGetNetAsset/256^(i-1))%256
		end
		return bt[1],bt[2],bt[3],bt[4],bt[5],bt[6],bt[7],bt[8]
	end
	function mylib.GetTxContract(param)
		a={}
		print(string.format("MK add   %02X",param))
		if param==0x1c then
			strs='  _G.Context={ Event={}, Init=function(...) assert(contract or _G._err(0000,CallFunc),_G._errmsg) for k,v in pairs({ ... }) do if v.Init~=nil then v.Init() end end end, LoadContract=function() if #contract>0 then CallDomain=contract[1] CallFunc=contract[2] end end, Main=function() _G._C=_G.Context _G._C.LoadContract() if _G._C.Event[CallDomain] and _G._C.Event[CallDomain][CallFunc] then _G._C.Event[CallDomain][CallFunc]() else assert(_G._err(0404,CallFunc),_G._errmsg) end end}_G.Asset={}'
		end
		if param==0x5c then
			strs="  _G.Hex={New=function(s,d) local mt={} if (type(d)=='string') then for i=1,#d do table.insert(mt,string.byte(d,i)) end elseif d~=nil then mt=d end setmetatable(mt,s) s.__index=s s.__eq=_G.Hex.__eq s.__tostring=_G.Hex.ToString s.__concat=_G.Hex.__concat return mt end, ToString=function(s) return string.char(Unpack(s)) end, __concat=function(s,t) return s:ToString()..t end, __eq=function(s,t) if #s~=#t then return false end for i=#s,1,-1 do if s[i]~=t[i] then return false end end return true end}"
		end
		if param==0xa8 then
			strs="  _G.Hex.Posit=1 _G.Hex.Appand=function(s,t) for i=1,#t do s[#s+1]=t[i] end return s end _G.Hex.Select=function(s,start,lens) local nt={} for i=1,lens do nt[i]=s[start+i-1] end return _G.Hex:New(nt) end _G.Hex.Skip=function(s,count) local nt={} for i=1,#s do nt[i]=s[count+i] end return _G.Hex:New(nt) end _G.Hex.Next=function(s,lens) local nt={} for i=1,lens do nt[i]=s[s.Posit] s.Posit=s.Posit+1 end return _G.Hex:New(nt) end _G.Hex.IsEmptyOrNil=function(s) return _G.next(s)==nil or #s==0 end"
		end
		if param==0xf2 then
			strs="  _G.Hex.ToInt=function(s) local s=_G.Hex:New(s) s=s:Appand({0x00,0x00,0x00}) if #s<8 then s=s:Select(1,4) else s=s:Select(1,8) end return _G.mylib.ByteToInteger(Unpack(s)) end _G.Hex.__fillloop=function(s,t) local endPosit=#s if t.Loop<0 then t.Loop=s:Next(math.abs(t.Loop)):ToInt() end if t.Loop>0 then endPosit=s.Posit+(t.Loop*t.Len)-1 end local subt={} while endPosit>=s.Posit do local cell=s:Next(t.Len) if t.Model then cell=cell:Fill(t.Model) end table.insert(subt,cell) end return subt end"
		end
		if param==0xe6 then
			strs="   _G.Hex.Fill=function(s,t) local fd={} if t.Loop then fd=s:__fillloop(t) else for i=1,#t,2 do local k=t[i] local v=t[i+1] if type(v)=='table' then if v.Loop then fd[k]=s:__fillloop(v) elseif #v==1 then fd[k]=s:Next(v[1]) elseif v.Len then local cell=s:Next(v.Len) if v.Model then cell=cell:Fill(v.Model) else cell=cell:Fill(v) end fd[k]=cell end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end"
		end
		if param==0x6d then
			strs="   _G.Hex.sFill=function(s,t) local fd={} if t.Loop then fd=s:__fillloop(t) else for k,v in pairs(t) do if type(v)=='table' then if t[k].Loop then if t[k].Loop<0 then t[k].Loop=s:Next(0-t[k].Loop):ToInt() end if t[k].Loop>0 then fd[k]=s:__fillloop(v) end else fd[k]=s:Next(v[1]) end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end"
		end
		if param==0x22 then
			strs="  _G.Context.GetCurTxAddr=function() if _G._C.CurTxAddr==nil then local addr=_G.Hex:New({_G.mylib.GetBase58Addr(_G.mylib.GetCurTxAccount())}) assert(addr:IsEmptyOrNil()==false or _G._err(0500,'GetBase58Addr'),_G._errmsg) _G._C.CurTxAddr=addr:ToString() end return _G._C.CurTxAddr end _G.Context.GetCurTxPayAmount=function() if _G._C.CurTxPayAmount==nil then local amount=_G.Hex:New({_G.mylib.GetCurTxPayAmount()}) _G._C.CurTxPayAmount=amount:ToInt() end return _G._C.CurTxPayAmount end"
		end
		if param==0xf9 then
			strs="   _G.AppData={ Read=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}) end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0500,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0500,'DeleteData'),_G._errmsg) end}"
			if mylib.ReadDataTable then			
			strs="   _G.AppData={ Read=function(key) return _G.Hex:New(_G.mylib.ReadData(key)) end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0500,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0500,'DeleteData'),_G._errmsg) end}"
			end
		end
		if param==0x5b then
			strs="   _G.Asset.AddAppAsset=function(toAddr,money) if type(toAddr)=='string' then toAddr=_G.Hex:New(toAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0105,'add'),_G._errmsg) local tb={operatorType=1, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0500,'WriteOutAppOperate'),_G._errmsg) return true end"
		end
		if param==0x9d then
			strs="   _G.Asset.SubAppAsset=function(fromAddr,money) if type(fromAddr)=='string' then fromAddr=_G.Hex:New(fromAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0105,'sub'),_G._errmsg) local tb={operatorType=2, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0500,'WriteOutApp'),_G._errmsg) return true end"
		end				
		if param==0x49 then
			strs="   _G.Asset.FromToAppAsset=function(fA,tA,m) if type(fA)=='string' then fA=_G.Hex:New(fA) end if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end local tb={ operatorType=2, outHeight=0, moneyTbl=m, userIdLen=#fA, userIdTbl=fA, fundTagLen=0, fundTagTbl={} } assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) tb.operatorType=1 tb.userIdLen=#tA tb.userIdTbl=tA assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) return true end"
			end
		if param==0xf4 then
			strs="   _G.Asset.SendAppAsset=function(fAddr,tA,m) if type(fAddr)=='string' then fAddr=_G.Hex:New(fAddr) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end assert(m:ToInt()>0 and _G.Asset.GetAppAsset(fAddr)>=m:ToInt(),_G._errmsg) _G.Asset.FromToAppAsset(fAddr,tA,m) end _G.Asset.GetAppAsset=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end local mtb=_G.Hex:New({_G.mylib.GetUserAppAccValue({idLen=#addr,idValueTbl=addr})}) return mtb:ToInt() end"
		end		
		if param==0xb1 then
			strs="   _G.GetNetAsset = function(addr) if type(addr) == 'string' then addr = _G.Hex:New(addr) end assert(#addr == 34 or #addr == 6 or _G._err(0100,addr,#addr),_G._errmsg) local mtb = _G.Hex:New({_G.mylib.QueryAccountBalance(Unpack(addr))}) assert(#mtb > 0 or _G._err(0500,'QueryAccountBalance'),_G._errmsg) return mtb:ToInt() end if _G.Asset then _G.Asset.GetNetAsset=_G.GetNetAsset end"
		end
		if param==0x01 then
			strs="   _G.SendNetAsset=function(tA,m) if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end local tb={ addrType=(#tA==6 and 1) or 2, accountIdTbl=tA, operatorType=1, outHeight=0, moneyTbl=m} assert(_G.mylib.WriteOutput(tb),_G._errmsg) tb.addrType=1 tb.operatorType=2 tb.accountIdTbl={_G.mylib.GetContractRegId()} assert(m:ToInt()<=_G.GetNetAsset(tb.accountIdTbl),_G._errmsg) assert(_G.mylib.WriteOutput(tb),_G._errmsg) return true end"
		end
		if param==0xb3 then
			strs="  T2S=function(m) local p='[Tab#'..#m..':]{' for i=1,#m do if i~=1 then p=p..',' end y=type(m[i]) k=m[i] if y=='string' then k='\"'..m[i]..'\"' end if y=='table' then k=T2S(m[i]) end p=p..k end p=p..'}' return p end Log=function(m) t=type(m) if t=='table' then m=T2S(m) end if t=='nil' then m='nil' end if t=='boolean' then m=(m and 'true') or 'false' end m=''..m local c=contract if c[#c]==0xf0 then print(m) if c[#c-1]==0 then error(m) end else _G.mylib.LogPrint({key=0,length=#m,value=m}) end end"
		end
		for i=1,#strs do
			a[i]=string.byte(strs,i)
		end
		a[1]=0x20
		return Unpack(a)
	end
--[[ mylib = require "mylib"
----正式合约中需要上面那行开始，包含下面的模块加载内容--------------------------------------------
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
	if loadstring then loadstring(c)()
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
Log = function(msg)		--当加载MK_G_Log模块后可不要此Log函数
	if contract[#contract]==0xf0 then error(msg) else print(msg) end
end
addMKcode(MK_G_C_InitMain)
addMKcode(MK_G_Hex_New)
addMKcode(MK_G_Hex_Next)
addMKcode(MK_G_Hex_ToInt)
addMKcode(MK_G_Hex_Fill)
addMKcode(MK_G_C_GetCurTx)
addMKcode(MK_G_AppData)
addMKcode(MK_G_Asset_AddAppAsset)
addMKcode(MK_G_Asset_SubAppAsset)
addMKcode(MK_G_Asset_FromToAppAsset)
addMKcode(MK_G_Asset_SendAppAsset)
addMKcode(MK_G_GetNetAsset)
addMKcode(MK_G_SendNetAsset)
addMKcode(MK_G_Log)
---------从这行开始下面为自己的Lua智能合约内容，若有必要可选择加载模块
_G.MyWiccContract={
	Init=function()
	_G.Context.Event[0xf0]=_G.MyWiccContract
	_G.MyWiccContract[0x07]=_G.MyWiccContract.Myfun
	end,
Myfun=function()
	Log(" Hello World ".._G._C.GetCurTxAddr())
end,
}
function Main()
	_G.Context.Init(_G.MyWiccContract)
	_G.Context.Main()
end
contract={0xf0,0x07}--调用:魔法数 函数 保留位 参数 正式合约不能有此行
--具体可后加,0x00,0xf0调试， 生成可见https://wicc123.com/hy 
Main()
--]]
return mylib
