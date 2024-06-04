local var0 = class("SingleEvent", import("model.vo.BaseVO"))

var0.EVENT_TYPE = {
	DAILY = 2,
	MAIN = 1
}
var0.STORY_TYPE = {
	STORY = 1,
	BATTLE = 2
}
var0.MODE_TYPE = {
	STORY = 1,
	BATTLE = 2
}

function var0.bindConfigTable(arg0)
	return pg.activity_single_event
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
end

function var0.IsMain(arg0)
	return arg0:getConfig("type") == var0.EVENT_TYPE.MAIN
end

function var0.IsDaily(arg0)
	return arg0:getConfig("type") == var0.EVENT_TYPE.DAILY
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetMode(arg0)
	return arg0:getConfig("mode")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetPos(arg0)
	return arg0:getConfig("pos")
end

function var0.GetIconName(arg0)
	return arg0:getConfig("icon")
end

function var0.GetStoryType(arg0)
	return arg0:getConfig("story_type")
end

function var0.GetStory(arg0)
	return arg0:getConfig("story")
end

function var0.GetPreEventId(arg0)
	return arg0:getConfig("pre_event")
end

function var0.GetOptions(arg0)
	return arg0:getConfig("options")
end

function var0.GetMapOptions(arg0)
	return arg0:getConfig("map_options")
end

return var0
