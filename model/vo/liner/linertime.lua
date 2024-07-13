local var0_0 = class("LinerTime", import("model.vo.BaseVO"))

var0_0.TYPE = {
	TARGET = 1,
	EXPLORE = 2,
	STORY = 4,
	EVENT = 3
}
var0_0.EVENT_SUB_TYPE = {
	STORY = 2,
	CLUE = 1
}
var0_0.BG_TYPE = {
	DAY = "day",
	DUSK = "dusk",
	AURORA = "aurora",
	NIGTH = "night"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_liner_time
end

function var0_0.GetTime(arg0_3)
	return arg0_3:getConfig("time")
end

function var0_0.GetStartTimeDesc(arg0_4)
	local var0_4 = arg0_4:GetTime()[1]
	local var1_4 = var0_4 < 12 and "AM" or "PM"

	if var0_4 > 12 then
		var0_4 = var0_4 - 12
	end

	return var0_4 .. ":00 " .. var1_4
end

function var0_0.GetEndTimeDesc(arg0_5)
	local var0_5 = arg0_5:GetTime()[2]
	local var1_5 = var0_5 < 12 and "AM" or "PM"

	if var0_5 > 12 then
		var0_5 = var0_5 - 12
	end

	return var0_5 .. ":00 " .. var1_5
end

function var0_0.GetLogDesc(arg0_6)
	local var0_6 = arg0_6:GetTime()[1]
	local var1_6 = arg0_6:GetTime()[2] - 1
	local var2_6 = var0_6 < 12 and "AM" or "PM"
	local var3_6 = var1_6 < 12 and "AM" or "PM"
	local var4_6

	var4_6, var1_6 = var0_6 > 12 and var0_6 - 12 or var0_6, var1_6 > 12 and var1_6 - 12 or var1_6

	return string.format("%d:00 %s~%d:59 %s", var4_6, var2_6, var1_6, var3_6)
end

function var0_0.GetType(arg0_7)
	return arg0_7:getConfig("type")
end

function var0_0.GetEventSubType(arg0_8, arg1_8)
	assert(arg0_8:GetType() == var0_0.TYPE.EVENT, "error type")

	local var0_8 = underscore.detect(arg0_8:GetParamInfo(), function(arg0_9)
		return arg0_9[1] == arg1_8
	end)

	assert(var0_8, "error roomId")

	return var0_8[2]
end

function var0_0.GetParamInfo(arg0_10)
	return arg0_10:getConfig("param")
end

function var0_0.GetTargetRoomIds(arg0_11)
	local var0_11 = {}

	switch(arg0_11:GetType(), {
		[var0_0.TYPE.TARGET] = function()
			table.insert(var0_11, tonumber(arg0_11:GetParamInfo()[1]))
		end,
		[var0_0.TYPE.EXPLORE] = function()
			return
		end,
		[var0_0.TYPE.EVENT] = function()
			for iter0_14, iter1_14 in ipairs(arg0_11:GetParamInfo()) do
				table.insert(var0_11, iter1_14[1])
			end
		end,
		[var0_0.TYPE.STORY] = function()
			table.insert(var0_11, tonumber(arg0_11:GetParamInfo()[1]))
		end
	})

	return var0_11
end

function var0_0.GetExploreCnt(arg0_16)
	if arg0_16:GetType() ~= var0_0.TYPE.EXPLORE then
		return 0
	end

	return tonumber(arg0_16:GetParamInfo())
end

function var0_0.GetEventIds(arg0_17)
	if arg0_17:GetType() ~= var0_0.TYPE.EVENT then
		return {}
	end

	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17:GetParamInfo()) do
		var0_17 = table.mergeArray(var0_17, iter1_17[4], true)
	end

	return var0_17
end

function var0_0.GetStory(arg0_18, arg1_18)
	local var0_18 = ""

	switch(arg0_18:GetType(), {
		[var0_0.TYPE.TARGET] = function()
			var0_18 = arg0_18:GetParamInfo()[2]
		end,
		[var0_0.TYPE.EXPLORE] = function()
			return
		end,
		[var0_0.TYPE.EVENT] = function()
			local var0_21 = underscore.detect(arg0_18:GetParamInfo(), function(arg0_22)
				return arg0_22[1] == arg1_18
			end)

			if var0_21 and var0_21[2] == var0_0.EVENT_SUB_TYPE.STORY then
				var0_18 = var0_21[3]
			end
		end,
		[var0_0.TYPE.STORY] = function()
			var0_18 = arg0_18:GetParamInfo()[2]
		end
	})

	return var0_18
end

function var0_0.GetBeforDesc(arg0_24, arg1_24)
	local var0_24 = arg0_24:getConfig("desc_before")

	if type(var0_24) == "table" then
		return HXSet.hxLan(var0_24[arg1_24][1])
	else
		return HXSet.hxLan(var0_24)
	end
end

function var0_0.GetAfterDesc(arg0_25, arg1_25)
	local var0_25 = arg0_25:getConfig("desc_after")

	if type(var0_25) == "table" then
		return HXSet.hxLan(var0_25[arg1_25][1])
	else
		return HXSet.hxLan(var0_25)
	end
end

function var0_0.GetBgType(arg0_26)
	return arg0_26:getConfig("bg_name")
end

function var0_0.GetBgm(arg0_27, arg1_27)
	local var0_27 = arg1_27 or arg0_27:GetBgType()
	local var1_27 = "story-niceship-soft"

	switch(var0_27, {
		[var0_0.BG_TYPE.DAY] = function()
			var1_27 = "story-niceship-soft"
		end,
		[var0_0.BG_TYPE.DUSK] = function()
			var1_27 = "story-richang-5"
		end,
		[var0_0.BG_TYPE.NIGTH] = function()
			var1_27 = "story-richang-10"
		end,
		[var0_0.BG_TYPE.AURORA] = function()
			var1_27 = "story-richang-quiet"
		end
	})

	return var1_27
end

return var0_0
