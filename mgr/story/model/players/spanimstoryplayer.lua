local var0_0 = class("SpAnimStoryPlayer", import(".StoryPlayer"))

function var0_0.OnReset(arg0_1, arg1_1, arg2_1, arg3_1)
	setActive(arg0_1.spAnimPanel, true)

	local var0_1 = pg.NewStoryMgr.GetInstance().skipBtn
	local var1_1 = pg.NewStoryMgr.GetInstance().autoBtn
	local var2_1 = pg.NewStoryMgr.GetInstance().recordBtn

	arg0_1.hideBtns = {}

	if isActive(var0_1) and arg1_1:ShouldHideSkipBtn() then
		setActive(var0_1, false)
		table.insert(arg0_1.hideBtns, var0_1)
	end

	if isActive(var1_1) then
		setActive(var1_1, false)
		table.insert(arg0_1.hideBtns, var1_1)
	end

	if isActive(var2_1) then
		setActive(var2_1, false)
		table.insert(arg0_1.hideBtns, var2_1)
	end

	arg3_1()
end

function var0_0.OnEnter(arg0_2, arg1_2, arg2_2, arg3_2)
	seriesAsync({
		function(arg0_3)
			arg0_2:GetSpine(arg1_2, arg0_3)
		end,
		function(arg0_4)
			arg0_2:PlaySpAnim(arg1_2, arg0_4)
		end
	}, arg3_2)
end

function var0_0.GetSpine(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetSpineName()

	PoolMgr.GetInstance():GetSpineChar(var0_5, true, function(arg0_6)
		setParent(arg0_6, arg0_5.spAnimPanel)

		tf(arg0_6).localPosition = Vector3(0, 0, 0)

		local var0_6 = arg0_6:GetComponent("SpineAnimUI")

		arg0_5.spineAnim = var0_6
		arg0_5.shipModel = arg0_6

		arg2_5()
	end)

	arg0_5.prefab = var0_5
end

function var0_0.PlaySpAnim(arg0_7, arg1_7, arg2_7)
	arg0_7.spineAnim:SetActionCallBack(nil)

	if arg1_7:HasStopTime() then
		arg0_7:DelayCall(arg1_7:GetStopTime(), arg2_7)
	else
		arg0_7.spineAnim:SetActionCallBack(function(arg0_8)
			if arg0_8 == "finish" then
				arg0_7.spineAnim:SetActionCallBack(nil)
				arg2_7()
			end
		end)
	end

	local var0_7 = arg1_7:GetActionName()

	arg0_7.spineAnim:SetAction(var0_7, 0)

	if arg1_7:ShouldAdjustSpeed() then
		arg0_7:AdjustSpeed(arg1_7:GetSpeed())
	end
end

function var0_0.AdjustSpeed(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetAnimationState()

	var0_9.TimeScale = var0_9.TimeScale * arg1_9
end

function var0_0.GetAnimationState(arg0_10)
	return arg0_10.shipModel:GetComponent("Spine.Unity.SkeletonGraphic").AnimationState
end

function var0_0.ReturnSpine(arg0_11)
	if arg0_11.shipModel == nil or arg0_11.spineAnim == nil or arg0_11.prefab == nil then
		return
	end

	arg0_11:GetAnimationState().TimeScale = 1

	arg0_11.spineAnim:SetActionCallBack(nil)
	PoolMgr.GetInstance():ReturnSpineChar(arg0_11.prefab, arg0_11.shipModel)

	arg0_11.shipModel = nil
	arg0_11.spineAnim = nil
	arg0_11.prefab = nil
end

function var0_0.ClearSp(arg0_12)
	arg0_12:ReturnSpine()

	for iter0_12, iter1_12 in pairs(arg0_12.hideBtns or {}) do
		setActive(iter1_12, true)
	end

	arg0_12.hideBtns = {}
end

function var0_0.OnWillExit(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13:ClearSp()
	arg3_13()
end

function var0_0.OnEnd(arg0_14)
	arg0_14:ClearSp()
end

function var0_0.RegisetEvent(arg0_15, arg1_15, arg2_15)
	var0_0.super.RegisetEvent(arg0_15, arg1_15, arg2_15)
	triggerButton(arg0_15._go)
end

return var0_0
