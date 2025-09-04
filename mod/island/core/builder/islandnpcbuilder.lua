local var0_0 = class("IslandNpcBuilder", import(".IslandCharUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandNpcUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_NPC
end

function var0_0.AddComponents(arg0_3, arg1_3, arg2_3)
	local var0_3 = GetOrAddComponent(arg1_3, typeof(CharacterController))

	var0_3.slopeLimit = 50
	var0_3.stepOffset = 0.3
	var0_3.stepOffset = 0.08
	var0_3.minMoveDistance = 0
	var0_3.height = 1.76
	var0_3.stepOffset = 0.4
	var0_3.center = Vector3(0, 0.96, 0)

	local var1_3 = pg.island_unit_character[arg2_3.modelId]

	if var1_3.CollisionParam ~= "" then
		var0_3.center = Vector3(0, var1_3.CollisionParam[1], 0)
		var0_3.radius = var1_3.CollisionParam[2]
		var0_3.height = var1_3.CollisionParam[3]
	end

	GetOrAddComponent(arg1_3, typeof(CharacterHandleController))
end

return var0_0
