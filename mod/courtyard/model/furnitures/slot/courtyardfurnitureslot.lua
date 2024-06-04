local var0 = class("CourtYardFurnitureSlot", import(".CourtYardFurnitureBaseSlot"))

function var0.OnInit(arg0, arg1)
	arg0.actionName = arg1[1]
	arg0.offset = arg1[2] and Vector3(arg1[2][1], arg1[2][2], 0) or Vector3.zero
	arg0.scale = arg1[3] and Vector3(arg1[3][1], arg1[3][2], 1) or Vector3.one
	arg0.mask = arg1[4]
	arg0.bodyMask = arg1[6] and {
		offset = arg1[6][1] and Vector2(arg1[6][1][1], arg1[6][1][2]) or Vector3.zero,
		size = arg1[6][2] and Vector2(arg1[6][2][1], arg1[6][2][2]) or Vector3.zero,
		img = arg1[6][3]
	}
end

function var0.GetMask(arg0)
	if arg0.mask == "" then
		return nil
	end

	return arg0.mask
end

function var0.OnStart(arg0)
	arg0.user:UpdateInteraction({
		action = arg0.actionName
	})
end

return var0
