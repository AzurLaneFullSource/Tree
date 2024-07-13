local var0_0 = class("BossRushStoryNode", import("model.vo.BaseVO"))

var0_0.TRIGGER_TYPE = {
	PT_GOT = 1,
	STORY_READED = 3,
	SERIES_PASSED = 2
}
var0_0.NODE_TYPE = {
	EVENT = 2,
	NORMAL = 1,
	BATTLE = 3
}

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_series_enemy_story
end

function var0_0.Ctor(arg0_2, arg1_2, ...)
	var0_0.super.Ctor(arg0_2, arg1_2, ...)

	arg0_2.configId = arg0_2.id
end

function var0_0.GetTriggers(arg0_3)
	local function var0_3(arg0_4)
		if type(arg0_4) ~= "table" then
			return {}
		end

		return arg0_4
	end

	local var1_3 = var0_3(arg0_3:getConfig("trigger_type"))
	local var2_3 = var0_3(arg0_3:getConfig("trigger_value"))
	local var3_3 = {}

	table.Foreach(var1_3, function(arg0_5, arg1_5)
		var3_3[arg0_5] = {
			type = var1_3[arg0_5],
			value = var2_3[arg0_5]
		}
	end)

	return var3_3
end

function var0_0.GetType(arg0_6)
	return arg0_6:getConfig("type")
end

function var0_0.GetName(arg0_7)
	return arg0_7:getConfig("name")
end

function var0_0.GetIconName(arg0_8)
	return arg0_8:getConfig("icon")
end

function var0_0.GetStory(arg0_9)
	return arg0_9:getConfig("story")
end

function var0_0.GetActiveLink(arg0_10)
	return arg0_10:getConfig("line")
end

return var0_0
