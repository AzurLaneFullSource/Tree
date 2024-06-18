local var0_0 = class("BgStoryPlayer", import(".DialogueStoryPlayer"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.subImage = arg0_1:findTF("sub", arg0_1.bgPanel):GetComponent(typeof(Image))
	arg0_1.bgRecord = nil
end

function var0_0.Reset(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.super.Reset(arg0_2, arg1_2, arg2_2, arg3_2)
	setActive(arg0_2.bgPanel, true)
	setActive(arg0_2.subImage.gameObject, false)
	setActive(arg0_2.actorPanel, false)
	arg0_2:RecyclePainting({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	})
end

function var0_0.OnBgUpdate(arg0_3, arg1_3)
	local var0_3 = arg1_3:GetBgName()

	if arg0_3.bgRecord ~= var0_3 then
		arg0_3.bgRecord = var0_3

		local var1_3 = arg1_3:GetFadeSpeed()

		arg0_3:TweenValueForcanvasGroup(arg0_3.bgPanelCg, 0, 1, var1_3, 0, nil)
	end
end

function var0_0.UpdateBg(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetSubBg()

	if var0_4 then
		setActive(arg0_4.subImage.gameObject, true)

		arg0_4.subImage.sprite = arg0_4:GetBg(var0_4)
	end

	if not arg1_4:GetBgName() then
		return
	end

	var0_0.super.UpdateBg(arg0_4, arg1_4)
end

function var0_0.OnInit(arg0_5, arg1_5, arg2_5, arg3_5)
	if arg1_5:ShouldBlackScreen() then
		setActive(arg0_5.curtain, true)
		arg0_5.curtain:SetAsLastSibling()
		arg3_5()
	else
		var0_0.super.OnInit(arg0_5, arg1_5, arg2_5, arg3_5)
	end
end

function var0_0.OnEnter(arg0_6, arg1_6, arg2_6, arg3_6)
	if arg1_6:ShouldBlackScreen() then
		arg0_6:DelayCall(arg1_6:ShouldBlackScreen(), function()
			setActive(arg0_6.curtain, true)
			arg0_6.curtain:SetAsFirstSibling()
			assert(not arg1_6:ExistOption())
			arg3_6()
			triggerButton(arg0_6._go)
		end)
	else
		local var0_6 = arg1_6:GetUnscaleDelay()

		if arg0_6.autoNext then
			var0_6 = var0_6 - arg0_6.script:GetTriggerDelayTime()
		end

		arg0_6:UnscaleDelayCall(var0_6, function()
			var0_0.super.OnEnter(arg0_6, arg1_6, arg2_6, arg3_6)
		end)
	end
end

function var0_0.GetSideTF(arg0_9, arg1_9)
	local var0_9
	local var1_9
	local var2_9
	local var3_9

	if DialogueStep.SIDE_LEFT == arg1_9 then
		var0_9, var1_9, var2_9, var3_9 = nil, arg0_9.nameLeft, arg0_9.nameLeftTxt
	elseif DialogueStep.SIDE_RIGHT == arg1_9 then
		var0_9, var1_9, var2_9, var3_9 = nil, arg0_9.nameRight, arg0_9.nameRightTxt
	elseif DialogueStep.SIDE_MIDDLE == arg1_9 then
		var0_9, var1_9, var2_9, var3_9 = nil, arg0_9.nameLeft, arg0_9.nameLeftTxt
	end

	return var0_9, var1_9, var2_9, var3_9
end

function var0_0.Clear(arg0_10, arg1_10)
	arg0_10.bgs = {}
	arg0_10.goCG.alpha = 1
	arg0_10.callback = nil
	arg0_10.autoNext = nil
	arg0_10.script = nil
	arg0_10.subImage.sprite = nil

	arg0_10:OnClear()

	if arg1_10 then
		arg1_10()
	end

	pg.DelegateInfo.New(arg0_10)
end

function var0_0.StoryEnd(arg0_11)
	var0_0.super.StoryEnd(arg0_11)

	arg0_11.bgRecord = nil
	arg0_11.bgImage.sprite = nil
end

return var0_0
