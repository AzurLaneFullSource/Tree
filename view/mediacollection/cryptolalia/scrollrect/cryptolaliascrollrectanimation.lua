local var0_0 = class("CryptolaliaScrollRectAnimation")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._tf = arg1_1
	arg0_1.isInit = false
end

function var0_0.Init(arg0_2)
	arg0_2.animation = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.dftAniEvent:SetTriggerEvent(function()
		if arg0_2.onTrigger then
			arg0_2.onTrigger()
		end

		arg0_2.onTrigger = nil
	end)
	arg0_2.dftAniEvent:SetEndEvent(function()
		if arg0_2.callback then
			arg0_2.callback()
		end
	end)

	arg0_2.subAnim = arg0_2._tf:Find("Main/anim")
	arg0_2.subAnimation = arg0_2.subAnim:GetComponent(typeof(Animation))
	arg0_2.subDftAniEvent = arg0_2.subAnim:GetComponent(typeof(DftAniEvent))

	arg0_2.subDftAniEvent:SetStartEvent(function()
		arg0_2.playing = true
	end)
	arg0_2.subDftAniEvent:SetEndEvent(function()
		arg0_2.playing = false

		if arg0_2.onLastUpdate then
			arg0_2.onLastUpdate()

			arg0_2.onLastUpdate = nil
		end
	end)

	arg0_2.playing = false

	if not arg0_2.handle then
		arg0_2.handle = UpdateBeat:CreateListener(arg0_2.Update, arg0_2)
	end

	UpdateBeat:AddListener(arg0_2.handle)

	arg0_2.isInit = true
end

function var0_0.Update(arg0_7)
	if arg0_7.playing and arg0_7.onUpdate then
		local var0_7 = arg0_7:Evaluate()

		arg0_7.onUpdate(var0_7)
	elseif not arg0_7.playing and arg0_7.onUpdate then
		arg0_7.onUpdate = nil
	end
end

function var0_0.Play(arg0_8, arg1_8)
	if not arg0_8.isInit then
		arg0_8:Init()
	end

	arg0_8:Stop()
	arg0_8.animation:Play("anim_Cryptolalia_change")

	local var0_8 = arg1_8 <= 0 and "anim_Cryptolalia_listup" or "anim_Cryptolalia_listdown"

	arg0_8.subAnimation:Play(var0_8)

	return var0_0
end

function var0_0.OnUpdate(arg0_9, arg1_9)
	arg0_9.onUpdate = arg1_9

	return var0_0
end

function var0_0.OnLastUpdate(arg0_10, arg1_10)
	arg0_10.onLastUpdate = arg1_10

	return var0_0
end

function var0_0.OnTrigger(arg0_11, arg1_11)
	arg0_11.onTrigger = arg1_11

	return var0_0
end

function var0_0.OnComplete(arg0_12, arg1_12)
	arg0_12.callback = arg1_12

	return var0_0
end

function var0_0.Evaluate(arg0_13)
	return arg0_13.subAnim.localPosition
end

function var0_0.Stop(arg0_14)
	arg0_14.playing = false

	arg0_14.animation:Stop()
	arg0_14.subAnimation:Stop()
end

function var0_0.Dispose(arg0_15)
	arg0_15.dftAniEvent:SetTriggerEvent(nil)
	arg0_15.dftAniEvent:SetEndEvent(nil)
	arg0_15.subDftAniEvent:SetStartEvent(nil)
	arg0_15.subDftAniEvent:SetEndEvent(nil)

	if arg0_15.handle then
		UpdateBeat:RemoveListener(arg0_15.handle)
	end
end

return var0_0
