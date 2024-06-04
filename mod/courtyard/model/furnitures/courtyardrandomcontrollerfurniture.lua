local var0 = class("CourtYardRandomControllerFurniture", import(".CourtYardFurniture"))

function var0.InitSlots(arg0)
	table.insert(arg0.slots, CourtYardRandomControllerSlot.New(1, arg0.config.spine))

	if type(arg0.config.animator) == "table" then
		arg0.slots[1]:SetAnimators(arg0.config.animator)
	end
end

return var0
