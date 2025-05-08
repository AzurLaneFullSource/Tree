local var0_0 = class("IslandChatBubblePlayer", import("Mgr.Story.model.animation.StoryAnimtion"))

var0_0.STATE_NONE = 0
var0_0.STATE_PLAYING = 1
var0_0.STATE_STOP = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.bubblePanel = arg0_1._tf:Find("bubble")
	arg0_1.chat3dTpl = arg0_1._tf:GetComponent(typeof(ItemList)).prefabItem[0]
	arg0_1.chatTpl = arg0_1._tf:GetComponent(typeof(ItemList)).prefabItem[1]
	arg0_1.chatTpls = {}
	arg0_1.timers = {}
	arg0_1.state = var0_0.STATE_NONE
end

function var0_0.Play(arg0_2, arg1_2, arg2_2)
	arg0_2:StartAction(arg1_2)

	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.steps) do
		table.insert(var0_2, function(arg0_3)
			arg0_2:StartStep(arg1_2, iter0_2, arg0_3)
		end)
	end

	seriesAsync(var0_2, function()
		arg0_2:EndAction()

		if arg2_2 then
			arg2_2()
		end
	end)
end

function var0_0.IsRunning(arg0_5)
	return arg0_5.state == var0_0.STATE_PLAYING
end

function var0_0.StartAction(arg0_6, arg1_6)
	arg0_6.script = arg1_6
	arg0_6.isUseUISpace = arg1_6:IsUseUISpace()
	arg0_6.playerUnit = arg1_6:GetPlayerRole()

	if not arg0_6.handle then
		arg0_6.handle = UpdateBeat:CreateListener(arg0_6.Update, arg0_6)
	end

	UpdateBeat:AddListener(arg0_6.handle)

	arg0_6.state = var0_0.STATE_PLAYING
end

