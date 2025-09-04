local var0_0 = class("IslandStrollUnitVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = pg.island_strollnpc[arg1_1]

	var0_0.super.Ctor(arg0_1, {
		name = "StrollNpc",
		id = arg1_1,
		type = IslandConst.UNIT_TYPE_STROLL,
		modelId = arg2_1 or var0_1.unit_id,
		behaviourTree = arg0_1:GetDefaultBt(var0_1),
		position = {
			0,
			0,
			0
		},
		rotation = {
			0,
			0,
			0
		},
		scale = {
			0,
			0,
			0
		}
	})

	arg0_1.config = var0_1
end

function var0_0.GetDefaultBt(arg0_2, arg1_2)
	if not arg1_2.behaviourTree or arg1_2.behaviourTree == "" then
		return "Island/NodeCanvas/Npc/StrollNpc"
	end

	return arg1_2.behaviourTree
end

function var0_0.GetDefaultPathId(arg0_3, arg1_3)
	local var0_3 = _.detect(arg0_3.config.mapId, function(arg0_4)
		return arg0_4[1] == arg1_3
	end)

	return var0_3 and var0_3[2]
end

function var0_0.SetPath(arg0_5, arg1_5, arg2_5)
	arg0_5.position = BuildVector3(arg2_5)
	arg0_5.pathId = arg1_5
end

function var0_0.GetPath(arg0_6)
	return arg0_6.pathId
end

return var0_0
