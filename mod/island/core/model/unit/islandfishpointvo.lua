local var0_0 = class("IslandFishPointVO", import(".IslandUnitVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	local var0_1 = pg.island_world_objects[arg2_1]

	var0_0.super.Ctor(arg0_1, {
		behaviourTree = "",
		id = arg1_1,
		name = "fishPoint" .. arg1_1,
		type = IslandConst.UNIT_TYPE_FISH_POINT,
		modelId = var0_1.unitId,
		position = var0_1.param.position,
		rotation = var0_1.param.rotation,
		scale = {
			1,
			1,
			1
		}
	})
end

return var0_0
