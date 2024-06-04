local var0 = Vector2.zero
local var1 = rawget
local var2 = setmetatable

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

local var3 = TouchPhase
local var4 = TouchBits
local var5 = {}
local var6 = tolua.initget(var5)

function var5.__index(arg0, arg1)
	local var0 = var1(var5, arg1)

	if var0 == nil then
		var0 = var1(var6, arg1)

		if var0 ~= nil then
			return var0(arg0)
		end
	end

	return var0
end

function var5.New(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	return var2({
		fingerId = arg0 or 0,
		position = arg1 or var0,
		rawPosition = arg2 or var0,
		deltaPosition = arg3 or var0,
		deltaTime = arg4 or 0,
		tapCount = arg5 or 0,
		phase = arg6 or 0
	}, var5)
end

function var5.Init(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	arg0.fingerId = arg1
	arg0.position = arg2
	arg0.rawPosition = arg3
	arg0.deltaPosition = arg4
	arg0.deltaTime = arg5
	arg0.tapCount = arg6
	arg0.phase = arg7
end

function var5.Destroy(arg0)
	arg0.position = nil
	arg0.rawPosition = nil
	arg0.deltaPosition = nil
end

function var5.GetMask(...)
	local var0 = {
		...
	}
	local var1 = 0

	for iter0 = 1, #var0 do
		local var2 = var4[var0[iter0]] or 0

		if var2 ~= 0 then
			var1 = var1 + var2
		end
	end

	if var1 == 0 then
		var1 = var4.all
	end

	return var1
end

UnityEngine.TouchPhase = var3
UnityEngine.Touch = var5

var2(var5, var5)

return var5
