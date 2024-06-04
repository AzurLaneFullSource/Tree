local var0 = class("CryptolaliaVedioPlayer")
local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 5

local function var6(arg0)
	return PathMgr.getAssetBundle("originsource/cipher/" .. arg0 .. ".txt")
end

local function var7(arg0)
	return PathMgr.getAssetBundle("originsource/cipher/" .. arg0 .. ".cpk")
end

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.root = arg1
	arg0.state = var1

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	arg0.text = nil
	arg0.subtile = nil
	arg0.player = nil

	UpdateBeat:AddListener(arg0.handle)
end

function var0.Play(arg0, arg1, arg2)
	if not arg0:CheckCpkAndSubtitle(arg1, next) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("Resource does not exist"))

		return
	end

	arg0.onExit = arg2

	seriesAsync({
		function(arg0)
			arg0:DownloadCpkAndSubtitle(arg1, arg0)
		end,
		function(arg0)
			arg0:LoadVedioPlayer(arg1, arg0)
		end
	}, function()
		arg0:RegisterEvent()
	end)
end

function var0.RegisterEvent(arg0)
	onButton(arg0, arg0.playBtn, function()
		if not arg0.player then
			return
		end

		arg0:_Play()
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		if not arg0.player then
			return
		end

		if arg0.onExit then
			arg0.onExit()
		end

		arg0:Stop()
	end, SFX_PANEL)
	onButton(arg0, arg0._go, function()
		arg0:Pause()
	end, SFX_PANEL)
end

function var0._Play(arg0)
	if arg0.state == var3 then
		arg0.player:Pause(false)
	elseif arg0.state == var4 then
		arg0.subtile = Clone(arg0.subtileBackUp)

		arg0.player.player:SetSeekPosition(0)
		arg0.player.player:Start()
	else
		arg0.subtile = Clone(arg0.subtileBackUp)

		arg0.player:PlayCpk()
	end

	setActive(arg0.playBtn, false)
	setActive(arg0.backBtn, false)

	arg0.state = var2
end

function var0.Pause(arg0)
	if arg0.state ~= var2 then
		return
	end

	arg0.state = var3

	setActive(arg0.playBtn, true)
	arg0.player:Pause(true)
	setActive(arg0.backBtn, true)
end

function var0.Stop(arg0)
	arg0:Dispose()

	arg0.state = var5
end

function var0.CheckCpkAndSubtitle(arg0, arg1, arg2)
	return PathMgr.FileExists(var7(arg1)) and PathMgr.FileExists(var6(arg1))
end

function var0.DownloadCpkAndSubtitle(arg0, arg1, arg2)
	arg2()
end

local function var8(arg0)
	local var0 = var6(arg0)
	local var1 = PathMgr.ReadAllLines(var0)
	local var2 = {}

	for iter0 = 1, var1.Length do
		local var3 = var1[iter0 - 1]
		local var4 = string.match(var3, "#%d+#%d+$")
		local var5 = string.split(var4, "#")
		local var6 = var5[2]
		local var7 = var5[3]
		local var8 = string.gsub(var3, var4, "")

		table.insert(var2, {
			startTime = tonumber(var6),
			endTime = tonumber(var7),
			content = var8
		})
	end

	return var2
end

function var0.LoadVedioPlayer(arg0, arg1, arg2)
	ResourceMgr.Inst:getAssetAsync("Cryptolalia/" .. arg1, arg1, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0.root)

		arg0.text = var0.transform:Find("Text"):GetComponent(typeof(Text))
		arg0.subtileBackUp = var8(arg1)
		arg0.player = var0.transform:Find("cpk"):GetComponent(typeof(CriManaCpkUI))
		arg0.playBtn = var0.transform:Find("play")
		arg0.backBtn = var0.transform:Find("back")
		arg0._go = var0

		arg0:_Play()
		arg2()
	end), true, true)
end

function var0.OnPlayEnd(arg0)
	arg0.player.player.frameInfo.frameNo = 0
	arg0.state = var4

	setActive(arg0.playBtn, true)
	setActive(arg0.backBtn, true)
end

local function var9(arg0)
	if not arg0.frameInfo then
		return 0
	end

	local var0 = arg0.frameInfo

	return var0.frameNo / var0.framerateN / var0.framerateD * 1000000
end

local function var10(arg0, arg1)
	if not arg0 or #arg0 <= 0 then
		return ""
	end

	local var0 = arg0[1]

	if arg1 >= var0.startTime and arg1 <= var0.endTime then
		table.remove(arg0, 1)

		return var0.content, var0.endTime
	elseif arg1 > var0.startTime and arg1 > var0.endTime then
		table.remove(arg0, 1)
	end

	return ""
end

function var0.Update(arg0)
	if arg0.text == nil or arg0.subtile == nil or arg0.player == nil or arg0.player.player.frameInfo == nil then
		return
	end

	if arg0.state == var3 or arg0.state == var4 then
		return
	end

	if arg0.player.player.frameInfo.frameNo >= arg0.player.player.movieInfo.totalFrames - 1 then
		arg0:OnPlayEnd()

		return
	end

	local var0 = var9(arg0.player.player)
	local var1, var2 = var10(arg0.subtile, var0)

	if var1 and var1 ~= "" then
		arg0.hideTime = var2
		arg0.text.text = var1

		setActive(arg0.text.gameObject, true)
	elseif arg0.hideTime and var0 >= arg0.hideTime then
		arg0.text.text = ""
		arg0.hideTime = nil

		setActive(arg0.text.gameObject, false)
	end
end

function var0.Dispose(arg0)
	if arg0.state == var5 then
		return
	end

	pg.DelegateInfo.Dispose(arg0)

	if arg0.player then
		arg0.player:SetPlayEndHandler(nil)
		arg0.player.player:Stop()
	end

	if arg0.player and not IsNil(arg0.player.gameObject) then
		Object.Destroy(arg0.player.gameObject.transform.parent.gameObject)
	end

	arg0.onExit = nil
	arg0.text = nil
	arg0.subtile = nil
	arg0.player = nil
	arg0.hideTime = nil

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

return var0
