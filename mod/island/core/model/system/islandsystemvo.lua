local var0_0 = class("IslandSystemVO")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.name = arg0_1.id
	arg0_1.position = arg0_1:GetPosition()
	arg0_1.rotation = arg0_1:GetRotation()
end

function var0_0.GetBehaviourTree(arg0_2)
	assert(false, "overwrite me!")
end

function var0_0.GetType(arg0_3)
	assert(false, "overwrite me!")
end

function var0_0.GetPosition(arg0_4)
	return Vector3.zero
end

function var0_0.GetRotation(arg0_5)
	return Vector3.zero
end

return var0_0
