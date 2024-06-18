local var0_0 = {
	[Vector3] = 1,
	[Quaternion] = 2,
	[Vector2] = 3,
	[Color] = 4,
	[Vector4] = 5,
	[Ray] = 6,
	[Bounds] = 7,
	[Touch] = 8,
	[LayerMask] = 9,
	[RaycastHit] = 10,
	[int64] = 11,
	[uint64] = 12
}

local function var1_0()
	local var0_1 = getmetatable
	local var1_1 = var0_0

	return function(arg0_2)
		local var0_2 = var0_1(arg0_2)

		if var0_2 == nil then
			return 0
		end

		return var1_1[var0_2] or 0
	end
end

function AddValueType(arg0_3, arg1_3)
	var0_0[arg0_3] = arg1_3
end

GetLuaValueType = var1_0()
