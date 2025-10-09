local var0_0 = class("CourtYardFurnitureSlot", import(".CourtYardFurnitureBaseSlot"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.actionName = arg1_1[1]
	arg0_1.offset = arg1_1[2] and Vector3(arg1_1[2][1], arg1_1[2][2], 0) or Vector3.zero
	arg0_1.scale = arg1_1[3] and Vector3(arg1_1[3][1], arg1_1[3][2], 1) or Vector3.one
	arg0_1.mask = arg1_1[4]
	arg0_1.bodyMask = arg1_1[6] and {
		offset = arg1_1[6][1] and Vector2(arg1_1[6][1][1], arg1_1[6][1][2]) or Vector3.zero,
		size = arg1_1[6][2] and Vector2(arg1_1[6][2][1], arg1_1[6][2][2]) or Vector3.zero,
		img = arg1_1[6][3]
	}
end

function var0_0.OnInitCombine(arg0_2, arg1_2)
	arg0_2.combineData = arg1_2
end

function var0_0.GetMask(arg0_3)
	if arg0_3.mask == "" then
		return nil
	end

	return arg0_3.mask
end

function var0_0.OnStart(arg0_4)
	local var0_4 = arg0_4:GetCombineFurnitureAnimator()

	if var0_4 then
		return var0_4[2] or arg0_4.defaultAction
	end

	arg0_4.user:UpdateInteraction({
		action = arg0_4.actionName
	})
end

return var0_0
