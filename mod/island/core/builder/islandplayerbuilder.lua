local var0_0 = class("IslandPlayerBuilder", import(".IslandUnitBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandPlayerUnit.New(arg1_1, arg2_1)
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_PLAYER
end

function var0_0.AddComponents(arg0_3, arg1_3)
	local var0_3 = GetOrAddComponent(arg1_3, typeof(CharacterController))

	var0_3.slopeLimit = 50
	var0_3.stepOffset = 0.3
	var0_3.stepOffset = 0.08
	var0_3.minMoveDistance = 0
	var0_3.height = 1.76
	var0_3.stepOffset = 0.4
	var0_3.center = Vector3(0, 0.96, 0)

	GetOrAddComponent(arg1_3, typeof(CharacterHandleController))
end

return var0_0
