local var0_0 = class("ActivityBossPtData", import(".ActivityPtData"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg1_1:getDataConfig("link_id")
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1):getConfig("config_id")
	local var2_1 = pg.activity_event_worldboss[var1_1]

	assert(var2_1, "miss activity_event_worldboss config, ID: " .. var1_1)

	arg0_1.linkID = var0_1
	arg0_1.progress_target = var2_1.reward_pt
end

function var0_0.GetBossProgress(arg0_2)
	local var0_2 = arg0_2:getTargetLevel()
	local var1_2 = getProxy(ActivityProxy):getActivityById(arg0_2.linkID)
	local var2_2 = 0

	if var1_2 and not var1_2:isEnd() then
		var2_2 = var1_2:GetBossHP() or 0
	end

	return var2_2, arg0_2.progress_target[var0_2]
end

function var0_0.CanGetAward(arg0_3)
	local function var0_3()
		local var0_4, var1_4, var2_4 = arg0_3:GetResProgress()

		return var2_4 >= 1
	end

	local var1_3, var2_3 = arg0_3:GetBossProgress()

	return arg0_3:CanGetNextAward() and var0_3() and var1_3 <= var2_3
end

return var0_0
