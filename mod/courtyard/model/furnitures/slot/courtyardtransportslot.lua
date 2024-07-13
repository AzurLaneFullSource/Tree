local var0_0 = class("CourtYardTransportSlot", import(".CourtYardFurnitureBaseSlot"))

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.name = arg1_1[1][1]
	arg0_1.defaultAction = arg1_1[1][2]
	arg0_1.actions = {}

	for iter0_1, iter1_1 in ipairs(arg1_1[2]) do
		table.insert(arg0_1.actions, {
			userAction = iter1_1[1],
			ownerAction = iter1_1[2],
			time = iter1_1[3]
		})
	end

	arg0_1.animators = {}
end

function var0_0.SetAnimators(arg0_2, arg1_2)
	for iter0_2, iter1_2 in ipairs(arg1_2) do
		table.insert(arg0_2.animators, {
			key = arg0_2.id .. "_" .. iter0_2,
			value = iter1_2
		})
	end
end

function var0_0.GetSpineDefaultAction(arg0_3)
	return arg0_3.defaultAction
end

function var0_0.OnAwake(arg0_4)
	arg0_4.animatorIndex = arg0_4.index
end

function var0_0.OnStart(arg0_5)
	local var0_5 = arg0_5.actions[arg0_5.index]

	arg0_5.user:UpdateInteraction({
		action = var0_5.userAction,
		slot = arg0_5
	})
	arg0_5.owner:UpdateInteraction({
		action = var0_5.ownerAction,
		slot = arg0_5
	})
	Timer.New(function()
		arg0_5:End()
	end, var0_5.time, 1):Start()
end

function var0_0.Occupy(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.index = 1

	var0_0.super.Occupy(arg0_7, arg1_7, arg2_7, arg3_7)
end

function var0_0.Link(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8.index = 2

	var0_0.super.Occupy(arg0_8, arg1_8, arg2_8, arg3_8)
end

function var0_0.IsFirstTime(arg0_9)
	return arg0_9.index == 1
end

return var0_0
