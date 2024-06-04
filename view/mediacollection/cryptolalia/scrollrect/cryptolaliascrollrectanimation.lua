local var0 = class("CryptolaliaScrollRectAnimation")

function var0.Ctor(arg0, arg1)
	arg0._tf = arg1
	arg0.isInit = false
end

function var0.Init(arg0)
	arg0.animation = arg0._tf:GetComponent(typeof(Animation))
	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))

	arg0.dftAniEvent:SetTriggerEvent(function()
		if arg0.onTrigger then
			arg0.onTrigger()
		end

		arg0.onTrigger = nil
	end)
	arg0.dftAniEvent:SetEndEvent(function()
		if arg0.callback then
			arg0.callback()
		end
	end)

	arg0.subAnim = arg0._tf:Find("Main/anim")
	arg0.subAnimation = arg0.subAnim:GetComponent(typeof(Animation))
	arg0.subDftAniEvent = arg0.subAnim:GetComponent(typeof(DftAniEvent))

	arg0.subDftAniEvent:SetStartEvent(function()
		arg0.playing = true
	end)
	arg0.subDftAniEvent:SetEndEvent(function()
		arg0.playing = false

		if arg0.onLastUpdate then
			arg0.onLastUpdate()

			arg0.onLastUpdate = nil
		end
	end)

	arg0.playing = false

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)

	arg0.isInit = true
end

function var0.Update(arg0)
	if arg0.playing and arg0.onUpdate then
		local var0 = arg0:Evaluate()

		arg0.onUpdate(var0)
	elseif not arg0.playing and arg0.onUpdate then
		arg0.onUpdate = nil
	end
end

function var0.Play(arg0, arg1)
	if not arg0.isInit then
		arg0:Init()
	end

	arg0:Stop()
	arg0.animation:Play("anim_Cryptolalia_change")

	local var0 = arg1 <= 0 and "anim_Cryptolalia_listup" or "anim_Cryptolalia_listdown"

	arg0.subAnimation:Play(var0)

	return var0
end

function var0.OnUpdate(arg0, arg1)
	arg0.onUpdate = arg1

	return var0
end

function var0.OnLastUpdate(arg0, arg1)
	arg0.onLastUpdate = arg1

	return var0
end

function var0.OnTrigger(arg0, arg1)
	arg0.onTrigger = arg1

	return var0
end

function var0.OnComplete(arg0, arg1)
	arg0.callback = arg1

	return var0
end

function var0.Evaluate(arg0)
	return arg0.subAnim.localPosition
end

function var0.Stop(arg0)
	arg0.playing = false

	arg0.animation:Stop()
	arg0.subAnimation:Stop()
end

function var0.Dispose(arg0)
	arg0.dftAniEvent:SetTriggerEvent(nil)
	arg0.dftAniEvent:SetEndEvent(nil)
	arg0.subDftAniEvent:SetStartEvent(nil)
	arg0.subDftAniEvent:SetEndEvent(nil)

	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

return var0
