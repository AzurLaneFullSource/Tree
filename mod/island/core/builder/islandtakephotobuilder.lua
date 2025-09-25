local var0_0 = class("IslandTakePhotoBuilder", import(".IslandGenericBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	if arg2_1.id == 2 then
		return IslandTakePhotoUnit.New(arg1_1, arg2_1)
	else
		return IslandThirdTakePhotoUnit.New(arg1_1, arg2_1)
	end
end

function var0_0.SetTag(arg0_2, arg1_2)
	arg1_2.tag = IslandConst.TAG_NPC
end

function var0_0.AddComponents(arg0_3, arg1_3, arg2_3)
	arg1_3:GetComponent(typeof(WorldObjectItem)).isPlayer = false

	local var0_3 = GetOrAddComponent(arg1_3, typeof(CharacterController))

	var0_3.slopeLimit = 50
	var0_3.stepOffset = 0.3
	var0_3.stepOffset = 0.08
	var0_3.minMoveDistance = 0

	if arg2_3.id == 2 then
		var0_3.height = 1.76
		var0_3.stepOffset = 0.4
	else
		var0_3.height = 0.1
		var0_3.stepOffset = 0.01
	end

	var0_3.center = Vector3(0, 0.96, 0)
end

return var0_0
