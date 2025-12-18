local var0_0 = class("ActivitySpStoryNode", import("model.vo.BaseVO"))

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_sp_story
end

var0_0.NODE_TYPE = {
	BATTLE = 2,
	UNRELEASED = 99,
	STORY = 1,
	OPTION_BRANCH = 3
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

function var0_0.IsOptionNode(arg0_6)
	local var0_6 = arg0_6:GetUnlockConditions()
	local var1_6

	_.each(var0_6, function(arg0_7)
		if arg0_7[1] == var0_0.CONDITION.PRE_OPTION then
			var1_6 = true
		end
	end)

	return var1_6
end

function var0_0.GetPreEvent(arg0_8)
	local var0_8 = arg0_8:GetUnlockConditions()
	local var1_8 = _.detect(var0_8, function(arg0_9)
		return arg0_9[1] == var0_0.CONDITION.PRE_PASSED or arg0_9[1] == var0_0.CONDITION.PRE_OPTION
	end)

	if var1_8 and var1_8[2] and var1_8[2] > 0 then
		return var1_8[2]
	end

	return 0
end

var0_0.CONDITION = {
	PT = 3,
	PRE_PASSED = 4,
	PASSCHAPTER = 2,
	PRE_OPTION = 5,
	TIME = 1
}

function var0_0.GetUnlockConditions(arg0_10)
	local var0_10 = arg0_10:getConfig("lock")

	if type(var0_10) ~= "table" then
		return {}
	end

	return var0_10
end

function var0_0.GetUnlockDesc(arg0_11)
	return arg0_11:getConfig("unlock_conditions")
end

function var0_0.GetCleanBG(arg0_12)
	return arg0_12:getConfig("change_background")
end

function var0_0.GetCleanBGM(arg0_13)
	return arg0_13:getConfig("change_bgm")
end

function var0_0.GetCleanAnimator(arg0_14)
	local var0_14 = arg0_14:getConfig("change_prefab")

	if var0_14 == "" then
		var0_14 = nil
	end

	return var0_14
end

function var0_0.GetOptionBranchByStoryName(arg0_15, arg1_15)
	local var0_15 = pg.activity_sp_story
	local var1_15

	for iter0_15, iter1_15 in pairs(var0_15) do
		if iter1_15.story == arg0_15 then
			var1_15 = iter0_15
		end
	end

	local var2_15

	for iter2_15, iter3_15 in pairs(var0_15) do
		if iter3_15.lock then
			_.each(iter3_15.lock, function(arg0_16)
				if arg0_16[1] == var0_0.CONDITION.PRE_OPTION and arg0_16[2] == var1_15 and arg0_16[3] == arg1_15 then
					var2_15 = iter3_15
				end
			end)
		end
	end

	return var2_15
end

return var0_0
