local var0 = class("ActivityBeUpdatedCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.activity
	local var2 = var0.isInit

	if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_INSTAGRAM then
		if var1:CanBeActivated() then
			getProxy(ActivityProxy):AddInstagramTimer(var1.id)
		end
	elseif not var2 and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_PT_BUFF and arg0:IsLinkVoteAct(var1) then
		local var3 = ActivityPtData.New(var1)

		if var3:CanGetAward() then
			local var4 = var3:GetCurrTarget()

			arg0:sendNotification(GAME.ACT_NEW_PT, {
				cmd = 4,
				activity_id = var3:GetId(),
				arg1 = var4
			})
		end
	elseif var2 and var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_COLLECTION_EVENT then
		local var5 = var1:GetCollectionList()

		getProxy(EventProxy):AddActivityEvents(var5, var1.id)
	end
end

function var0.IsLinkVoteAct(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.VOTE_ENTRANCE_ACT_ID)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_client")[1]

		return arg1.id == var1
	end

	return false
end

return var0
