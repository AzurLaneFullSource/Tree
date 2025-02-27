local var0_0 = class("VoiceChatPlayer", import("Mgr.Story.model.animation.StoryAnimtion"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._tf = arg1_1.transform
	arg0_1.content = arg0_1._tf:Find("front/Text"):GetComponent(typeof(Text))
	arg0_1.optionPanel = arg0_1._tf:Find("front/options_panel")
	arg0_1.optionUIList = UIItemList.New(arg0_1.optionPanel:Find("options_c"), arg0_1.optionPanel:Find("options_c/option_tpl"))
	arg0_1.closeBtn = arg0_1._tf:Find("front/btns/close_btn")
end

function var0_0.Play(arg0_2, arg1_2, arg2_2, arg3_2)
	if not arg1_2 then
		arg3_2()

		return
	end

	local var0_2 = arg1_2:GetStepByIndex(arg2_2)

	if not var0_2 then
		arg3_2()

		return
	end

	arg0_2.callback = arg3_2

	arg0_2:Reset(var0_2)
	seriesAsync({
		function(arg0_3)
			if not arg0_2:EnterPhase(var2_0) then
				return
			end

			arg0_2:PlayVoice(var0_2)
			arg0_2:ReigsetEvent(var0_2, arg0_3)
		end,
		function(arg0_4)
			if not arg0_2:EnterPhase(var3_0) then
				return
			end

			arg0_2:ClearEvent()
			arg0_2:ClearChatTimer()
			arg0_2:DelayCall(0.2, arg0_4)
		end,
		function(arg0_5)
			if not arg0_2:EnterPhase(var4_0) then
				return
			end

			arg0_2:StopVoice()
			arg0_2:InitOptionIfNeed(arg1_2, var0_2, arg0_5)
		end,
		function(arg0_6)
			if not arg0_2:EnterPhase(var5_0) then
				return
			end

			arg0_2:Clear(var0_2, arg0_6)
		end
	}, arg3_2)
end

function var0_0.EnterPhase(arg0_7, arg1_7)
	if arg1_7 - 1 ~= arg0_7.phase then
		return false
	end

	arg0_7.phase = arg1_7

	return true
end

function var0_0.Reset(arg0_8, arg1_8)
	arg0_8.phase = var1_0

	setActive(arg0_8.optionPanel, false)
	arg0_8:ClearEvent()
end

function var0_0.StopVoice(arg0_9)
	if arg0_9.currentVoice then
		arg0_9.currentVoice:Stop(true)

		arg0_9.currentVoice = nil
	end
end

function var0_0.PlayVoice(arg0_10, arg1_10)
	arg0_10:StopVoice()

	arg0_10.content.text = arg1_10:GetSay()

	local var0_10 = arg1_10:GetVoice()

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_10, function(arg0_11)
		if arg0_11 then
			arg0_10.currentVoice = arg0_11.playback
		end

		local var0_11 = arg0_11:GetLength() * 0.001
		local var1_11 = arg1_10:GetWaitForClickTime()

		assert(var1_11 < var0_11, "chatShowTime must > wait time")
		arg0_10:AddTimeTriggerNextOne(var0_11)
	end)
end

function var0_0.AddTimeTriggerNextOne(arg0_12, arg1_12)
	arg0_12.chatTimer = arg0_12:CreateDelayTimer(arg1_12, function()
		arg0_12:ClearChatTimer()
		triggerButton(arg0_12._tf)
	end)
end

function var0_0.ClearChatTimer(arg0_14)
	if arg0_14.chatTimer then
		arg0_14.chatTimer:Stop()

		arg0_14.chatTimer = nil
	end
end

function var0_0.ReigsetEvent(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15:GetWaitForClickTime()

	arg0_15:DelayCall(var0_15, function()
		onButton(arg0_15, arg0_15._tf, arg2_15, SFX_PANEL)
	end)
end

function var0_0.ClearEvent(arg0_17)
	removeOnButton(arg0_17._tf)
end

function var0_0.InitOptionIfNeed(arg0_18, arg1_18, arg2_18, arg3_18)
	setActive(arg0_18.optionPanel, arg2_18:ExistOption())

	if not arg2_18:ExistOption() then
		arg3_18()

		return
	end

	setActive(arg0_18.closeBtn, false)

	local var0_18 = arg2_18:GetOptions()

	arg0_18.optionUIList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = var0_18[arg1_19 + 1]

			arg2_19:Find("content/Text"):GetComponent(typeof(Text)).text = var0_19[1]

			onButton(arg0_18, arg2_19, function()
				arg1_18:SetBranchCode(var0_19[2])
				arg3_18(var0_19[2])
				setActive(arg0_18.closeBtn, true)
			end)
		end
	end)
	arg0_18.optionUIList:align(#var0_18)
end

function var0_0.Clear(arg0_21, arg1_21, arg2_21)
	arg0_21:ClearAnimation()
	arg0_21:StopVoice()
	setActive(arg0_21.optionPanel, false)

	arg0_21.callback = nil

	arg2_21()
end

function var0_0.OnPause(arg0_22)
	return
end

function var0_0.OnResume(arg0_23)
	return
end

function var0_0.OnStop(arg0_24)
	arg0_24:Reset()
	arg0_24:ClearAnimation()
	arg0_24:StopVoice()

	if arg0_24.callback then
		arg0_24.callback()

		arg0_24.callback = nil
	end
end

function var0_0.OnStart(arg0_25, arg1_25)
	pg.DelegateInfo.New(arg0_25)
end

function var0_0.OnEnd(arg0_26, arg1_26)
	pg.DelegateInfo.Dispose(arg0_26)
end

return var0_0
