local var0_0 = class("ActivitySpStoryNode", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_sp_story
end

var0_0.NODE_TYPE = {
	STORY = 1,
	BATTLE = 2
}

function var0_0.GetType(arg0_2)
	return arg0_2:getConfig("story_type")
end

function var0_0.GetStoryName(arg0_3)
	return arg0_3:getConfig("story")
end

function var0_0.GetDisplayName(arg0_4)
	return arg0_4:getConfig("name")
end

function var0_0.GetPreEvent(arg0_5)
	return arg0_5:getConfig("pre_event")
end

var0_0.CONDITION = {
	TIME = 1,
	PT = 3,
	PASSCHAPTER = 2
}

function var0_0.GetUnlockConditions(arg0_6)
	local var0_6 = arg0_6:getConfig("lock")

	if type(var0_6) ~= "table" then
		return
	end

	return var0_6
end

function var0_0.GetUnlockDesc(arg0_7)
	return arg0_7:getConfig("unlock_conditions")
end

function var0_0.GetCleanBG(arg0_8)
	return arg0_8:getConfig("change_background")
end

function var0_0.GetCleanBGM(arg0_9)
	return arg0_9:getConfig("change_bgm")
end

return var0_0
