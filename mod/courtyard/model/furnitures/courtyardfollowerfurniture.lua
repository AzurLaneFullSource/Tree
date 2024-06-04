local var0 = class("CourtYardFollowerFurniture", import(".CourtYardFurniture"))

function var0.InitSlots(arg0)
	arg0.ratios = {}

	table.insert(arg0.slots, CourtYardFollowerSlot.New(1, arg0.config.spine))
end

function var0.GetInterActionTime(arg0)
	return math.random(5, 10)
end

function var0.GetRatio(arg0, arg1)
	return arg0.ratios[arg1] or 0
end

function var0.IncreaseRatio(arg0, arg1)
	arg0.ratios[arg1] = 100
end

function var0.ReduceRatio(arg0, arg1)
	arg0.ratios[arg1] = arg0:GetRatio(arg1) - 20
end

function var0.CanFollower(arg0, arg1)
	if arg0:IsUsing() then
		return false
	end

	local var0 = arg0:GetRatio(arg1) <= 0

	if not var0 then
		arg0:ReduceRatio(arg1)
	end

	return var0
end

function var0.IsUsing(arg0)
	return arg0.slots[1]:IsUsing()
end

function var0.StartInteraction(arg0, arg1)
	var0.super.StartInteraction(arg0, arg1)

	local var0 = arg1:GetOwner()

	arg0:IncreaseRatio(var0)
end

function var0.GetOwner(arg0)
	if arg0:IsUsing() then
		return arg0.slots[1]:GetOwner()
	end
end

function var0.Stop(arg0)
	arg0.slots[1]:Stop()
end

function var0.SetPosition(arg0, arg1)
	var0.super.SetPosition(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0.dir)
end

return var0
