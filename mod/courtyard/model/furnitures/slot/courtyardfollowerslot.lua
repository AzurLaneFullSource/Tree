local var0_0 = class("CourtYardFollowerSlot", import(".CourtYardFurnitureBaseSlot"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.name = arg1_1[1][1]
	arg0_1.defaultAction = arg1_1[1][2]
	arg0_1.skewValue = Vector3(arg1_1[3][1][1], arg1_1[3][1][2])
	arg0_1.aciton = arg1_1[3][2]
end

function var0_0.OnInitCombine(arg0_2, arg1_2)
	arg0_2.combineData = arg1_2
end

function var0_0.GetSpineDefaultAction(arg0_3)
	local var0_3 = arg0_3:GetCombineFurnitureAnimator()

	if var0_3 then
		return var0_3[2] or arg0_3.defaultAction
	end

	return arg0_3.defaultAction
end

function var0_0.Occupy(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg0_4:IsEmpty() then
		arg0_4.owner = arg2_4
		arg0_4.user = arg1_4
		arg0_4.observer = arg3_4

		arg0_4:Use()
		arg0_4:OnAwake()
		arg3_4:StartInteraction(arg0_4)
		arg1_4:StartInteraction(arg0_4)
		arg2_4:StartInteraction(arg0_4, true)
		arg0_4:OnStart()
	end
end

function var0_0.OnAwake(arg0_5)
	arg0_5:ClearTimer()
end

function var0_0.Clear(arg0_6, arg1_6)
	if arg0_6:IsUsing() then
		arg0_6:Empty()
		arg0_6.observer:WillClearInteraction(arg0_6, arg1_6)
		arg0_6.user:ClearInteraction(arg0_6, arg1_6)
		arg0_6.owner:ClearInteraction(arg0_6, arg1_6, true)
		arg0_6.observer:ClearInteraction(arg0_6, arg1_6)

		arg0_6.user = nil
		arg0_6.owner = nil
		arg0_6.observer = nil
	end
end

function var0_0.OnStart(arg0_7)
	local var0_7 = arg0_7:GetCombineFurnitureAnimator()
	local var1_7 = arg0_7.aciton

	var1_7 = var0_7 and var0_7[3] or var1_7

	arg0_7.user:UpdateInteraction({
		action = var1_7,
		slot = arg0_7
	})
end

function var0_0.ClearTimer(arg0_8)
	return
end

function var0_0.OnStop(arg0_9)
	arg0_9:ClearTimer()
end

function var0_0.OnEnd(arg0_10)
	arg0_10:ClearTimer()
end

function var0_0.GetBodyMask(arg0_11)
	return false
end

function var0_0.GetUsingAnimator(arg0_12)
	return false
end

function var0_0.GetFollower(arg0_13)
	return nil
end

return var0_0
