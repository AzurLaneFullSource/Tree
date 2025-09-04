local var0_0 = class("IslandVisitorBuilder", import(".IslandCharUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandVisitorUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	return
end

function var0_0.SetupBT(arg0_3, arg1_3, arg2_3, arg3_3)
	arg3_3()
end

function var0_0.AddComponents(arg0_4, arg1_4, arg2_4)
	local var0_4 = GetOrAddComponent(arg1_4, typeof(CharacterController))

	var0_4.slopeLimit = 50
	var0_4.stepOffset = 0.3
	var0_4.stepOffset = 0.08
	var0_4.minMoveDistance = 0
	var0_4.height = 1.76
	var0_4.stepOffset = 0.4
	var0_4.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_4, typeof(CharacterHandleController))

	arg1_4.name = "Visitor_" .. arg2_4.id
end

return var0_0
