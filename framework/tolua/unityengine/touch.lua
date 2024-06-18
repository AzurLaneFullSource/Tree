local var0_0 = Vector2.zero
local var1_0 = rawget
local var2_0 = setmetatable

TouchPhase = {
	Began = 0,
	Canceled = 4,
	Moved = 1,
	Ended = 3,
	Stationary = 2
}
TouchBits = {
	DeltaPosition = 1,
	Position = 2,
	RawPosition = 4,
	ALL = 7
}

local var3_0 = TouchPhase
local var4_0 = TouchBits
local var5_0 = {}
local var6_0 = tolua.initget(var5_0)

function var5_0.__index(arg0_1, arg1_1)
	local var0_1 = var1_0(var5_0, arg1_1)

	if var0_1 == nil then
		var0_1 = var1_0(var6_0, arg1_1)

		if var0_1 ~= nil then
			return var0_1(arg0_1)
		end
	end

	return var0_1
end

function var5_0.New(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2, arg5_2, arg6_2)
	return var2_0({
		fingerId = arg0_2 or 0,
		position = arg1_2 or var0_0,
		rawPosition = arg2_2 or var0_0,
		deltaPosition = arg3_2 or var0_0,
		deltaTime = arg4_2 or 0,
		tapCount = arg5_2 or 0,
		phase = arg6_2 or 0
	}, var5_0)
end

function var5_0.Init(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3, arg7_3)
	arg0_3.fingerId = arg1_3
	arg0_3.position = arg2_3
	arg0_3.rawPosition = arg3_3
	arg0_3.deltaPosition = arg4_3
	arg0_3.deltaTime = arg5_3
	arg0_3.tapCount = arg6_3
	arg0_3.phase = arg7_3
end

function var5_0.Destroy(arg0_4)
	arg0_4.position = nil
	arg0_4.rawPosition = nil
	arg0_4.deltaPosition = nil
end

function var5_0.GetMask(...)
	local var0_5 = {
		...
	}
	local var1_5 = 0

	for iter0_5 = 1, #var0_5 do
		local var2_5 = var4_0[var0_5[iter0_5]] or 0

		if var2_5 ~= 0 then
			var1_5 = var1_5 + var2_5
		end
	end

	if var1_5 == 0 then
		var1_5 = var4_0.all
	end

	return var1_5
end

UnityEngine.TouchPhase = var3_0
UnityEngine.Touch = var5_0

var2_0(var5_0, var5_0)

return var5_0
