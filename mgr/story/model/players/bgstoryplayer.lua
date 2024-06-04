local var0 = class("BgStoryPlayer", import(".DialogueStoryPlayer"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.subImage = arg0:findTF("sub", arg0.bgPanel):GetComponent(typeof(Image))
	arg0.bgRecord = nil
end

function var0.Reset(arg0, arg1, arg2, arg3)
	var0.super.super.Reset(arg0, arg1, arg2, arg3)
	setActive(arg0.bgPanel, true)
	setActive(arg0.subImage.gameObject, false)
	setActive(arg0.actorPanel, false)
	arg0:RecyclePainting({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	})
end

function var0.OnBgUpdate(arg0, arg1)
	local var0 = arg1:GetBgName()

	if arg0.bgRecord ~= var0 then
		arg0.bgRecord = var0

		local var1 = arg1:GetFadeSpeed()

		arg0:TweenValueForcanvasGroup(arg0.bgPanelCg, 0, 1, var1, 0, nil)
	end
end

function var0.UpdateBg(arg0, arg1)
	local var0 = arg1:GetSubBg()

	if var0 then
		setActive(arg0.subImage.gameObject, true)

		arg0.subImage.sprite = arg0:GetBg(var0)
	end

	if not arg1:GetBgName() then
		return
	end

	var0.super.UpdateBg(arg0, arg1)
end

function var0.OnInit(arg0, arg1, arg2, arg3)
	if arg1:ShouldBlackScreen() then
		setActive(arg0.curtain, true)
		arg0.curtain:SetAsLastSibling()
		arg3()
	else
		var0.super.OnInit(arg0, arg1, arg2, arg3)
	end
end

function var0.OnEnter(arg0, arg1, arg2, arg3)
	if arg1:ShouldBlackScreen() then
		arg0:DelayCall(arg1:ShouldBlackScreen(), function()
			setActive(arg0.curtain, true)
			arg0.curtain:SetAsFirstSibling()
			assert(not arg1:ExistOption())
			arg3()
			triggerButton(arg0._go)
		end)
	else
		local var0 = arg1:GetUnscaleDelay()

		if arg0.autoNext then
			var0 = var0 - arg0.script:GetTriggerDelayTime()
		end

		arg0:UnscaleDelayCall(var0, function()
			var0.super.OnEnter(arg0, arg1, arg2, arg3)
		end)
	end
end

function var0.GetSideTF(arg0, arg1)
	local var0
	local var1
	local var2
	local var3

	if DialogueStep.SIDE_LEFT == arg1 then
		var0, var1, var2, var3 = nil, arg0.nameLeft, arg0.nameLeftTxt
	elseif DialogueStep.SIDE_RIGHT == arg1 then
		var0, var1, var2, var3 = nil, arg0.nameRight, arg0.nameRightTxt
	elseif DialogueStep.SIDE_MIDDLE == arg1 then
		var0, var1, var2, var3 = nil, arg0.nameLeft, arg0.nameLeftTxt
	end

	return var0, var1, var2, var3
end

function var0.Clear(arg0, arg1)
	arg0.bgs = {}
	arg0.goCG.alpha = 1
	arg0.callback = nil
	arg0.autoNext = nil
	arg0.script = nil
	arg0.subImage.sprite = nil

	arg0:OnClear()

	if arg1 then
		arg1()
	end

	pg.DelegateInfo.New(arg0)
end

function var0.StoryEnd(arg0)
	var0.super.StoryEnd(arg0)

	arg0.bgRecord = nil
	arg0.bgImage.sprite = nil
end

return var0
