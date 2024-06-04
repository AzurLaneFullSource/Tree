local var0 = class("ActivityBossPtData", import(".ActivityPtData"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	local var0 = arg1:getDataConfig("link_id")
	local var1 = getProxy(ActivityProxy):getActivityById(var0):getConfig("config_id")
	local var2 = pg.activity_event_worldboss[var1]

	assert(var2, "miss activity_event_worldboss config, ID: " .. var1)

	arg0.linkID = var0
	arg0.progress_target = var2.reward_pt
end

function var0.GetBossProgress(arg0)
	local var0 = arg0:getTargetLevel()
	local var1 = getProxy(ActivityProxy):getActivityById(arg0.linkID)
	local var2 = 0

	if var1 and not var1:isEnd() then
		var2 = var1:GetBossHP() or 0
	end

	return var2, arg0.progress_target[var0]
end

function var0.CanGetAward(arg0)
	local function var0()
		local var0, var1, var2 = arg0:GetResProgress()

		return var2 >= 1
	end

	local var1, var2 = arg0:GetBossProgress()

	return arg0:CanGetNextAward() and var0() and var1 <= var2
end

return var0
