local var0 = {
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

local function var1()
	local var0 = getmetatable
	local var1 = var0

	return function(arg0)
		local var0 = var0(arg0)

		if var0 == nil then
			return 0
		end

		return var1[var0] or 0
	end
end

function AddValueType(arg0, arg1)
	var0[arg0] = arg1
end

GetLuaValueType = var1()
