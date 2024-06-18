local var0_0 = class("ActivityBeUpdatedCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.activity
	local var2_1 = var0_1.isInit

	if var1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_INSTAGRAM then
		if var1_1:CanBeActivated() then
			getProxy(ActivityProxy):AddInstagramTimer(var1_1.id)
		end
	elseif not var2_1 and var1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0_1:IsLinkVoteAct(var1_1) then
		local var3_1 = ActivityPtData.New(var1_1)

		if var3_1:CanGetAward() then
			local var4_1 = var3_1:GetCurrTarget()

			arg0_1:sendNotification(GAME.ACT_NEW_PT, {
				cmd = 4,
				activity_id = var3_1:GetId(),
				arg1 = var4_1
			})
		end
	elseif var2_1 and var1_1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT then
		local var5_1 = var1_1:GetCollectionList()

		getProxy(EventProxy):AddActivityEvents(var5_1, var1_1.id)
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
