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

function var0_0.GetPreNodes(arg0_5)
	local var0_5 = arg0_5:getConfig("pre_event")

	if type(var0_5) ~= "table" then
		return {}
	end

	return var0_5
end

function var0_0.GetPreEvent(arg0_6)
	local var0_6 = arg0_6:GetUnlockConditions()
	local var1_6 = _.detect(var0_6, function(arg0_7)
		return arg0_7[1] == var0_0.CONDITION.PRE_PASSED
	end)

	if var1_6 and var1_6[2] and var1_6[2] > 0 then
		return var1_6[2]
	end

	return 0
end

var0_0.CONDITION = {
	PRE_PASSED = 4,
	PT = 3,
	TIME = 1,
	PASSCHAPTER = 2
}

function var0_0.GetUnlockConditions(arg0_8)
	local var0_8 = arg0_8:getConfig("lock")

	if type(var0_8) ~= "table" then
		return {}
	end

	return var0_8
end

function var0_0.GetUnlockDesc(arg0_9)
	return arg0_9:getConfig("unlock_conditions")
end

function var0_0.GetCleanBG(arg0_10)
	return arg0_10:getConfig("change_background")
end

function var0_0.GetCleanBGM(arg0_11)
	return arg0_11:getConfig("change_bgm")
end

function var0_0.GetCleanAnimator(arg0_12)
	local var0_12 = arg0_12:getConfig("change_prefab")

	if var0_12 == "" then
		var0_12 = nil
	end

	return var0_12
end

return var0_0
