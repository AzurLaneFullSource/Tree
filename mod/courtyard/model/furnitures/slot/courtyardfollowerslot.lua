local var0 = class("CourtYardFollowerSlot", import(".CourtYardFurnitureBaseSlot"))

function var0.OnInit(arg0, arg1)
	arg0.name = arg1[1][1]
	arg0.defaultAction = arg1[1][2]
	arg0.skewValue = Vector3(arg1[3][1][1], arg1[3][1][2])
	arg0.aciton = arg1[3][2]
end

function var0.GetSpineDefaultAction(arg0)
	return arg0.defaultAction
end

function var0.Occupy(arg0, arg1, arg2, arg3)
	if arg0:IsEmpty() then
		arg0.owner = arg2
		arg0.user = arg1
		arg0.observer = arg3

		arg0:Use()
		arg0:OnAwake()
		arg3:StartInteraction(arg0)
		arg1:StartInteraction(arg0)
		arg2:StartInteraction(arg0, true)
		arg0:OnStart()
	end
end

function var0.OnAwake(arg0)
	arg0:ClearTimer()
end

function var0.Clear(arg0, arg1)
	if arg0:IsUsing() then
		arg0:Empty()
		arg0.observer:WillClearInteraction(arg0, arg1)
		arg0.user:ClearInteraction(arg0, arg1)
		arg0.owner:ClearInteraction(arg0, arg1, true)
		arg0.observer:ClearInteraction(arg0, arg1)

		arg0.user = nil
		arg0.owner = nil
		arg0.observer = nil
	end
end

function var0.OnStart(arg0)
	arg0.user:UpdateInteraction({
		action = arg0.aciton,
		slot = arg0
	})
end

function var0.ClearTimer(arg0)
	return
end

function var0.OnStop(arg0)
	arg0:ClearTimer()
end

function var0.OnEnd(arg0)
	arg0:ClearTimer()
end

function var0.GetBodyMask(arg0)
	return false
end

function var0.GetUsingAnimator(arg0)
	return false
end

function var0.GetFollower(arg0)
	return nil
end

return var0
