local var0_0 = class("IslandChatBubblePlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1.tpl = arg1_1
	arg0_1.role = arg2_1
	arg0_1.contentTxt = arg0_1.tpl.transform:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2:Stop()
	seriesAsync({
		function(arg0_3)
			setActive(arg0_2.tpl, true)
			arg0_2:UpdateBubble(arg1_2, arg0_3)
		end,
		function(arg0_4)
			arg0_2:WaitForNextOne(arg1_2, arg0_4)
		end,
		function(arg0_5)
			arg0_2:EneAction(arg1_2)
			arg0_5()
		end
	}, arg2_2)
end

function var0_0.UpdateBubble(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetSay()

	if var0_6 == "" then
		if arg2_6 then
			arg2_6()
		end

		return
	end

	arg0_6.contentTxt.text = var0_6

	arg0_6:PlayCharatorAnimation(arg1_6)
	arg2_6()
end

function var0_0.WaitForNextOne(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:GetTime()

	arg0_7:UnscaleDelayCall(var0_7, arg2_7)
end

function var0_0.PlayCharatorAnimation(arg0_8, arg1_8)
	if not arg1_8:ExistAnimation() then
		return
	end

	local var0_8 = arg0_8.role
	local var1_8 = arg1_8:GetAnimation()
	local var2_8 = var0_8:GetComponent(typeof(Animator)) or var0_8.transform:GetChild(0):GetComponent(typeof(Animator))

	if not var2_8:GetCurrentAnimatorStateInfo(0):IsName(var1_8) then
		local var3_8 = Animator.StringToHash(var1_8)

		for iter0_8 = 1, var2_8.layerCount do
			var2_8:CrossFadeInFixedTime(var3_8, 0.2, iter0_8 - 1)
		end
	end
end

function var0_0.EneAction(arg0_9, arg1_9)
	arg0_9:RemnoveTimer()

	local var0_9, var1_9 = arg1_9:GetHideType()
	local var2_9 = arg0_9.tpl

	if var0_9 == BubbleStep.HIDE_TYPE_IMMEDIATELY then
		setActive(var2_9, false)
	elseif var0_9 == BubbleStep.HIDE_TYPE_NEVER then
		-- block empty
	elseif var0_9 == BubbleStep.HIDE_TYPE_TIME then
		arg0_9.timer = arg0_9:CreateDelayTimer(var1_9, function()
			if not IsNil(var2_9) then
				setActive(var2_9, false)
			end
		end)
	end
end

function var0_0.RemnoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.Stop(arg0_12)
	arg0_12:RemnoveTimer()
	arg0_12:ClearAnimation()
	setActive(arg0_12.tpl, false)
end

function var0_0.Dispose(arg0_13)
	Object.Destroy(arg0_13.tpl)

	arg0_13.tpl = nil
	arg0_13.role = nil
	arg0_13.contentTxt = nil

	arg0_13:RemnoveTimer()
	arg0_13:ClearAnimation()
end

return var0_0
