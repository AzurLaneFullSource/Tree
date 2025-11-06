local var0_0 = class("IslandFollowerUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1, arg6_1)
	arg0_1.randomizer = defaultValue(arg6_1, false)
	arg0_1.shipId = arg1_1

	var0_0.super.Ctor(arg0_1, {
		behaviourTree = "Island/NodeCanvas/Npc/FollowNpc",
		id = arg2_1,
		name = "FollowNpc" .. arg2_1,
		type = IslandConst.UNIT_TYPE_FOLLOWER,
		modelId = arg3_1,
		position = {
			arg4_1.x,
			arg4_1.y,
			arg4_1.z
		},
		rotation = {
			arg5_1.x,
			arg5_1.y,
			arg5_1.z
		},
		scale = {
			1,
			1,
			1
		}
	})
end

function var0_0.IsSameShip(arg0_2, arg1_2)
	return arg0_2.shipId == arg1_2
end

function var0_0.GetShipId(arg0_3)
	return arg0_3.shipId
end

function var0_0.IsRandomizer(arg0_4)
	return arg0_4.randomizer
end

function var0_0.ActiveRandomizer(arg0_5)
	arg0_5.randomizer = true
end

return var0_0
