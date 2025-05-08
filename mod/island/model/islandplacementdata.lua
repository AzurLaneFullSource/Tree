local var0_0 = class("IslandPlacementData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.position = Vector2(arg1_1.x or 0, arg1_1.y or 0)
	arg0_1.dir = arg1_1.dir or 0
end

function var0_0.GetPosition(arg0_2)
	return arg0_2.position
end

function var0_0.GetRotation(arg0_3)
	return Vector3(0, arg0_3.dir * 90, 0)
end

function var0_0.IsSame(arg0_4, arg1_4)
	if not arg1_4 then
		return false
	end

	return arg0_4.position.x == arg1_4.position.x and arg0_4.position.y == arg1_4.position.y and arg0_4.dir == arg1_4.dir
end

return var0_0
