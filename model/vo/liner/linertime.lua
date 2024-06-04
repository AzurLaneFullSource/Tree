local var0 = class("LinerTime", import("model.vo.BaseVO"))

var0.TYPE = {
	TARGET = 1,
	EXPLORE = 2,
	STORY = 4,
	EVENT = 3
}
var0.EVENT_SUB_TYPE = {
	STORY = 2,
	CLUE = 1
}
var0.BG_TYPE = {
	DAY = "day",
	DUSK = "dusk",
	AURORA = "aurora",
	NIGTH = "night"
}

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_time
end

function var0.GetTime(arg0)
	return arg0:getConfig("time")
end

function var0.GetStartTimeDesc(arg0)
	local var0 = arg0:GetTime()[1]
	local var1 = var0 < 12 and "AM" or "PM"

	if var0 > 12 then
		var0 = var0 - 12
	end

	return var0 .. ":00 " .. var1
end

function var0.GetEndTimeDesc(arg0)
	local var0 = arg0:GetTime()[2]
	local var1 = var0 < 12 and "AM" or "PM"

	if var0 > 12 then
		var0 = var0 - 12
	end

	return var0 .. ":00 " .. var1
end

function var0.GetLogDesc(arg0)
	local var0 = arg0:GetTime()[1]
	local var1 = arg0:GetTime()[2] - 1
	local var2 = var0 < 12 and "AM" or "PM"
	local var3 = var1 < 12 and "AM" or "PM"
	local var4

	var4, var1 = var0 > 12 and var0 - 12 or var0, var1 > 12 and var1 - 12 or var1

	return string.format("%d:00 %s~%d:59 %s", var4, var2, var1, var3)
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetEventSubType(arg0, arg1)
	assert(arg0:GetType() == var0.TYPE.EVENT, "error type")

	local var0 = underscore.detect(arg0:GetParamInfo(), function(arg0)
		return arg0[1] == arg1
	end)

	assert(var0, "error roomId")

	return var0[2]
end

function var0.GetParamInfo(arg0)
	return arg0:getConfig("param")
end

function var0.GetTargetRoomIds(arg0)
	local var0 = {}

	switch(arg0:GetType(), {
		[var0.TYPE.TARGET] = function()
			table.insert(var0, tonumber(arg0:GetParamInfo()[1]))
		end,
		[var0.TYPE.EXPLORE] = function()
			return
		end,
		[var0.TYPE.EVENT] = function()
			for iter0, iter1 in ipairs(arg0:GetParamInfo()) do
				table.insert(var0, iter1[1])
			end
		end,
		[var0.TYPE.STORY] = function()
			table.insert(var0, tonumber(arg0:GetParamInfo()[1]))
		end
	})

	return var0
end

function var0.GetExploreCnt(arg0)
	if arg0:GetType() ~= var0.TYPE.EXPLORE then
		return 0
	end

	return tonumber(arg0:GetParamInfo())
end

function var0.GetEventIds(arg0)
	if arg0:GetType() ~= var0.TYPE.EVENT then
		return {}
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0:GetParamInfo()) do
		var0 = table.mergeArray(var0, iter1[4], true)
	end

	return var0
end

function var0.GetStory(arg0, arg1)
	local var0 = ""

	switch(arg0:GetType(), {
		[var0.TYPE.TARGET] = function()
			var0 = arg0:GetParamInfo()[2]
		end,
		[var0.TYPE.EXPLORE] = function()
			return
		end,
		[var0.TYPE.EVENT] = function()
			local var0 = underscore.detect(arg0:GetParamInfo(), function(arg0)
				return arg0[1] == arg1
			end)

			if var0 and var0[2] == var0.EVENT_SUB_TYPE.STORY then
				var0 = var0[3]
			end
		end,
		[var0.TYPE.STORY] = function()
			var0 = arg0:GetParamInfo()[2]
		end
	})

	return var0
end

function var0.GetBeforDesc(arg0, arg1)
	local var0 = arg0:getConfig("desc_before")

	if type(var0) == "table" then
		return HXSet.hxLan(var0[arg1][1])
	else
		return HXSet.hxLan(var0)
	end
end

function var0.GetAfterDesc(arg0, arg1)
	local var0 = arg0:getConfig("desc_after")

	if type(var0) == "table" then
		return HXSet.hxLan(var0[arg1][1])
	else
		return HXSet.hxLan(var0)
	end
end

function var0.GetBgType(arg0)
	return arg0:getConfig("bg_name")
end

function var0.GetBgm(arg0, arg1)
	local var0 = arg1 or arg0:GetBgType()
	local var1 = "story-niceship-soft"

	switch(var0, {
		[var0.BG_TYPE.DAY] = function()
			var1 = "story-niceship-soft"
		end,
		[var0.BG_TYPE.DUSK] = function()
			var1 = "story-richang-5"
		end,
		[var0.BG_TYPE.NIGTH] = function()
			var1 = "story-richang-10"
		end,
		[var0.BG_TYPE.AURORA] = function()
			var1 = "story-richang-quiet"
		end
	})

	return var1
end

return var0
