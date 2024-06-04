local var0 = class("BossRushStoryNode", import("model.vo.BaseVO"))

var0.TRIGGER_TYPE = {
	PT_GOT = 1,
	STORY_READED = 3,
	SERIES_PASSED = 2
}
var0.NODE_TYPE = {
	EVENT = 2,
	NORMAL = 1,
	BATTLE = 3
}

function var0.bindConfigTable(arg0)
	return pg.activity_series_enemy_story
end

function var0.Ctor(arg0, arg1, ...)
	var0.super.Ctor(arg0, arg1, ...)

	arg0.configId = arg0.id
end

function var0.GetTriggers(arg0)
	local function var0(arg0)
		if type(arg0) ~= "table" then
			return {}
		end

		return arg0
	end

	local var1 = var0(arg0:getConfig("trigger_type"))
	local var2 = var0(arg0:getConfig("trigger_value"))
	local var3 = {}

	table.Foreach(var1, function(arg0, arg1)
		var3[arg0] = {
			type = var1[arg0],
			value = var2[arg0]
		}
	end)

	return var3
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetIconName(arg0)
	return arg0:getConfig("icon")
end

function var0.GetStory(arg0)
	return arg0:getConfig("story")
end

function var0.GetActiveLink(arg0)
	return arg0:getConfig("line")
end

return var0
