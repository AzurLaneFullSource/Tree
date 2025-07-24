local var0_0 = class("BossRushStoryNode", import("model.vo.BaseVO"))

var0_0.TRIGGER_TYPE = {
	PT_GOT = 1,
	HIDE_READED = 4,
	STORY_READED = 3,
	SERIES_PASSED = 2
}
var0_0.NODE_TYPE = {
	NORMAL = 1,
	EVENT = 2,
	LOCATION = 4,
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

	for iter0_3 = 1, #var1_3 do
		table.insert(var3_3, {
			type = var1_3[iter0_3],
			value = var2_3[iter0_3]
		})
	end

	return var3_3
end

function var0_0.IsActive(arg0_5, arg1_5, arg2_5)
	return underscore.all(arg0_5:GetTriggers(), function(arg0_6)
		return switch(arg0_6.type, {
			[var0_0.TRIGGER_TYPE.PT_GOT] = function()
				return arg2_5.data1 >= arg0_6.value
			end,
			[var0_0.TRIGGER_TYPE.SERIES_PASSED] = function()
				return BossRushSeriesData.New({
					id = arg0_6.value,
					actId = arg1_5.id
				}):IsUnlock(arg1_5)
			end,
			[var0_0.TRIGGER_TYPE.STORY_READED] = function()
				return var0_0.New({
					id = arg0_6.value
				}):IsReaded()
			end,
			[var0_0.TRIGGER_TYPE.HIDE_READED] = function()
				return not var0_0.New({
					id = arg0_6.value
				}):IsReaded()
			end
		}, function()
			return false
		end)
	end)
end

function var0_0.IsReaded(arg0_12)
	local var0_12 = arg0_12:GetStory()

	if var0_12 and var0_12 ~= "" then
		return tobool(pg.NewStoryMgr.GetInstance():IsPlayed(var0_12))
	else
		return true
	end
end

function var0_0.GetType(arg0_13)
	return arg0_13:getConfig("type")
end

function var0_0.GetName(arg0_14)
	return arg0_14:getConfig("name")
end

function var0_0.GetIconName(arg0_15)
	return arg0_15:getConfig("icon")
end

function var0_0.GetStory(arg0_16)
	return arg0_16:getConfig("story")
end

function var0_0.GetActiveLink(arg0_17)
	return arg0_17:getConfig("line")
end

function var0_0.GetCleanBG(arg0_18)
	return noEmptyStr(arg0_18:getConfig("change_background"))
end

function var0_0.GetCleanBGM(arg0_19)
	return noEmptyStr(arg0_19:getConfig("change_bgm"))
end

function var0_0.GetCleanAnimator(arg0_20)
	return noEmptyStr(arg0_20:getConfig("change_prefab"))
end

function var0_0.GetParams(arg0_21, arg1_21)
	local var0_21 = noEmptyStr(arg0_21:getConfig("params"))

	if not var0_21 then
		return nil
	end

	for iter0_21, iter1_21 in ipairs(var0_21) do
		if iter1_21[1] == arg1_21 then
			return iter1_21
		end
	end

	return nil
end

return var0_0
