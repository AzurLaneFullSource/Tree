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
	arg0_3.nowTime = nil
	arg0_3.endTime = nil

	UpdateBeat:AddListener(arg0_3.handle)
end

function var0_0.Play(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4:CheckCpkAndSubtitle(arg1_4, next) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("资源不存在"))

		return
	end

	arg0_4.captionsColor = arg2_4
	arg0_4.onExit = arg3_4

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
	onToggle(arg0_8, arg0_8.loop, function(arg0_12)
		getProxy(CryptolaliaProxy):SetLoop(arg0_12)
		setActive(arg0_8.loopOn, arg0_12)
		setActive(arg0_8.loopOff, not arg0_12)
	end)
	triggerToggle(arg0_8.loop, getProxy(CryptolaliaProxy):GetLoop())
end

function var0_0._Play(arg0_13)
	if arg0_13.state == var3_0 then
		arg0_13.player:Pause(false)
	elseif arg0_13.state == var4_0 then
		arg0_13.subtile = Clone(arg0_13.subtileBackUp)

		if arg0_13.targetFrame then
			arg0_13.player.player:SetSeekPosition(arg0_13.targetFrame)
		else
			arg0_13.player.player:SetSeekPosition(0)
		end

		arg0_13.player.player:Start()
	else
		arg0_13.subtile = Clone(arg0_13.subtileBackUp)

		arg0_13.player:PlayCpk()
	end

	setActive(arg0_13.playBtn, false)
	setActive(arg0_13.backBtn, false)
	setActive(arg0_13.bottom, false)

	arg0_13.state = var2_0
end

local function var8_0(arg0_14)
	if not arg0_14.frameInfo then
		return 0
	end

	local var0_14 = arg0_14.frameInfo

	return var0_14.frameNo / var0_14.framerateN / var0_14.framerateD * 1000000
end

local function var9_0(arg0_15, arg1_15)
	if not arg0_15 or #arg0_15 <= 0 then
		return ""
	end

	local var0_15 = arg0_15[1]

	if arg1_15 >= var0_15.startTime and arg1_15 <= var0_15.endTime then
		table.remove(arg0_15, 1)

		return var0_15.content, var0_15.endTime
	elseif arg1_15 > var0_15.startTime and arg1_15 > var0_15.endTime then
		table.remove(arg0_15, 1)
	end

	return ""
end

local function var10_0(arg0_16, arg1_16)
	if not arg0_16 or #arg0_16 <= 0 then
		return ""
	end

	while #arg0_16 > 0 do
		local var0_16 = arg0_16[1]

		if arg1_16 < var0_16.startTime then
			return ""
		elseif arg1_16 >= var0_16.startTime and arg1_16 <= var0_16.endTime then
			table.remove(arg0_16, 1)

			return var0_16.content, var0_16.endTime
		elseif arg1_16 > var0_16.endTime then
			table.remove(arg0_16, 1)
		end
	end
end

function var0_0.Pause(arg0_17)
	if arg0_17.state ~= var2_0 then
		return
	end

	arg0_17.state = var3_0

	setActive(arg0_17.playBtn, true)
	arg0_17.player:Pause(true)
	setActive(arg0_17.backBtn, true)
	setActive(arg0_17.bottom, true)

	local var0_17 = var8_0(arg0_17.player.player)
	local var1_17 = math.ceil(var0_17)

	setText(arg0_17.nowTime, math.floor(var1_17 / 60) .. ":" .. string.format("%02d", var1_17 % 60))

	local var2_17 = arg0_17.progress:GetComponent(typeof(Slider))

	var2_17.onValueChanged:RemoveAllListeners()

	var2_17.value = var1_17 / arg0_17.totalTime

	var2_17.onValueChanged:AddListener(function(arg0_18)
		if arg0_17.state ~= var4_0 then
			arg0_17.state = var4_0
			arg0_17.totalFrames = arg0_17.player.player.movieInfo.totalFrames
		end

		arg0_17.player.player:StopForSeek()

		arg0_17.targetFrame = math.floor(arg0_18 * arg0_17.totalFrames)

		if arg0_17.targetFrame == arg0_17.totalFrames then
			arg0_17.targetFrame = arg0_17.totalFrames - 10
		end

		local var0_18 = arg0_17.totalTime * arg0_18

		setText(arg0_17.nowTime, math.floor(var0_18 / 60) .. ":" .. string.format("%02d", var0_18 % 60))

		arg0_17.subtile = Clone(arg0_17.subtileBackUp)

		local var1_18, var2_18 = var10_0(arg0_17.subtile, var0_18)

		local function var3_18()
			arg0_17.timeStamp = nil

			arg0_17.player.player:SetSeekPosition(arg0_17.targetFrame)
			arg0_17.player.player:Start()

			arg0_17.hasStopped = false

			if var1_18 and var1_18 ~= "" then
				arg0_17.hideTime = var2_18
				arg0_17.text.text = "<color=" .. arg0_17.captionsColor .. ">" .. var1_18 .. "</color>"

				setActive(arg0_17.text.gameObject, true)
			else
				arg0_17.hideTime = nil
				arg0_17.text.text = ""

				setActive(arg0_17.text.gameObject, false)
			end
		end

		arg0_17:RemoveTimer()
		arg0_17:StartTimer(var3_18, 0.5)
	end)
end

function var0_0.Stop(arg0_20)
	arg0_20:Dispose()

	arg0_20.state = var5_0
end

function var0_0.CheckCpkAndSubtitle(arg0_21, arg1_21, arg2_21)
	return PathMgr.FileExists(var7_0(arg1_21)) and PathMgr.FileExists(var6_0(arg1_21))
