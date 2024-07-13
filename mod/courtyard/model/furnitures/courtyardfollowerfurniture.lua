local var0_0 = class("CourtYardFollowerFurniture", import(".CourtYardFurniture"))

function var0_0.InitSlots(arg0_1)
	arg0_1.ratios = {}

	table.insert(arg0_1.slots, CourtYardFollowerSlot.New(1, arg0_1.config.spine))
end

function var0_0.GetInterActionTime(arg0_2)
	return math.random(5, 10)
end

function var0_0.GetRatio(arg0_3, arg1_3)
	return arg0_3.ratios[arg1_3] or 0
end

function var0_0.IncreaseRatio(arg0_4, arg1_4)
	arg0_4.ratios[arg1_4] = 100
end

function var0_0.ReduceRatio(arg0_5, arg1_5)
	arg0_5.ratios[arg1_5] = arg0_5:GetRatio(arg1_5) - 20
end

function var0_0.CanFollower(arg0_6, arg1_6)
	if arg0_6:IsUsing() then
		return false
	end

	local var0_6 = arg0_6:GetRatio(arg1_6) <= 0

	if not var0_6 then
		arg0_6:ReduceRatio(arg1_6)
	end

	return var0_6
end

function var0_0.IsUsing(arg0_7)
	return arg0_7.slots[1]:IsUsing()
end

function var0_0.StartInteraction(arg0_8, arg1_8)
	var0_0.super.StartInteraction(arg0_8, arg1_8)

	local var0_8 = arg1_8:GetOwner()

	arg0_8:IncreaseRatio(var0_8)
end

function var0_0.GetOwner(arg0_9)
	if arg0_9:IsUsing() then
		return arg0_9.slots[1]:GetOwner()
	end
end

function var0_0.Stop(arg0_10)
	arg0_10.slots[1]:Stop()
end

function var0_0.SetPosition(arg0_11, arg1_11)
	var0_0.super.SetPosition(arg0_11, arg1_11)
	arg0_11:DispatchEvent(CourtYardEvent.ROTATE_FURNITURE, arg0_11.dir)
end

return var0_0
