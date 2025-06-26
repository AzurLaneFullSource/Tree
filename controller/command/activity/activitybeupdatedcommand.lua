local var0_0 = class("ActivityBeUpdatedCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activity

	if var0_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0_1:IsLinkVoteAct(var0_1) then
		local var1_1 = ActivityPtData.New(var0_1)

		if var1_1:CanGetAward() then
			local var2_1 = var1_1:GetCurrTarget()

			arg0_1:sendNotification(GAME.ACT_NEW_PT, {
				cmd = 4,
				activity_id = var1_1:GetId(),
				arg1 = var2_1
			})
		end
	end
end

function var0_0.IsLinkVoteAct(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if var0_2 and not var0_2:isEnd() then
		local var1_2 = var0_2:getConfig("config_client")[1]

		return arg1_2.id == var1_2
	end

	return false
end

return var0_0
