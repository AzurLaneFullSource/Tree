local var0_0 = rawget
local var1_0 = UnityEngine.Time
local var2_0 = tolua.gettime
local var3_0 = {
	maximumDeltaTime = 0.3333333,
	frameCount = 1,
	time = 0,
	fixedDeltaTime = 0,
	unscaledTime = 0,
	deltaTime = 0,
	timeSinceLevelLoad = 0,
	realtimeSinceStartup = 0,
	unscaledDeltaTime = 0,
	timeScale = 1,
	fixedTime = 0
}
local var4_0 = {
	fixedDeltaTime = function(arg0_1)
		var3_0.fixedDeltaTime = arg0_1
		var1_0.fixedDeltaTime = arg0_1
	end,
	maximumDeltaTime = function(arg0_2)
		var3_0.maximumDeltaTime = arg0_2
		var1_0.maximumDeltaTime = arg0_2
	end,
	timeScale = function(arg0_3)
		var3_0.timeScale = arg0_3
		var1_0.timeScale = arg0_3
	end,
	captureFramerate = function(arg0_4)
		var3_0.captureFramerate = arg0_4
		var1_0.captureFramerate = arg0_4
	end,
	timeSinceLevelLoad = function(arg0_5)
		var3_0.timeSinceLevelLoad = arg0_5
	end
}

function var3_0.__index(arg0_6, arg1_6)
	local var0_6 = var0_0(var3_0, arg1_6)

	if var0_6 then
		return var0_6
	end

	return var1_0.__index(var1_0, arg1_6)
end

function var3_0.__newindex(arg0_7, arg1_7, arg2_7)
	local var0_7 = var0_0(var4_0, arg1_7)

	if var0_7 then
		return var0_7(arg2_7)
	end

	error(string.format("Property or indexer `UnityEngine.Time.%s' cannot be assigned to (it is read only)", arg1_7))
end

local var5_0 = {}
local var6_0 = 1

function var5_0.SetDeltaTime(arg0_8, arg1_8, arg2_8)
	local var0_8 = var3_0

	var0_8.deltaTime = arg1_8
	var0_8.unscaledDeltaTime = arg2_8
	var6_0 = var6_0 - 1

	if var6_0 == 0 and var1_0 then
		var0_8.time = var1_0.time
		var0_8.timeSinceLevelLoad = var1_0.timeSinceLevelLoad
		var0_8.unscaledTime = var1_0.unscaledTime
		var0_8.realtimeSinceStartup = var1_0.realtimeSinceStartup
		var0_8.frameCount = var1_0.frameCount
		var6_0 = 1000000
	else
		var0_8.time = var0_8.time + arg1_8
		var0_8.realtimeSinceStartup = var0_8.realtimeSinceStartup + arg2_8
		var0_8.timeSinceLevelLoad = var0_8.timeSinceLevelLoad + arg1_8
		var0_8.unscaledTime = var0_8.unscaledTime + arg2_8
	end
end

function var5_0.SetFixedDelta(arg0_9, arg1_9)
	var3_0.deltaTime = arg1_9
	var3_0.fixedDeltaTime = arg1_9
	var3_0.fixedTime = var3_0.fixedTime + arg1_9
end

function var5_0.SetFrameCount(arg0_10)
	var3_0.frameCount = var3_0.frameCount + 1
end

function var5_0.SetTimeScale(arg0_11, arg1_11)
	local var0_11 = var3_0.timeScale

	var3_0.timeScale = arg1_11
	var1_0.timeScale = arg1_11

	return var0_11
end

function var5_0.GetTimestamp(arg0_12)
	return var2_0()
end

UnityEngine.Time = var5_0

setmetatable(var5_0, var3_0)

if var1_0 ~= nil then
	var3_0.maximumDeltaTime = var1_0.maximumDeltaTime
	var3_0.timeScale = var1_0.timeScale
end

return var5_0
