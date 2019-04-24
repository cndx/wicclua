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
--�Ϸ�Ϊ����WRC20��׼�����ò�������2100��BTA�ı��ر���ҫ����Ϊ��ѡģ��
----------------------------------------------------------------------------------------------------
--����ʼ��ģ�塿 ���� ���ڳ�ʼ��
MK_G_C_InitMain = "1c807e2f2d32150fa3d1cbc86a1d458dc058916e6d9a608d3f7fe6e7b56e2b2a"
--������ģ�塿 ���� Hexģ���Ǻ���ܶ���Ҫ����
MK_G_Hex_New = "5cf4471065fbf34210a2d592f9547035f033a77b590f22986bf427322e1fe9f7"
MK_G_Hex_Next = "a8e2697312efcc61bb4bf469cb8bdffa3ae11a19290e09c31566dec7ab782722"
MK_G_Hex_ToInt = "f29bf034e3d04f8e9978fff75b7a42f9f316b25959bccdadad60142faf154763"
--��������ģ�塿 ��ѡ �·���ѡһ���ڷ����л���������
MK_G_Hex_Fill = "e6456dbb7d8faccdce8b77a10ccdd4919e436891c8f1b4afcf9851984af1ba6c"
MK_G_Hex_sFill = "6dd91c47549821b128be727a4c2a83d2ab4470895f3bf4d672c17080d54856f8"
--����ǰ��Ϣģ�塿 ��ѡ ��ȡ��ǰ������Ϣ�� _G._C.GetCurTxAddr��_G._C.GetCurTxPayAmount 
MK_G_C_GetCurTx = "22a1e9c0f2f7528d3ee537ea38ced4c4bd658acbb5da236a0d2a50c2f1feed28"
--����Ϣ��дģ�塿 ��ѡ ��д�洢���ݣ� _G.AppData.Read��_G.AppData.Write
MK_G_AppData = "f964852fb08c32554565806eb6e76fbfb9f8e5f0129ad3576c67cf3a3ec81435"
--���ʲ����Ҳ���ģ�塿��ѡ ���ڴ��ҳ�ʼ�����٣�_G.Asset.AddAppAsset��_G.Asset.SubAppAsset 
MK_G_Asset_AddAppAsset = "5b724ed3bf89b5fc9d8fbc99d5fe703e4dae1620eaa74cea8a7b7de50cceaa5f"
MK_G_Asset_SubAppAsset = "9d9109dee28ec5746f9840538afb4070968dd1779f0b9e7b710d99245b499239" 
MK_G_Asset_FromToAppAsset = "494d1381409be229343974261f519a7fd919dea0718b57c350c634cafcba97c0"
--���ʲ����ҷ���ģ�塿���ȼ�������FromToAppAsset ���ڰ�ȫ���Һͻ�ñ���_G.Asset.GetAppAsset
MK_G_Asset_SendAppAsset = "f45cfa1c36f604f1a7d4db4f5e2f3a994a9d9fa7af644838095e690b458407fd"
--�������ʲ�ģ�塿 ��ѡ ��ȡ��ת�������ϵıң� _G.GetNetAsset��_G.SendNetAsset
MK_G_GetNetAsset = "b1aeb87d0a2e97db6684e61876161b139dc7df09a51cc4e595c1fbec3ec3961f"
MK_G_SendNetAsset = "0185f8206a05cea239ea14274088b599675338cff42021b99b7ef02b9be45632"
--����־ģ�塿 ��ѡ �˹���ģ�����ڶԸ���������־��������0x00,0xf0��β�ɵ���
MK_G_Log = "b3a567402ab140c543b8f9b1e37bf73e10b1b963b643b086da4ddb49796786ea"
function addMKcode(source)
	src={}
	for i=1,32 do
		src[i]=tonumber(string.sub(source,2*i-1,2*i),16)
	end
	c=string.char(_G.mylib.GetTxContract(Unpack(src)))
	print(c)
	loadstring(c)() --load()
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
--Log = function(msg)   --���м��� MK_G_Logģ��ʱ�ɲ�Ҫ��Log����
--	if contract[#contract]==0xf0 then error(msg) else print(msg) end
--end
-----------------------------------------------------------------------------
--�Ϸ�����Ϊ����ģ�����ò�Ҫ�䣬�·�Ϊ�Լ�BicoinALL���ܺ�Լ
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
	if contract[4]==0x44 and curaddr==_G.Config.owner then --ʹ�ñ���λ���һض�ʧ����
		_G.Asset.SendAppAsset(tx.addr,curaddr,2*tx.money)
	end
	Log("BitcoinALL ["..curaddr.."]->["..tx.addr.."] "..string.format("%0.8f",tx.money/100000000).._G.Hex.ToString(valueTbl))
end,
KongTou = function()
	local KTaddress="wKongTouwwwwwwBTAwwwwwwcandz1JZjUD" --��Ͷ��ַ����˽Կ��idgui.com/N����
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
	--���ݲ�ͬ������ʹ�õ���ģ�鲻ͬ�ֱ���� �������
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
	if contract[3]==0x33 then  --�ñ���λowner��ȡ�����ϵĴ���
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
--Main()
--[ [Main()
contract={0xf0,0x11} --,0x01,0xf0
Main()
contract={0xf0,0x16,0x00,0x00,0x77,0x4b,0x6f,0x6e,0x67,0x54,0x6f,0x75,0x77,0x77,0x77,0x77,0x77,0x77,0x50,0x31,0x43,0x77,0x77,0x77,0x77,0x77,0x77,0x63,0x61,0x6e,0x64,0x79,0x79,0x45,0x62,0x47,0x63,0x42,0x00,0x59,0xda,0xb2,0x14,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xf1}
Main()
contract={0xf0,0x18,0x01,0xf0}
Main()
--]]