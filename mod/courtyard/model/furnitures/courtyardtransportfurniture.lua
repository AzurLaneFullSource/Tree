local var0_0 = class("CourtYardTransportFurniture", import(".CourtYardFurniture"))

function var0_0.InitSlots(arg0_1)
	table.insert(arg0_1.slots, CourtYardTransportSlot.New(1, arg0_1.config.spine))

	if type(arg0_1.config.animator) == "table" then
		arg0_1.slots[1]:SetAnimators(arg0_1.config.animator)
	end
end

function var0_0.IsUsing(arg0_2)
	return #arg0_2:GetUsingSlots() > 0
end

function var0_0.Stop(arg0_3)
	arg0_3.slots[1]:Stop()
end

return var0_0
