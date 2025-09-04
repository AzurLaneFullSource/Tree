local var0_0 = class("IslandSystemNpcBuilder", import(".IslandCharUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandSystemNpcUnit.New(arg1_1, arg2_1)
end

function var0_0.AddComponents(arg0_2, arg1_2, arg2_2)
	local var0_2 = GetOrAddComponent(arg1_2, typeof(CharacterController))

	var0_2.slopeLimit = 50
	var0_2.stepOffset = 0.3
	var0_2.stepOffset = 0.08
	var0_2.minMoveDistance = 0
	var0_2.height = 1.76
	var0_2.stepOffset = 0.4
	var0_2.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_2, typeof(CharacterHandleController))
end

return var0_0
