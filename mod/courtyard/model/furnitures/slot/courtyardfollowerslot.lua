local var0_0 = class("CourtYardFollowerSlot", import(".CourtYardFurnitureBaseSlot"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.name = arg1_1[1][1]
	arg0_1.defaultAction = arg1_1[1][2]
	arg0_1.skewValue = Vector3(arg1_1[3][1][1], arg1_1[3][1][2])
	arg0_1.aciton = arg1_1[3][2]
end

function var0_0.GetSpineDefaultAction(arg0_2)
	return arg0_2.defaultAction
end

function var0_0.Occupy(arg0_3, arg1_3, arg2_3, arg3_3)
	if arg0_3:IsEmpty() then
		arg0_3.owner = arg2_3
		arg0_3.user = arg1_3
		arg0_3.observer = arg3_3

		arg0_3:Use()
		arg0_3:OnAwake()
		arg3_3:StartInteraction(arg0_3)
		arg1_3:StartInteraction(arg0_3)
		arg2_3:StartInteraction(arg0_3, true)
		arg0_3:OnStart()
	end
end

function var0_0.OnAwake(arg0_4)
	arg0_4:ClearTimer()
end

function var0_0.Clear(arg0_5, arg1_5)
	if arg0_5:IsUsing() then
		arg0_5:Empty()
		arg0_5.observer:WillClearInteraction(arg0_5, arg1_5)
		arg0_5.user:ClearInteraction(arg0_5, arg1_5)
		arg0_5.owner:ClearInteraction(arg0_5, arg1_5, true)
		arg0_5.observer:ClearInteraction(arg0_5, arg1_5)

		arg0_5.user = nil
		arg0_5.owner = nil
		arg0_5.observer = nil
	end
end

function var0_0.OnStart(arg0_6)
	arg0_6.user:UpdateInteraction({
		action = arg0_6.aciton,
		slot = arg0_6
	})
end

function var0_0.ClearTimer(arg0_7)
	return
end

function var0_0.OnStop(arg0_8)
	arg0_8:ClearTimer()
end

function var0_0.OnEnd(arg0_9)
	arg0_9:ClearTimer()
end

function var0_0.GetBodyMask(arg0_10)
	return false
end

function var0_0.GetUsingAnimator(arg0_11)
	return false
end

function var0_0.GetFollower(arg0_12)
	return nil
end

return var0_0
