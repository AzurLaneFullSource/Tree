local var0_0 = class("MainWordView4Mellow", import("...theme_classic.view.MainWordView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.animationPlayer = arg1_1:GetComponent(typeof(Animation))
	arg0_1.dftAniEvent = arg1_1:GetComponent(typeof(DftAniEvent))
	arg0_1.cg = arg1_1:GetComponent(typeof(CanvasGroup))
end

function var0_0.StartAnimation(arg0_2, arg1_2, arg2_2)
	if arg0_2.stopChatFlag == true then
		return
	end

	if not getProxy(SettingsProxy):ShouldShipMainSceneWord() then
		arg0_2.chatTf.localScale = Vector3.zero

		return
	end

	arg0_2.cg.alpha = 1

	arg0_2.dftAniEvent:SetStartEvent(nil)
	arg0_2.dftAniEvent:SetStartEvent(function()
		arg0_2.dftAniEvent:SetStartEvent(nil)

		arg0_2.chatTf.localScale = Vector3.one
	end)
	arg0_2:AddTimer(function()
		if not arg0_2.animationPlayer then
			return
		end

		arg0_2.animationPlayer:Stop()
		arg0_2:PlayHideAnimation(arg1_2)
	end, arg1_2 + arg2_2)
	arg0_2.animationPlayer:Play("anim_newmain_chat_show")
end

function var0_0.StopAnimation(arg0_5)
	if arg0_5.animationPlayer then
		arg0_5.animationPlayer:Stop()
	end

	arg0_5:RemoveTimer()

	arg0_5.chatTf.localScale = Vector3.zero
end

function var0_0.PlayHideAnimation(arg0_6, arg1_6)
	if arg0_6.exited then
		return
	end

	if not getProxy(SettingsProxy):ShouldShipMainSceneWord() then
		arg0_6.chatTf.localScale = Vector3.zero

		return
	end

	arg0_6:AddTimer(function()
		if not arg0_6.animationPlayer then
			return
		end

		arg0_6.animationPlayer:Stop()

		arg0_6.chatTf.localScale = Vector3.zero
	end, arg1_6)
	arg0_6.animationPlayer:Play("anim_newmain_chat_hide")
end

function var0_0.AddTimer(arg0_8, arg1_8, arg2_8)
	arg0_8:RemoveTimer()

	arg0_8.timer = Timer.New(arg1_8, arg2_8, 1)

	arg0_8.timer:Start()
end

function var0_0.RemoveTimer(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end
end

function var0_0.Dispose(arg0_10)
	var0_0.super.Dispose(arg0_10)
	arg0_10:RemoveTimer()
	arg0_10.dftAniEvent:SetStartEvent(nil)
	arg0_10.dftAniEvent:SetEndEvent(nil)
end

return var0_0
