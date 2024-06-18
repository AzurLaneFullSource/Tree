local var0_0 = class("CourtYardRandomControllerFurniture", import(".CourtYardFurniture"))

function var0_0.InitSlots(arg0_1)
	table.insert(arg0_1.slots, CourtYardRandomControllerSlot.New(1, arg0_1.config.spine))

	if type(arg0_1.config.animator) == "table" then
		arg0_1.slots[1]:SetAnimators(arg0_1.config.animator)
	end
end

return var0_0
