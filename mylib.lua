mylib = {}
		-- Form https://wicc123.com/mylib  代码后面有使用说明见：https://wicc123.com/lua
		-- Use https://github.com/GitHubbard/wicc-contract-ext-lua/blob/master/context.lua
	mylib.constant = "cndx MyLib v3.0.0"
	GetCurTxAccount="wcNx9o2RnDpSjpwvdLzWy2t1DJFhqLazxL"	--调用合约的用户地址	_G._C.GetCurTxAddr()
	GetCurTxPayAmount=100012222					--调用合约时向其转入WICC额  _G._C.GetCurTxPayAmount()
	AssetGetNetAsset=21000033330006			--指定地址中WICC币可用余额  _G.NetAssetGet(address)
	AssetGetAppAsset=33000022220000			--指定地址中代币可用余额   _G.Asset.GetAppAsset(address)	
	ReadnilData="needVote,pColorB,pStateB"			--将变量名称放在这，则读取数据时为空
	ReadDataconfig="config,sets,symbol"			--变量名称放在，读取数据时第一次为空，第二次则非空
	mylib.ReadDataTable=true				--若设为false需要下方的mylib.ReadData的返回时不加{}
	
	function mylib.ReadData(param)
		print("ReadData form param: " , param)
		if param=="mykeys" then				--特定key返回读取下面数据		_G.AppData.Read(key)
			local readstr="myvalue"
			local readstrTbl = {string.byte(readstr,1,string.len(readstr))}
			return readstrTbl
		elseif string.sub(param,1,4)=="pTxt" then			--特定key返回读取下面数据
			return {0x7C,0x3E,0x7C,0x3E,0x7C,0x3E,0x7C,0x3E}
		elseif param=="allWicc" then			--特定key返回读取下面数据
			return {0x02,0x00,0x00,0x00}
		elseif param=="allPic" then				--特定key返回读取下面数据
			return {0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00}
		elseif string.sub(param,1,8)=="needVote" then	--特定key返回读取下面数据
			return {0x02,0x03,0x01,0x02,0x01}
		elseif string.find(ReadnilData,param) then
			return nil
		elseif string.find(ReadDataconfig,param) then
			rtnconfig=cfg
			cfg={0x50,0x49,0x43}
			return rtnconfig
		elseif param=="name" then			--特定key返回读取下面数据
			return {0x61,0x62,0x63}
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
	function mylib.GetTxConFirmHeight(param)
		return 123
	end
	function mylib.GetBlockHash(param)
		hash="0bd17380096fb05b08b76b272fd3115fdb6d7a8f607e94aed3aadb5ec7904cf4"
		bh={}
		for i=1,32 do
			bh[i]=tonumber(string.sub(hash,2*i-1,2*i),16)
		end
		return Unpack(bh)
	end
	function mylib.GetCurTxHash(param)
		hash="b563d086145c43d4946ca193189b73492dc4332f04931b20f035aa62ba22f352"
		bh={}
		for i=1,32 do
			bh[i]=tonumber(string.sub(hash,2*i-1,2*i),16)
		end
		return Unpack(bh)
	end
	
	function mylib.GetTxContract(param)
		a={}
		print(string.format("MK add   %02X",param))
		if param==0xc1 or param==0x83 then
			strs="  _G.Context={ Event={}, Init=function(...) assert(contract or _G._err(0000,CallFunc),_G._errmsg) for k,v in pairs({ ... }) do if v.Init~=nil then v.Init() end end end, LoadContract=function() if #contract>0 then CallDomain=contract[1] CallFunc=contract[2] end end, Main=function() _G._C=_G.Context _G._C.LoadContract() if _G._C.Event[CallDomain] and _G._C.Event[CallDomain][CallFunc] then _G._C.Event[CallDomain][CallFunc]() else assert(_G._err(0404,CallFunc),_G._errmsg) end end}"
		end
		if param==0x1d or param==0xdc then
			strs="  Log=function(m) t=type(m) if t=='table' then m=T2S(m) end if t=='nil' then m='nil' end if t=='boolean' then m=(m and 'true') or 'false' end m=''..m local c=contract if c[#c]==0xf0 then print(m) if c[#c-1]==0 then error(m) end else _G.mylib.LogPrint({key=0,length=#m,value=m}) end end T2S=function(m) local p='[Tab#'..#m..':]{' for i=1,#m do if i~=1 then p=p..',' end y=type(m[i]) k=m[i] if y=='string' then k='\"'..m[i]..'\"' end if y=='table' then k=T2S(m[i]) end p=p..k end p=p..'}' return p end"
		end
		if param==0xe2 or param==0x17 then
			strs="  _G.Hex={ Posit=1, New=function(s,d) local mt={} if (type(d)=='string') then for i=1,#d do table.insert(mt,string.byte(d,i)) end elseif d~=nil then mt=d end setmetatable(mt,s) s.__index=s s.__eq=_G.Hex.__eq s.__tostring=_G.Hex.ToString s.__concat=_G.Hex.__concat return mt end, Appand=function(s,t) for i=1,#t do s[#s+1]=t[i] end return s end, Embed=function(s,start,t) for i=1,#t do s[i+start-1]=t[i] end return s end, Select=function(s,start,ln) assert((#s>=start+ln-1) or _G._err(0004),_G._errmsg) local newt={} for i=1,len do newt[i]=s[start+i-1] end return _G.Hex:New(newt) end, Skip=function(s,count) local newt={} for i=1,#s do newt[i]=s[count+i] end return _G.Hex:New(newt) end, Take=function(s,ln) local newt={} for i=1,ln do newt[i]=s[i] end return _G.Hex:New(newt) end, Next=function(s,ln) local newt={} for i=1,ln do assert(#s>=s.Posit or _G._err(0004),_G._errmsg) newt[i]=s[s.Posit] s.Posit=s.Posit+1 end return _G.Hex:New(newt) end, IsEmpty=function(s) return #s==0 end, IsEmptyOrNil=function(s) return _G.next(s)==nil or #s==0 end, ToString=function(s) return string.char(Unpack(s)) end, ToHexString=function(s) local str='' for i=1,#s do str=str..string.format('%02x',s[i]) end return str end, ToInt=function(s) if #s<4 then s=s:Appand({0x00,0x00,0x00}):Take(4) elseif #s>4 and #s<8 then s=s:Appand({0x00,0x00,0x00}):Take(8) end assert(#s==4 or #s==8 or _G._err(0001,#s),_G._errmsg) return _G.mylib.ByteToInteger(Unpack(s)) end, ToUInt=function(s) local value=s:ToInt() assert(value>=0 or _G._err(0105,value),_G._errmsg) return value end, __concat=function(s,t) return s:ToString()..t end, __eq=function(s,t) if (#s~=#t) then return false end for i=#s,1,-1 do if s[i]~=t[i] then return false end end return true end}"
		end
		if param==0x81 or param==0x33 then
			strs="  _G.Hex.Fill=function(s,t) local fd={} if t.Loop then fd=s:__fillloop(t) else for i=1,#t,2 do local k=t[i] local v=t[i+1] if type(v)=='table' then if v.Loop then fd[k]=s:__fillloop(v) elseif #v==1 then fd[k]=s:Next(v[1]) elseif v.Len then local cell=s:Next(v.Len) if v.Model then cell=cell:Fill(v.Model) else cell=cell:Fill(v) end fd[k]=cell end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end _G.Hex.__fillloop=function(s,t) local endPosit=#s if t.Loop<0 then t.Loop=s:Next(math.abs(t.Loop)):ToInt() end if t.Loop>0 then endPosit=s.Posit+(t.Loop*t.Len)-1 end local subt={} while endPosit>=s.Posit do local cell=s:Next(t.Len) if t.Model then cell=cell:Fill(t.Model) end table.insert(subt,cell) end return subt end"
		end
		if param==0x44 or param==0x97 then
			strs="  _G.Hex.Fills=function(s,t) local fd={} if t.Loop then fd=s:__fillloops(t) else for k,v in pairs(t) do if type(v)=='table' then if t[k].Loop then if t[k].Loop<0 then t[k].Loop=s:Next(0-t[k].Loop):ToInt() end if t[k].Loop>0 then fd[k]=s:__fillloops(v) end else fd[k]=s:Next(v[1]) end elseif type(v)=='string' then fd[k]=s:Next(tonumber(v)):ToString() elseif type(v)=='number' then fd[k]=s:Next(v):ToInt() end end end return fd end _G.Hex.__fillloops=function(s,t) local endPosit=#s if t.Loop<0 then t.Loop=s:Next(math.abs(t.Loop)):ToInt() end if t.Loop>0 then endPosit=s.Posit+(t.Loop*t.Len)-1 end local subt={} while endPosit>=s.Posit do local cell=s:Next(t.Len) if t.Model then cell=cell:Fills(t.Model) end table.insert(subt,cell) end return subt end"
		end
		if param==0x2a or param==0x3b then
			--strs="  Random=function(m,k) local r=m local txh=_G.AppData.Read('txhash') if not _G.Hex.IsEmptyOrNil(txh) then local height=_G.mylib.GetTxConFirmHeight(Unpack(txh)) if height~=nil then local hash={_G.mylib.GetBlockHash(math.floor(height))} if not _G.Hex.IsEmptyOrNil(hash) then if k==nil then k=1 else k=k% 33 end if m<=256 then r=hash[k]%m if m==16 or m==8 or m==4 or m==2 then r=math.floor(hash[k]/16)%m else if m~=256 and m~=128 and m~=64 then t=1 for i=1,32 do hs=hash[i] if m<16 then hs=math.floor(hash[i]/16) end if hsk then r=hs break end end end end end end end end end if r~=m then _G.AppData.Delete('txhashlock') end return r end SetRandom=function() local lock=_G.AppData.Read('txhashlock') if _G.Hex.IsEmptyOrNil(lock) then _G.AppData.Write('txhashlock',{0x01}) _G.AppData.Write('txhash',{_G.mylib.GetCurTxHash()}) end end"
                strs='  Random=function(m,k) local r=m local txh=_G.AppData.Read("txhash") if not _G.Hex.IsEmptyOrNil(txh) then local height=_G.mylib.GetTxConFirmHeight(Unpack(txh)) if height~=nil then local hash={_G.mylib.GetBlockHash(math.floor(height))} if not _G.Hex.IsEmptyOrNil(hash) then if k==nil then k=1 else k=k% 33 end if m<=256 then r=hash[k]%m if m==16 or m==8 or m==4 or m==2 then r=math.floor(hash[k]/16)%m else if m~=256 and m~=128 and m~=64 then t=1 for i=1,32 do hs=hash[i] if m<16 then hs=math.floor(hash[i]/16) end if hs<m then t=t+1 if t>k then r=hs break end end end end end end end end end if r~=m then _G.AppData.Delete("txhashlock") end return r end SetRandom=function() local lock=_G.AppData.Read("txhashlock") if _G.Hex.IsEmptyOrNil(lock) then _G.AppData.Write("txhashlock",{0x01}) _G.AppData.Write("txhash",{_G.mylib.GetCurTxHash()}) end end'		
				strs="  Random=function(m,k) local r=m local txh=_G.AppData.Read('txhash') if not _G.Hex.IsEmptyOrNil(txh) then local height=_G.mylib.GetTxConFirmHeight(Unpack(txh)) if height~=nil then local hash={_G.mylib.GetBlockHash(math.floor(height))} if not _G.Hex.IsEmptyOrNil(hash) then if k==nil then k=1 else k=k% 33 end if m<=256 then r=hash[k]%m if m==16 or m==8 or m==4 or m==2 then r=math.floor(hash[k]/16)%m else if m~=256 and m~=128 and m~=64 then t=1 for i=1,32 do hs=hash[i] if m<16 then hs=math.floor(hash[i]/16) end if hs < m then t=t+1 if k < t then r=hs break end end end end end end end end end if r~=m then _G.AppData.Delete('txhashlock') end return r end SetRandom=function() local lock=_G.AppData.Read('txhashlock') if _G.Hex.IsEmptyOrNil(lock) then _G.AppData.Write('txhashlock',{0x01}) _G.AppData.Write('txhash',{_G.mylib.GetCurTxHash()}) end end"
		end
		if param==0xb3 or param==0xb9 then
			strs="  _G.NetAssetGet=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end if type(addr)=='nil' then addr={_G.mylib.GetContractRegId()} end assert(#addr==34 or #addr==6 or _G._err(0100,addr,#addr),_G._errmsg) local mtb=_G.Hex:New({_G.mylib.QueryAccountBalance(Unpack(addr))}) assert(#mtb>0 or _G._err(0500,'QueryAccountBalance'),_G._errmsg) return mtb:ToInt() end _G.NetAssetSend=function(tA,m) if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end local tb={ addrType=(#tA==6 and 1) or 2, accountIdTbl=tA, operatorType=1, outHeight=0, moneyTbl=m} assert(_G.mylib.WriteOutput(tb),_G._errmsg) tb.addrType=1 tb.operatorType=2 tb.accountIdTbl={_G.mylib.GetContractRegId()} assert(m:ToInt()<=_G.GetNetAsset(tb.accountIdTbl),_G._errmsg) assert(_G.mylib.WriteOutput(tb),_G._errmsg) return true end if _G.Asset then _G.Asset.GetNetAsset=_G.NetAssetGet _G.Asset.SendSelfNetAsset=_G.NetAssetSend end"
		end
		if param==0x5b or param==0xa6 then
			strs="  _G.AppData={ ReadSafe=function(key) local value={_G.mylib.ReadData(key)} if value[1]==nil then return false,nil else return true,_G.Hex:New(value) end end, Read=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}) end, ReadStr=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToString() end, ReadInt=function(key) return _G.Hex:New({_G.mylib.ReadData(key)}):ToInt() end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0503,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0504,'DeleteData'),_G._errmsg) end}"
			if mylib.ReadDataTable then			
			strs="  _G.AppData={ ReadSafe=function(key) local value=_G.mylib.ReadData(key) if value[1]==nil then return false,nil else return true,_G.Hex:New(value) end end, Read=function(key) return _G.Hex:New(_G.mylib.ReadData(key)) end, ReadStr=function(key) return _G.Hex:New(_G.mylib.ReadData(key)):ToString() end, ReadInt=function(key) return _G.Hex:New(_G.mylib.ReadData(key)):ToInt() end, Write=function(key,value) if type(value)=='string' then value=_G.Hex:New(value) elseif type(value)=='number' then value={_G.mylib.IntegerToByte8(value)} end local writeDbTbl={key=key,length=#value,value=value} assert(_G.mylib.WriteData(writeDbTbl) or _G._err(0503,'WriteAppData'),_G._errmsg) end, Delete = function(key) assert(_G.mylib.DeleteData(key) or _G._err(0504,'DeleteData'),_G._errmsg) end}"
			end
		end
		if param==0x64 or param==0x39 then
			strs="  _G.Context.GetCurTxAddr=function() if _G._C.CurTxAddr==nil then local addr=_G.Hex:New({_G.mylib.GetBase58Addr(_G.mylib.GetCurTxAccount())}) assert(addr:IsEmptyOrNil()==false or _G._err(0500,'GetCurTxAddr_Base58Addr'),_G._errmsg) _G._C.CurTxAddr=addr:ToString() end return _G._C.CurTxAddr end _G.Context.GetCurTxPayAmount=function() if _G._C.CurTxPayAmount==nil then local amount=_G.Hex:New({_G.mylib.GetCurTxPayAmount()}) assert(amount:IsEmptyOrNil()==false or _G._err(0501,'GetCurTxPayAmount'),_G._errmsg) _G._C.CurTxPayAmount=amount:ToInt() end return _G._C.CurTxPayAmount end"
		end
		if param==0x59 or param==0xa4 then
			strs=" _G.Asset={ GetAppAsset=function(addr) if type(addr)=='string' then addr=_G.Hex:New(addr) end local mtb=_G.Hex:New({_G.mylib.GetUserAppAccValue({idLen=#addr,idValueTbl=addr})}) return mtb:ToInt() end, AddAppAsset=function(toAddr,money) if type(toAddr)=='string' then toAddr=_G.Hex:New(toAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0106,'add'),_G._errmsg) local tb={operatorType=1, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0505,'WriteOutAppOperate'),_G._errmsg) return true end, SubAppAsset=function(fromAddr,money) if type(fromAddr)=='string' then fromAddr=_G.Hex:New(fromAddr) end if type(money)=='number' then money=_G.Hex:New({_G.mylib.IntegerToByte8(money)}) end assert((#toAddr==34 and money:ToInt()>0) or _G._err(0107,'sub'),_G._errmsg) local tb={operatorType=2, outHeight=0, moneyTbl=money, userIdLen=#toAddr, userIdTbl=toAddr, fundTagLen=0, fundTagTbl={}} assert(_G.mylib.WriteOutAppOperate(tb) or _G._err(0506,'WriteOutApp'),_G._errmsg) return true end, SendAppAsset=function(fA,tA,m) if type(fA)=='string' then fA=_G.Hex:New(fA) end if type(tA)=='string' then tA=_G.Hex:New(tA) end if type(m)=='number' then m=_G.Hex:New({_G.mylib.IntegerToByte8(m)}) end assert(m:ToInt()>0 and _G.Asset.GetAppAsset(fA) >= m:ToInt(),_G._errmsg) local tb={ operatorType=2, outHeight=0, moneyTbl=m, userIdLen=#fA, userIdTbl=fA, fundTagLen=0, fundTagTbl={} } assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) tb.operatorType=1 tb.userIdLen=#tA tb.userIdTbl=tA assert(_G.mylib.WriteOutAppOperate(tb),_G._errmsg) return true end}"
		end
		if param==0x8d or param==0x19 then
			strs=" _G.ERC20MK={ Config = function() local valueTbl = _G.AppData.Read(\"name\") if #valueTbl == 0 then _G.AppData.Write(\"standard\",_G.Config.standard) _G.AppData.Write(\"owner\",_G.Config.owner) _G.AppData.Write(\"name\",_G.Config.name) _G.AppData.Write(\"symbol\",_G.Config.symbol) _G.AppData.Write(\"decimals\",_G.Config.decimals) _G.AppData.Write(\"totalSupply\",_G.Config.totalSupply) _G.Asset.AddAppAsset(_G.Config.owner,_G.Config.totalSupply) else local curaddr = _G._C.GetCurTxAddr() local freeTokens=_G.Asset.GetAppAsset(curaddr) if curaddr==_G.Config.owner and #contract > 2 then contract[1]=0x20 contract[2]=0x20 _G.AppData.Write(\"name\",contract) end local info = '\"standard\":\"'.._G.Config.standard info=info..'\",\"owner\":\"'.._G.Config.owner name=string.gsub(_G.Hex.ToString(valueTbl), '\"', '') info=info..'\",\"name\":\"'..name..'\",\"symbol\":\"'.._G.Config.symbol info=info..'\",\"decimals\":\"'.._G.Config.decimals info=info..'\",\"totalSupply\":\"'..(_G.Config.totalSupply / 100000000) info=info..'\",\"freeTokens\":\"'..(freeTokens / 100000000) Log(\"Config={\"..info..'\"}') end end, Transfer = function() local valueTbl = _G.AppData.Read(\"name\") assert(#valueTbl > 0, \"Not configured\") local symbol = _G.AppData.ReadStr(\"symbol\") local curaddr = _G._C.GetCurTxAddr() tx=_G.Hex:New(contract):Fill({\"w\",4,\"addr\",\"34\",\"money\",8}) _G.Asset.SendAppAsset(curaddr,tx.addr,tx.money) local m='\",\"tokens\":\"'..tx.money/100000000 local a='\",\"freeTokens\":\"'.._G.Asset.GetAppAsset(tx.addr)..'\",\"symbol\":\"' local f='\"newTokens\":\"'.._G.Asset.GetAppAsset(curaddr)..'\",\"fmAddr\":\"' Log('Transfer={'..f..curaddr..'\",\"toAdrr\":\"'..tx.addr..m..a..symbol..'\"}') end }"
		end
		for i=1,#strs do
			a[i]=string.byte(strs,i)
		end
		a[1]=0x20
		return Unpack(a)
	end
