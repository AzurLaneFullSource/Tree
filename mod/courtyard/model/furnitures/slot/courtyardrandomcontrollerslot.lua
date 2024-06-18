local var0_0 = class("CourtYardRandomControllerSlot", import(".CourtYardFurnitureBaseSlot"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.name = arg1_1[1][1]
	arg0_1.defaultAction = arg1_1[1][2]
	arg0_1.mask = arg1_1[2] and arg1_1[2][1]

	if arg0_1.mask then
		arg0_1.maskDefaultAction = arg1_1[2][2]
	end

	arg0_1.actions = {}

	for iter0_1, iter1_1 in ipairs(arg1_1[3][2]) do
		table.insert(arg0_1.actions, {
			userAction = iter1_1[3],
			controller = iter1_1[2],
			ownerAction = iter1_1[1]
		})
	end
end

function var0_0.SetAnimators(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2[1]) do
		table.insert(arg0_2.animators, {
			key = arg0_2.id .. "_" .. iter0_2,
			value = iter1_2
		})
	end
end

function var0_0.GetSpineDefaultAction(arg0_3)
	return arg0_3.defaultAction
end

function var0_0.GetSpineMaskDefaultAcation(arg0_4)
	return arg0_4.maskDefaultAction
end

function var0_0.OnAwake(arg0_5)
	local var0_5 = arg0_5.actions[math.random(1, #arg0_5.actions)]

	arg0_5.animatorIndex = 0

	for iter0_5, iter1_5 in ipairs(arg0_5.animators) do
		if iter1_5.value == var0_5.controller then
			arg0_5.animatorIndex = iter0_5
		end
	end

	arg0_5.actionData = var0_5
end

function var0_0.OnStart(arg0_6)
	local var0_6 = arg0_6.actionData

	arg0_6.user:UpdateInteraction({
		action = var0_6.userAction,
		slot = arg0_6
	})
	arg0_6.owner:UpdateInteraction({
		action = var0_6.ownerAction,
		slot = arg0_6
	})
end

function var0_0.OnContinue(arg0_7, arg1_7)
	if arg1_7 == arg0_7.owner then
		arg0_7:End()
	end
end

function var0_0.Clear(arg0_8, arg1_8)
	var0_0.super.Clear(arg0_8, arg1_8)

	arg0_8.actionData = nil
end

return var0_0
