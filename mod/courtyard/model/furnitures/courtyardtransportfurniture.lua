local var0 = class("CourtYardTransportFurniture", import(".CourtYardFurniture"))

function var0.InitSlots(arg0)
	table.insert(arg0.slots, CourtYardTransportSlot.New(1, arg0.config.spine))

	if type(arg0.config.animator) == "table" then
		arg0.slots[1]:SetAnimators(arg0.config.animator)
	end
end

function var0.IsUsing(arg0)
	return #arg0:GetUsingSlots() > 0
end

function var0.Stop(arg0)
	arg0.slots[1]:Stop()
end

return var0
