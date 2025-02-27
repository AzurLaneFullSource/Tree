local var0_0 = class("VoiceChatLoader", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.getUIName(arg0_1)
	return "VoiceChatUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.stateTxt = arg0_2:findTF("front/label"):GetComponent(typeof(Text))
	arg0_2.stateEnTxt = arg0_2:findTF("front/label/en"):GetComponent(typeof(Text))
	arg0_2.timeTxt = arg0_2:findTF("front/label/time"):GetComponent(typeof(Text))
	arg0_2.respondBtn = arg0_2:findTF("front/btns/respond")
	arg0_2.closeBtn = arg0_2:findTF("front/btns/close_btn")
	arg0_2.optionPanel = arg0_2._tf:Find("front/options_panel")
	arg0_2.bgImg = arg0_2._tf:Find("back/bg"):GetComponent(typeof(Image))
	arg0_2.player = VoiceChatPlayer.New(arg0_2._go)
	arg0_2.state = var1_0
end

local var5_0 = {
	"",
	"JP",
	"KR",
	"US",
	""
}

function var0_0.LoadScript(arg0_3, arg1_3)
	local var0_3 = var5_0[PLATFORM_CODE]

	if arg1_3 == "index" then
		arg1_3 = arg1_3 .. var0_3
	end

	local var1_3

	if PLATFORM_CODE == PLATFORM_JP then
		var1_3 = "GameCfg.story" .. var0_3 .. "." .. arg1_3
	else
		var1_3 = "GameCfg.story" .. "." .. arg1_3
	end

	local var2_3, var3_3 = pcall(function()
		return require(var1_3)
	end)

	assert(var3_3, "load script failed:" .. arg1_3)

	return VoiceChat.New(var3_3)
end

function var0_0.Play(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5:LoadScript(arg1_5)
	local var1_5 = {}

	table.insert(var1_5, function(arg0_6)
		arg0_5:WaitForRespond(var0_5, arg0_6)
	end)
	table.insert(var1_5, function(arg0_7)
		arg0_5:StartAction(var0_5)
		arg0_7()
	end)

	for iter0_5, iter1_5 in ipairs(var0_5.steps) do
		table.insert(var1_5, function(arg0_8)
			arg0_5.player:Play(var0_5, iter0_5, arg0_8)
		end)
	end

	table.insert(var1_5, function(arg0_9)
		arg0_5:WaitForHangUp(arg0_9)
	end)

	arg0_5.script = var0_5

	arg0_5:InitAction(var0_5)
	seriesAsync(var1_5, function()
		arg0_5:EndAction()

		if arg2_5 then
			arg2_5()
		end
	end)
end

function var0_0.InitAction(arg0_11, arg1_11)
	arg0_11.state = var2_0

	removeOnButton(arg0_11.respondBtn)
	removeOnButton(arg0_11.closeBtn)
	setActive(arg0_11.optionPanel, false)
	arg0_11:Show()

	local var0_11 = arg1_11:GetBgName()

	if var0_11 then
		arg0_11.bgImg.sprite = LoadSprite("bg/" .. var0_11)

		arg0_11.bgImg:SetNativeSize()
	end

	arg0_11.player:OnStart()
end

function var0_0.WaitForRespond(arg0_12, arg1_12, arg2_12)
	setActive(arg0_12.respondBtn, true)
	setActive(arg0_12.closeBtn, true)

	arg0_12.stateTxt.text = i18n("dorm3d_VIDEO_CHAT_LABEL", arg1_12:GetShipName())
	arg0_12.stateEnTxt.text = "P R I V A T E C H A T"

	onButton(arg0_12, arg0_12.respondBtn, arg2_12, SFX_PANEL)
	onButton(arg0_12, arg0_12.closeBtn, function()
		arg0_12:Stop()
	end, SFX_PANEL)
end

local function var6_0(arg0_14)
	local var0_14 = math.floor(arg0_14 / 60)
	local var1_14 = arg0_14 % 60

	return string.format("%02d:%02d", var0_14, var1_14)
end

function var0_0.StartAction(arg0_15, arg1_15)
	arg0_15.state = var3_0
	arg0_15.stateEnTxt.text = "V I D E O  I N V I T E"

	local var0_15 = 0

	arg0_15:AddTimer(1, function()
		var0_15 = var0_15 + 1
		arg0_15.timeTxt.text = var6_0(var0_15)
	end)
	setActive(arg0_15.respondBtn, false)
end

function var0_0.WaitForHangUp(arg0_17, arg1_17)
	arg0_17:RemoveTimer()

	arg0_17.timeTxt.text = ""

	arg0_17:AddWaitTimer(2, arg1_17)
end

function var0_0.EndAction(arg0_18)
	arg0_18:RemoveWaitTimer()
	arg0_18:RemoveTimer()
	arg0_18:Hide()
	arg0_18.player:OnEnd()

	arg0_18.script = nil
	arg0_18.state = var4_0

	removeOnButton(arg0_18.respondBtn)
	removeOnButton(arg0_18.closeBtn)
end

function var0_0.IsRunning(arg0_19)
	return arg0_19.state == var3_0 or arg0_19.state == var2_0
end

function var0_0.Stop(arg0_20)
	if not arg0_20:IsRunning() then
		return
	end

	if arg0_20.state == var3_0 then
		arg0_20.script:MarkSkip()
		arg0_20.player:OnStop()
	elseif arg0_20.state == var2_0 then
		arg0_20:EndAction()
	end
end

function var0_0.OnDestroy(arg0_21)
	if arg0_21:isShowing() then
		arg0_21:Hide()
	end

	arg0_21:RemoveWaitTimer()
	arg0_21:RemoveTimer()
end

function var0_0.AddTimer(arg0_22, arg1_22, arg2_22)
	arg0_22:RemoveTimer()

	arg0_22.timer = Timer.New(arg2_22, arg1_22, -1)

	arg0_22.timer.func()
	arg0_22.timer:Start()
end

function var0_0.RemoveTimer(arg0_23)
	if arg0_23.timer then
		arg0_23.timer:Stop()

		arg0_23.timer = nil
	end
end

function var0_0.AddWaitTimer(arg0_24, arg1_24, arg2_24)
	arg0_24:RemoveWaitTimer()

	arg0_24.waitTimer = Timer.New(arg2_24, arg1_24, 1)

	arg0_24.waitTimer:Start()
end

function var0_0.RemoveWaitTimer(arg0_25)
	if arg0_25.waitTimer then
		arg0_25.waitTimer:Stop()

		arg0_25.waitTimer = nil
	end
end

return var0_0