end

function var0_0.DownloadCpkAndSubtitle(arg0_22, arg1_22, arg2_22)
	arg2_22()
end

local function var11_0(arg0_23)
	local var0_23 = var6_0(arg0_23)
	local var1_23 = PathMgr.ReadAllLines(var0_23)
	local var2_23 = {}

	for iter0_23 = 1, var1_23.Length do
		local var3_23 = var1_23[iter0_23 - 1]
		local var4_23 = string.match(var3_23, "#%d+#%d+$")
		local var5_23 = string.split(var4_23, "#")
		local var6_23 = var5_23[2]
		local var7_23 = var5_23[3]
		local var8_23 = string.gsub(var3_23, var4_23, "")

		table.insert(var2_23, {
			startTime = tonumber(var6_23),
			endTime = tonumber(var7_23),
			content = var8_23
		})
	end

	return var2_23
end

function var0_0.LoadVedioPlayer(arg0_24, arg1_24, arg2_24)
	ResourceMgr.Inst:getAssetAsync("Cryptolalia/" .. arg1_24, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_25)
		local var0_25 = Object.Instantiate(arg0_25, arg0_24.root)

		arg0_24.text = var0_25.transform:Find("Text"):GetComponent(typeof(Text))
		arg0_24.subtileBackUp = var11_0(arg1_24)
		arg0_24.player = var0_25.transform:Find("cpk"):GetComponent(typeof(CriManaCpkUI))
		arg0_24.playBtn = var0_25.transform:Find("play")
		arg0_24.backBtn = var0_25.transform:Find("back")
		arg0_24.bottom = var0_25.transform:Find("bottom")
		arg0_24.nowTime = var0_25.transform:Find("bottom/nowTime")
		arg0_24.endTime = var0_25.transform:Find("bottom/endTime")
		arg0_24.progress = var0_25.transform:Find("bottom/progress")
		arg0_24.loop = var0_25.transform:Find("bottom/loop")
		arg0_24.loopOff = var0_25.transform:Find("bottom/loop/off")
		arg0_24.loopOn = var0_25.transform:Find("bottom/loop/on")
		arg0_24._go = var0_25

		arg0_24.player:SetCpkTotalTimeCallback(function(arg0_26)
			arg0_24.totalTime = math.ceil(arg0_26)

			setText(arg0_24.endTime, math.floor(arg0_24.totalTime / 60) .. ":" .. string.format("%02d", arg0_24.totalTime % 60))
		end)
		arg0_24:_Play()
		arg2_24()
	end), true, true)
end

function var0_0.OnPlayEnd(arg0_27)
	if getProxy(CryptolaliaProxy):GetLoop() then
		arg0_27.player.player:Stop()

		arg0_27.subtile = Clone(arg0_27.subtileBackUp)

		arg0_27.player.player:SetSeekPosition(0)
		arg0_27.player:PlayCpk()
	else
		triggerButton(arg0_27.backBtn)
	end
end

function var0_0.Update(arg0_28)
	if arg0_28.text == nil or arg0_28.subtile == nil or arg0_28.player == nil or arg0_28.player.player.frameInfo == nil then
		return
	end

	if arg0_28.state == var4_0 and arg0_28.player.player.frameInfo.frameNo == arg0_28.targetFrame and not arg0_28.hasStopped then
		arg0_28.hasStopped = true

		arg0_28.player.player:StopForSeek()
	end

	if arg0_28.state == var3_0 or arg0_28.state == var4_0 then
		return
	end

	if arg0_28.player.player.frameInfo.frameNo >= arg0_28.player.player.movieInfo.totalFrames - 1 then
		arg0_28:OnPlayEnd()

		return
	end

	local var0_28 = var8_0(arg0_28.player.player)
	local var1_28, var2_28 = var9_0(arg0_28.subtile, var0_28)

	if var1_28 and var1_28 ~= "" then
		arg0_28.hideTime = var2_28
		arg0_28.text.text = "<color=" .. arg0_28.captionsColor .. ">" .. var1_28 .. "</color>"

		setActive(arg0_28.text.gameObject, true)
	elseif arg0_28.hideTime and var0_28 >= arg0_28.hideTime then
		arg0_28.text.text = ""
		arg0_28.hideTime = nil

		setActive(arg0_28.text.gameObject, false)
	end
end

function var0_0.Dispose(arg0_29)
	if arg0_29.state == var5_0 then
		return
	end

	pg.DelegateInfo.Dispose(arg0_29)

	if arg0_29.player then
		arg0_29.player:SetPlayEndHandler(nil)
		arg0_29.player.player:Stop()
	end

	if arg0_29.player and not IsNil(arg0_29.player.gameObject) then
		Object.Destroy(arg0_29.player.gameObject.transform.parent.gameObject)
	end

	arg0_29.onExit = nil
	arg0_29.text = nil
	arg0_29.nowTime = nil
	arg0_29.endTime = nil
	arg0_29.subtile = nil
	arg0_29.player = nil
	arg0_29.hideTime = nil

	if arg0_29.handle then
		UpdateBeat:RemoveListener(arg0_29.handle)
	end
end

function var0_0.StartTimer(arg0_30, arg1_30, arg2_30)
	arg0_30.timer = Timer.New(arg1_30, arg2_30, 1)

	arg0_30.timer:Start()
end

function var0_0.RemoveTimer(arg0_31)
	if arg0_31.timer then
		arg0_31.timer:Stop()
	end
end

return var0_0
