local var0 = class("MainWordView4Mellow", import("...theme_classic.view.MainWordView"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.animationPlayer = arg1:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg1:GetComponent(typeof(DftAniEvent))
	arg0.cg = arg1:GetComponent(typeof(CanvasGroup))
end

function var0.StartAnimation(arg0, arg1, arg2)
	if arg0.stopChatFlag == true then
		return
	end

	if not getProxy(SettingsProxy):ShouldShipMainSceneWord() then
		arg0.chatTf.localScale = Vector3.zero

		return
	end

	arg0.cg.alpha = 1

	arg0.dftAniEvent:SetStartEvent(nil)
	arg0.dftAniEvent:SetStartEvent(function()
		arg0.dftAniEvent:SetStartEvent(nil)

		arg0.chatTf.localScale = Vector3.one
	end)
	arg0:AddTimer(function()
		if not arg0.animationPlayer then
			return
		end

		arg0.animationPlayer:Stop()
		arg0:PlayHideAnimation(arg1)
	end, arg1 + arg2)
	arg0.animationPlayer:Play("anim_newmain_chat_show")
end

function var0.StopAnimation(arg0)
	if arg0.animationPlayer then
		arg0.animationPlayer:Stop()
	end

	arg0:RemoveTimer()

	arg0.chatTf.localScale = Vector3.zero
end

function var0.PlayHideAnimation(arg0, arg1)
	if arg0.exited then
		return
	end

	if not getProxy(SettingsProxy):ShouldShipMainSceneWord() then
		arg0.chatTf.localScale = Vector3.zero

		return
	end

	arg0:AddTimer(function()
		if not arg0.animationPlayer then
			return
		end

		arg0.animationPlayer:Stop()

		arg0.chatTf.localScale = Vector3.zero
	end, arg1)
	arg0.animationPlayer:Play("anim_newmain_chat_hide")
end

function var0.AddTimer(arg0, arg1, arg2)
	arg0:RemoveTimer()

	arg0.timer = Timer.New(arg1, arg2, 1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:RemoveTimer()
	arg0.dftAniEvent:SetStartEvent(nil)
	arg0.dftAniEvent:SetEndEvent(nil)
end

return var0