--[[ mylib = require "mylib"
----正式合约中需要上面那行开始，包含下面的模块加载内容--------------------------------------------
--https://WiccM.com 可在这里选择模块
MK_G_Context_Init = "c1f6596af403e97e3b71993f0c11c8f12fc30c2e90f71f12f23694576a5a6edf"
MK_G_Hex = "e228a3d2506a165f37ac1e0481774836f61adfb9ef1f0f4967dc2ebacda35d8b"
MK_G_Log = "1d4eb0db31e08022b5e849b85b3e63a3e1866cd63e14bdeff98299ef9f5cb80b"
MK_G_Hex_Fill = "81221bba76a64b164b20b505bfb817a19698493ef06cd50c8c4aca35311c4ca4"
MK_G_Hex_Fills = "440ceaf88d3b79aa88d7f19991cdfda55996461d4f26ba57fc77e97e68199116"
MK_G_Random = "2a845df7edc1179c5acf6fe43d75b03dcacf584c836198190e44226940fb0a76"
MK_G_NetAsset = "b314e1c08ee6f3198eb918f7a6610baf7d1c485c8d0de3c470e1a99aee5e4241"
MK_G_AppData = "5b49520500292cb3936400f77105dbef5c98b82655c2ba90053a18497207fa29"
MK_G_GetCurTx = "642c043faa8fb931f041381b23c6591f3566fecb2f1644cfbf696df6b9de7493"
MK_G_Asset = "59f942f214534c487c64e9ce954c5fabbad3ac7715f6a908b9ad4432f66331ce"
MK_G_ERC20MK = "8de13f70dbbd7f5974e9180fe7b94a4598369a30de3481dbdd606f3dfb71f856"
--上面是正式网络，下面是测试网络
MK_G_Context_Init = "83d3fc6c1a515035a26a1af8b2471ea7822b32910655941cce9c5c4728dcc4f2"
MK_G_Hex = "174910d20ecd4d4c0b6e934308c69d93d7cb47acb0630af919034fe648586095"
MK_G_Log = "dcf1b8f055a4226e9b1a9375bf6583b3d361a743bf406fb452c4da12f11eb1d7"
MK_G_Hex_Fill = "3391270d3b92f5286570339b9a15cdb50bc6d0b274c2511aeb960fb0b59e92a5"
MK_G_Hex_Fills = "975478daf18fa7266a4e634c1afa12fc7d95b59f751fec28c09684dd9a38bff6"
MK_G_Random = "3bea95c6619ff2ab888983484c115408d644069b1c5ce4248214ec33726cb021"
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
Log = function(msg)		--当加载MK_G_Log模块后可不要此Log函数
	if contract[#contract]==0xf0 then error(msg) else print(msg) end
end
_err = function(code,...)
	_G._errmsg= string.format("{\"code\":\"%s\"}",code,...)
	return false
end
---------从这行开始下面为自己的Lua智能合约内容，若有必要可选择加载模块
_G.BicoinALL = {
	Init = function()
		_G.Context.Event[0xf0]=_G.BicoinALL
		_G.BicoinALL[0x11]=_G.ERC20MK.Config
		_G.BicoinALL[0x16]=_G.ERC20MK.Transfer
		_G.BicoinALL[0x33]=_G.BicoinALL.MyLog
	end,
MyLog = function()
	Log("Hello World!")
end
}
Main = function()
addMKcode(MK_G_Context_Init)
addMKcode(MK_G_ERC20MK)
_G.Context.Init(_G.BicoinALL)
addMKcode(MK_G_Hex)
addMKcode(MK_G_Log)
addMKcode(MK_G_Hex_Fill)
addMKcode(MK_G_Hex_Fills)
addMKcode(MK_G_Random)
addMKcode(MK_G_NetAsset)
addMKcode(MK_G_AppData)
addMKcode(MK_G_GetCurTx)
addMKcode(MK_G_Asset)
_G.Context.Main()
end
contract={0xf0,0x33,0x00,0xf0} --f03300f0
--调用:魔法数 函数 保留位 参数 正式合约不能有上面行
--具体可后加,0x00,0xf0调试， 生成可见https://wicc123.com/hy 
Main()
--]]
return mylib
