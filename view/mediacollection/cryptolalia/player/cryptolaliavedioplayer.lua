local var0_0 = class("CryptolaliaVedioPlayer")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 5

local function var6_0(arg0_1)
	return PathMgr.getAssetBundle("originsource/cipher/" .. arg0_1 .. ".txt")
end

local function var7_0(arg0_2)
	return PathMgr.getAssetBundle("originsource/cipher/" .. arg0_2 .. ".cpk")
end

function var0_0.Ctor(arg0_3, arg1_3)
	pg.DelegateInfo.New(arg0_3)

	arg0_3.root = arg1_3
	arg0_3.state = var1_0

	if not arg0_3.handle then
		arg0_3.handle = UpdateBeat:CreateListener(arg0_3.Update, arg0_3)
	end

	arg0_3.text = nil
	arg0_3.subtile = nil
	arg0_3.player = nil

	UpdateBeat:AddListener(arg0_3.handle)
end

function var0_0.Play(arg0_4, arg1_4, arg2_4)
	if not arg0_4:CheckCpkAndSubtitle(arg1_4, next) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("Resource does not exist"))

		return
	end

	arg0_4.onExit = arg2_4

	seriesAsync({
		function(arg0_5)
			arg0_4:DownloadCpkAndSubtitle(arg1_4, arg0_5)
		end,
		function(arg0_6)
			arg0_4:LoadVedioPlayer(arg1_4, arg0_6)
		end
	}, function()
		arg0_4:RegisterEvent()
	end)
end

function var0_0.RegisterEvent(arg0_8)
	onButton(arg0_8, arg0_8.playBtn, function()
		if not arg0_8.player then
			return
		end

		arg0_8:_Play()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.backBtn, function()
		if not arg0_8.player then
			return
		end

		if arg0_8.onExit then
			arg0_8.onExit()
		end

		arg0_8:Stop()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._go, function()
		arg0_8:Pause()
	end, SFX_PANEL)
end

function var0_0._Play(arg0_12)
	if arg0_12.state == var3_0 then
		arg0_12.player:Pause(false)
	elseif arg0_12.state == var4_0 then
		arg0_12.subtile = Clone(arg0_12.subtileBackUp)

		arg0_12.player.player:SetSeekPosition(0)
		arg0_12.player.player:Start()
	else
		arg0_12.subtile = Clone(arg0_12.subtileBackUp)

		arg0_12.player:PlayCpk()
	end

	setActive(arg0_12.playBtn, false)
	setActive(arg0_12.backBtn, false)

	arg0_12.state = var2_0
end

function var0_0.Pause(arg0_13)
	if arg0_13.state ~= var2_0 then
		return
	end

	arg0_13.state = var3_0

	setActive(arg0_13.playBtn, true)
	arg0_13.player:Pause(true)
	setActive(arg0_13.backBtn, true)
end

function var0_0.Stop(arg0_14)
	arg0_14:Dispose()

	arg0_14.state = var5_0
end

function var0_0.CheckCpkAndSubtitle(arg0_15, arg1_15, arg2_15)
	return PathMgr.FileExists(var7_0(arg1_15)) and PathMgr.FileExists(var6_0(arg1_15))
end

function var0_0.DownloadCpkAndSubtitle(arg0_16, arg1_16, arg2_16)
	arg2_16()
end

local function var8_0(arg0_17)
	local var0_17 = var6_0(arg0_17)
	local var1_17 = PathMgr.ReadAllLines(var0_17)
	local var2_17 = {}

	for iter0_17 = 1, var1_17.Length do
		local var3_17 = var1_17[iter0_17 - 1]
		local var4_17 = string.match(var3_17, "#%d+#%d+$")
		local var5_17 = string.split(var4_17, "#")
		local var6_17 = var5_17[2]
		local var7_17 = var5_17[3]
		local var8_17 = string.gsub(var3_17, var4_17, "")

		table.insert(var2_17, {
			startTime = tonumber(var6_17),
			endTime = tonumber(var7_17),
			content = var8_17
		})
	end

	return var2_17
end

function var0_0.LoadVedioPlayer(arg0_18, arg1_18, arg2_18)
	ResourceMgr.Inst:getAssetAsync("Cryptolalia/" .. arg1_18, arg1_18, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_19)
		local var0_19 = Object.Instantiate(arg0_19, arg0_18.root)

		arg0_18.text = var0_19.transform:Find("Text"):GetComponent(typeof(Text))
		arg0_18.subtileBackUp = var8_0(arg1_18)
		arg0_18.player = var0_19.transform:Find("cpk"):GetComponent(typeof(CriManaCpkUI))
		arg0_18.playBtn = var0_19.transform:Find("play")
		arg0_18.backBtn = var0_19.transform:Find("back")
		arg0_18._go = var0_19

		arg0_18:_Play()
		arg2_18()
	end), true, true)
end

function var0_0.OnPlayEnd(arg0_20)
	arg0_20.player.player.frameInfo.frameNo = 0
	arg0_20.state = var4_0

	setActive(arg0_20.playBtn, true)
	setActive(arg0_20.backBtn, true)
end

local function var9_0(arg0_21)
	if not arg0_21.frameInfo then
		return 0
	end

	local var0_21 = arg0_21.frameInfo

	return var0_21.frameNo / var0_21.framerateN / var0_21.framerateD * 1000000
end

local function var10_0(arg0_22, arg1_22)
	if not arg0_22 or #arg0_22 <= 0 then
		return ""
	end

	local var0_22 = arg0_22[1]

	if arg1_22 >= var0_22.startTime and arg1_22 <= var0_22.endTime then
		table.remove(arg0_22, 1)

		return var0_22.content, var0_22.endTime
	elseif arg1_22 > var0_22.startTime and arg1_22 > var0_22.endTime then
		table.remove(arg0_22, 1)
	end

	return ""
end

function var0_0.Update(arg0_23)
	if arg0_23.text == nil or arg0_23.subtile == nil or arg0_23.player == nil or arg0_23.player.player.frameInfo == nil then
		return
	end

	if arg0_23.state == var3_0 or arg0_23.state == var4_0 then
		return
	end

	if arg0_23.player.player.frameInfo.frameNo >= arg0_23.player.player.movieInfo.totalFrames - 1 then
		arg0_23:OnPlayEnd()

		return
	end

	local var0_23 = var9_0(arg0_23.player.player)
	local var1_23, var2_23 = var10_0(arg0_23.subtile, var0_23)

	if var1_23 and var1_23 ~= "" then
		arg0_23.hideTime = var2_23
		arg0_23.text.text = var1_23

		setActive(arg0_23.text.gameObject, true)
	elseif arg0_23.hideTime and var0_23 >= arg0_23.hideTime then
		arg0_23.text.text = ""
		arg0_23.hideTime = nil

		setActive(arg0_23.text.gameObject, false)
	end
end

function var0_0.Dispose(arg0_24)
	if arg0_24.state == var5_0 then
		return
	end

	pg.DelegateInfo.Dispose(arg0_24)

	if arg0_24.player then
		arg0_24.player:SetPlayEndHandler(nil)
		arg0_24.player.player:Stop()
	end

	if arg0_24.player and not IsNil(arg0_24.player.gameObject) then
		Object.Destroy(arg0_24.player.gameObject.transform.parent.gameObject)
	end

	arg0_24.onExit = nil
	arg0_24.text = nil
	arg0_24.subtile = nil
	arg0_24.player = nil
	arg0_24.hideTime = nil

	if arg0_24.handle then
		UpdateBeat:RemoveListener(arg0_24.handle)
	end
end

return var0_0
