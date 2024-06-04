local var0 = class("CourtYardRandomControllerSlot", import(".CourtYardFurnitureBaseSlot"))

function var0.OnInit(arg0, arg1)
	arg0.name = arg1[1][1]
	arg0.defaultAction = arg1[1][2]
	arg0.mask = arg1[2] and arg1[2][1]

	if arg0.mask then
		arg0.maskDefaultAction = arg1[2][2]
	end

	arg0.actions = {}

	for iter0, iter1 in ipairs(arg1[3][2]) do
		table.insert(arg0.actions, {
			userAction = iter1[3],
			controller = iter1[2],
			ownerAction = iter1[1]
		})
	end
end

function var0.SetAnimators(arg0, arg1)
	for iter0, iter1 in ipairs(arg1[1]) do
		table.insert(arg0.animators, {
			key = arg0.id .. "_" .. iter0,
			value = iter1
		})
	end
end

function var0.GetSpineDefaultAction(arg0)
	return arg0.defaultAction
end

function var0.GetSpineMaskDefaultAcation(arg0)
	return arg0.maskDefaultAction
end

function var0.OnAwake(arg0)
	local var0 = arg0.actions[math.random(1, #arg0.actions)]

	arg0.animatorIndex = 0

	for iter0, iter1 in ipairs(arg0.animators) do
		if iter1.value == var0.controller then
			arg0.animatorIndex = iter0
		end
	end

	arg0.actionData = var0
end

function var0.OnStart(arg0)
	local var0 = arg0.actionData

	arg0.user:UpdateInteraction({
		action = var0.userAction,
		slot = arg0
	})
	arg0.owner:UpdateInteraction({
		action = var0.ownerAction,
		slot = arg0
	})
end

function var0.OnContinue(arg0, arg1)
	if arg1 == arg0.owner then
		arg0:End()
	end
end

function var0.Clear(arg0, arg1)
	var0.super.Clear(arg0, arg1)

	arg0.actionData = nil
end

return var0