function var0_0.StartStep(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg0_7:IsRunning() then
		arg3_7()

		return
	end

	local var0_7 = arg1_7:GetStepByIndex(arg2_7)

	if not var0_7 then
		arg3_7()

		return
	end

	seriesAsync({
		function(arg0_8)
			arg0_7:UpdateBubble(var0_7, arg0_8)
		end,
		function(arg0_9)
			arg0_7:WaitForNextOne(var0_7, arg0_9)
		end,
		function(arg0_10)
			arg0_7:EndStep(var0_7)
			arg0_10()
		end
	}, arg3_7)
end

function var0_0.UpdateBubble(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg1_11:GetSay()

	if var0_11 == "" then
		if arg2_11 then
			arg2_11()
		end

		return
	end

	if arg0_11.isUseUISpace then
		arg0_11:UpdateBubbleByUISpace(arg1_11, var0_11)
	else
		arg0_11:UpdateBubbleByWorldSpace(arg1_11, var0_11)
	end

	arg0_11:PlayCharatorAnimation(arg1_11)
	arg2_11()
end

function var0_0.UpdateBubbleByUISpace(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:GetChatTpl(arg1_12:GetUnitId())

	if var0_12 then
		setText(var0_12.transform:Find("Text"), arg2_12)
	end
end

function var0_0.UpdateChatPosition(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.chatTpls) do
		local var0_13 = arg0_13.script:GetRole(iter0_13)

		if var0_13 and not IsNil(var0_13) then
			local var1_13 = var0_13.transform.position + Vector3(0, 2.3, 0)
			local var2_13 = IslandCalcUtil.IsInViewport(var1_13)

			setActive(iter1_13, var2_13)

			if var2_13 then
				iter1_13.transform.localPosition = IslandCalcUtil.WorldPosition2LocalPosition(arg0_13.bubblePanel, var1_13)
			end
		end
	end
end

function var0_0.GetChatTpl(arg0_14, arg1_14)
	if not arg0_14.script:GetRole(arg1_14) then
		return nil
	end

	local var0_14 = arg0_14.chatTpls[arg1_14] or Object.Instantiate(arg0_14.chatTpl, arg0_14.bubblePanel)

	arg0_14.chatTpls[arg1_14] = var0_14

	return var0_14
end

function var0_0.UpdateUI(arg0_15)
	arg0_15:UpdateChatPosition()
end

function var0_0.UpdateBubbleByWorldSpace(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16:GetChat3dTpl(arg1_16:GetUnitId())

	setText(var0_16.transform:Find("chat/Text"), arg2_16)
end

function var0_0.GetChat3dTpl(arg0_17, arg1_17)
	local var0_17 = arg0_17.script:GetRole(arg1_17)

	if not var0_17 then
		return nil
	end

	local var1_17 = arg0_17.chatTpls[arg1_17] or Object.Instantiate(arg0_17.chat3dTpl, var0_17.transform)

	var1_17:GetComponent(typeof(Canvas)).worldCamera = IslandCameraMgr.instance._mainCamera
	arg0_17.chatTpls[arg1_17] = var1_17

	return var1_17
end

function var0_0.UpdateWorldSpace(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.chatTpls) do
		if isActive(iter1_18) then
			iter1_18.transform:LookAt(IslandCameraMgr.instance._mainCamera.gameObject.transform.position)

			iter1_18.transform.eulerAngles = Vector3(0, iter1_18.transform.eulerAngles.y, 0)
		end
	end
end

function var0_0.WaitForNextOne(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19:GetTime()

	arg0_19:UnscaleDelayCall(var0_19, arg2_19)
end

function var0_0.PlayCharatorAnimation(arg0_20, arg1_20)
	if not arg1_20:ExistAnimation() then
		return
	end

	local var0_20 = arg0_20.script:GetRole(arg1_20:GetUnitId())

	if not var0_20 then
		callback()

		return
	end

	local var1_20 = arg1_20:GetAnimation()
	local var2_20 = var0_20:GetComponent(typeof(Animator))

	if not var2_20:GetCurrentAnimatorStateInfo(0):IsName(var1_20) then
		local var3_20 = Animator.StringToHash(var1_20)

		var2_20:CrossFadeInFixedTime(var3_20, 0.2)
	end
end

function var0_0.EndStep(arg0_21, arg1_21)
	local var0_21 = arg1_21:GetUnitId()
	local var1_21 = arg0_21.chatTpls[var0_21]

	if not var1_21 then
		return
	end

	arg0_21:RemnoveTimer(var0_21)

	local var2_21, var3_21 = arg1_21:GetHideType()

	if var2_21 == BubbleStep.HIDE_TYPE_IMMEDIATELY then
		setActive(var1_21, false)
	elseif var2_21 == BubbleStep.HIDE_TYPE_NEVER then
		-- block empty
	elseif var2_21 == BubbleStep.HIDE_TYPE_TIME then
		local var4_21 = arg0_21:CreateDelayTimer(var3_21, function()
			if not IsNil(var1_21) then
				setActive(var1_21, false)
			end
		end)

		arg0_21.timers[var0_21] = var4_21
	end

	arg0_21:ClearAnimation()
end

function var0_0.RemnoveTimer(arg0_23, arg1_23)
	if arg0_23.timers[arg1_23] then
		arg0_23.timers[arg1_23]:Stop()

		arg0_23.timers[arg1_23] = nil
	end
end

function var0_0.Update(arg0_24)
	if arg0_24.isUseUISpace then
		arg0_24:UpdateUI()
	else
		arg0_24:UpdateWorldSpace()
	end
end

function var0_0.EndAction(arg0_25)
	if arg0_25.handle then
		UpdateBeat:RemoveListener(arg0_25.handle)
	end

	arg0_25.handle = nil

	for iter0_25, iter1_25 in pairs(arg0_25.timers) do
		iter1_25:Stop()
	end

	arg0_25.timers = {}

	for iter2_25, iter3_25 in pairs(arg0_25.chatTpls) do
		if not IsNil(iter3_25) then
			Object.Destroy(iter3_25.gameObject)
		end
	end

	arg0_25.chatTpls = {}
	arg0_25.script = nil
	arg0_25.state = var0_0.STATE_STOP
end

function var0_0.Stop(arg0_26)
	arg0_26:EndAction()
end

return var0_0
