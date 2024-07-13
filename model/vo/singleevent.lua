local var0_0 = class("SingleEvent", import("model.vo.BaseVO"))

var0_0.EVENT_TYPE = {
	DAILY = 2,
	MAIN = 1
}
var0_0.STORY_TYPE = {
	STORY = 1,
	BATTLE = 2
}
var0_0.MODE_TYPE = {
	STORY = 1,
	BATTLE = 2
}

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_single_event
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2.id
	arg0_2.configId = arg0_2.id
end

function var0_0.IsMain(arg0_3)
	return arg0_3:getConfig("type") == var0_0.EVENT_TYPE.MAIN
end

function var0_0.IsDaily(arg0_4)
	return arg0_4:getConfig("type") == var0_0.EVENT_TYPE.DAILY
end

function var0_0.GetType(arg0_5)
	return arg0_5:getConfig("type")
end

function var0_0.GetMode(arg0_6)
	return arg0_6:getConfig("mode")
end

function var0_0.GetName(arg0_7)
	return arg0_7:getConfig("name")
end

function var0_0.GetPos(arg0_8)
	return arg0_8:getConfig("pos")
end

function var0_0.GetIconName(arg0_9)
	return arg0_9:getConfig("icon")
end

function var0_0.GetStoryType(arg0_10)
	return arg0_10:getConfig("story_type")
end

function var0_0.GetStory(arg0_11)
	return arg0_11:getConfig("story")
end

function var0_0.GetPreEventId(arg0_12)
	return arg0_12:getConfig("pre_event")
end

function var0_0.GetOptions(arg0_13)
	return arg0_13:getConfig("options")
end

function var0_0.GetMapOptions(arg0_14)
	return arg0_14:getConfig("map_options")
end

return var0_0
