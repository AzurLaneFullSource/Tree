local var0 = rawget
local var1 = UnityEngine.Time
local var2 = tolua.gettime
local var3 = {
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
local var4 = {
	fixedDeltaTime = function(arg0)
		var3.fixedDeltaTime = arg0
		var1.fixedDeltaTime = arg0
	end,
	maximumDeltaTime = function(arg0)
		var3.maximumDeltaTime = arg0
		var1.maximumDeltaTime = arg0
	end,
	timeScale = function(arg0)
		var3.timeScale = arg0
		var1.timeScale = arg0
	end,
	captureFramerate = function(arg0)
		var3.captureFramerate = arg0
		var1.captureFramerate = arg0
	end,
	timeSinceLevelLoad = function(arg0)
		var3.timeSinceLevelLoad = arg0
	end
}

function var3.__index(arg0, arg1)
	local var0 = var0(var3, arg1)

	if var0 then
		return var0
	end

	return var1.__index(var1, arg1)
end

function var3.__newindex(arg0, arg1, arg2)
	local var0 = var0(var4, arg1)

	if var0 then
		return var0(arg2)
	end

	error(string.format("Property or indexer `UnityEngine.Time.%s' cannot be assigned to (it is read only)", arg1))
end

local var5 = {}
local var6 = 1

function var5.SetDeltaTime(arg0, arg1, arg2)
	local var0 = var3

	var0.deltaTime = arg1
	var0.unscaledDeltaTime = arg2
	var6 = var6 - 1

	if var6 == 0 and var1 then
		var0.time = var1.time
		var0.timeSinceLevelLoad = var1.timeSinceLevelLoad
		var0.unscaledTime = var1.unscaledTime
		var0.realtimeSinceStartup = var1.realtimeSinceStartup
		var0.frameCount = var1.frameCount
		var6 = 1000000
	else
		var0.time = var0.time + arg1
		var0.realtimeSinceStartup = var0.realtimeSinceStartup + arg2
		var0.timeSinceLevelLoad = var0.timeSinceLevelLoad + arg1
		var0.unscaledTime = var0.unscaledTime + arg2
	end
end

function var5.SetFixedDelta(arg0, arg1)
	var3.deltaTime = arg1
	var3.fixedDeltaTime = arg1
	var3.fixedTime = var3.fixedTime + arg1
end

function var5.SetFrameCount(arg0)
	var3.frameCount = var3.frameCount + 1
end

function var5.SetTimeScale(arg0, arg1)
	local var0 = var3.timeScale

	var3.timeScale = arg1
	var1.timeScale = arg1

	return var0
end

function var5.GetTimestamp(arg0)
	return var2()
end

UnityEngine.Time = var5

setmetatable(var5, var3)

if var1 ~= nil then
	var3.maximumDeltaTime = var1.maximumDeltaTime
	var3.timeScale = var1.timeScale
end

return var5
