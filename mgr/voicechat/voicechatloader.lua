local var0_0 = class("VoiceChatLoader", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.getUIName(arg0_1)
	return "VoiceChatUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.stateTxt = arg0_2._tf:Find("front/label"):GetComponent(typeof(Text))
	arg0_2.stateEnTxt = arg0_2._tf:Find("front/label/en"):GetComponent(typeof(Text))
	arg0_2.timeTxt = arg0_2._tf:Find("front/label/time"):GetComponent(typeof(Text))
	arg0_2.respondBtn = arg0_2._tf:Find("front/btns/respond")
	arg0_2.closeBtn = arg0_2._tf:Find("front/btns/close_btn")
	arg0_2.optionPanel = arg0_2._tf:Find("front/options_panel")
	arg0_2.bg = arg0_2._tf:Find("back")
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
		arg0_5:WaitForRespond(var0_5, arg0_6, arg2_5)
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
	setActive(arg0_11.bg, arg1_11:HasBg())
	arg0_11:Show()

	if arg1_11:HasBg() then
		arg0_11.bgImg.sprite = LoadSprite("bg/" .. arg1_11:GetBgName())

		arg0_11.bgImg:SetNativeSize()
	end

	arg0_11.player:OnStart()
end

function var0_0.WaitForRespond(arg0_12, arg1_12, arg2_12, arg3_12)
	setActive(arg0_12.respondBtn, true)
	setActive(arg0_12.closeBtn, true)

	arg0_12.stateTxt.text = i18n(arg1_12:GetLabel(), arg1_12:GetShipName())
	arg0_12.stateEnTxt.text = "P R I V A T E C H A T"

	onButton(arg0_12, arg0_12.respondBtn, arg2_12, SFX_PANEL)
	onButton(arg0_12, arg0_12.closeBtn, function()
		arg0_12.closeBtn:GetComponent(typeof(Animation)):Play("anim_close_btn_hang")
		arg0_12.closeBtn:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			arg0_12:Stop()
			existCall(arg3_12)
		end)
	end, SFX_PANEL)
end

local function var6_0(arg0_15)
	local var0_15 = math.floor(arg0_15 / 60)
	local var1_15 = arg0_15 % 60

	return string.format("%02d:%02d", var0_15, var1_15)
end

function var0_0.StartAction(arg0_16, arg1_16)
	arg0_16.state = var3_0
	arg0_16.stateEnTxt.text = "V I D E O  I N V I T E"

	local var0_16 = 0

	arg0_16:AddTimer(1, function()
		var0_16 = var0_16 + 1
		arg0_16.timeTxt.text = var6_0(var0_16)
	end)
	setActive(arg0_16.respondBtn, false)

	if arg1_16:ShouldStopBgm() then
		pg.BgmMgr.GetInstance():StopPlay()
	end
end

function var0_0.WaitForHangUp(arg0_18, arg1_18)
	arg0_18:RemoveTimer()

	arg0_18.timeTxt.text = ""

	arg0_18:AddWaitTimer(2, arg1_18)
end

function var0_0.EndAction(arg0_19)
	arg0_19:RemoveWaitTimer()
	arg0_19:RemoveTimer()
	arg0_19:Hide()

	if arg0_19.script:ShouldStopBgm() then
		pg.BgmMgr.GetInstance():ContinuePlay()
	end

	arg0_19.player:OnEnd()

	arg0_19.script = nil
	arg0_19.state = var4_0

	removeOnButton(arg0_19.respondBtn)
	removeOnButton(arg0_19.closeBtn)
end

function var0_0.IsRunning(arg0_20)
	return arg0_20.state == var3_0 or arg0_20.state == var2_0
end

function var0_0.Stop(arg0_21)
	if not arg0_21:IsRunning() then
		return
	end

	if arg0_21.state == var3_0 then
		arg0_21.script:MarkSkip()
		arg0_21.player:OnStop()
	elseif arg0_21.state == var2_0 then
		arg0_21:EndAction()
	end
end

function var0_0.OnDestroy(arg0_22)
	if arg0_22:isShowing() then
		arg0_22:Hide()
	end

	arg0_22:RemoveWaitTimer()
	arg0_22:RemoveTimer()

	if arg0_22.player then
		arg0_22.player:Clear()
	end
end

function var0_0.AddTimer(arg0_23, arg1_23, arg2_23)
	arg0_23:RemoveTimer()

	arg0_23.timer = Timer.New(arg2_23, arg1_23, -1)

	arg0_23.timer.func()
	arg0_23.timer:Start()
end

function var0_0.RemoveTimer(arg0_24)
	if arg0_24.timer then
		arg0_24.timer:Stop()

		arg0_24.timer = nil
	end
end

function var0_0.AddWaitTimer(arg0_25, arg1_25, arg2_25)
	arg0_25:RemoveWaitTimer()

	arg0_25.waitTimer = Timer.New(arg2_25, arg1_25, 1)

	arg0_25.waitTimer:Start()
end

function var0_0.RemoveWaitTimer(arg0_26)
	if arg0_26.waitTimer then
		arg0_26.waitTimer:Stop()

		arg0_26.waitTimer = nil
	end
end

return var0_0
