local var0 = class("CourtYardTransportSlot", import(".CourtYardFurnitureBaseSlot"))

function var0.OnInit(arg0, arg1)
	arg0.name = arg1[1][1]
	arg0.defaultAction = arg1[1][2]
	arg0.actions = {}

	for iter0, iter1 in ipairs(arg1[2]) do
		table.insert(arg0.actions, {
			userAction = iter1[1],
			ownerAction = iter1[2],
			time = iter1[3]
		})
	end

	arg0.animators = {}
end

function var0.SetAnimators(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		table.insert(arg0.animators, {
			key = arg0.id .. "_" .. iter0,
			value = iter1
		})
	end
end

function var0.GetSpineDefaultAction(arg0)
	return arg0.defaultAction
end

function var0.OnAwake(arg0)
	arg0.animatorIndex = arg0.index
end

function var0.OnStart(arg0)
	local var0 = arg0.actions[arg0.index]

	arg0.user:UpdateInteraction({
		action = var0.userAction,
		slot = arg0
	})
	arg0.owner:UpdateInteraction({
		action = var0.ownerAction,
		slot = arg0
	})
	Timer.New(function()
		arg0:End()
	end, var0.time, 1):Start()
end

function var0.Occupy(arg0, arg1, arg2, arg3)
	arg0.index = 1

	var0.super.Occupy(arg0, arg1, arg2, arg3)
end

function var0.Link(arg0, arg1, arg2, arg3)
	arg0.index = 2

	var0.super.Occupy(arg0, arg1, arg2, arg3)
end

function var0.IsFirstTime(arg0)
	return arg0.index == 1
end

return var0
