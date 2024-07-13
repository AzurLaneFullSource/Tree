local var0_0 = class("PlayerSummaryInfoMediator", import("...base.ContextMediator"))

var0_0.GET_PLAYER_SUMMARY_INFO = "PlayerSummaryInfoMediator:GET_PLAYER_SUMMARY_INFO"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy)

	arg0_1:bind(var0_0.GET_PLAYER_SUMMARY_INFO, function(arg0_2)
		local var0_2 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		if var0_2 and not var0_2:isEnd() then
			arg0_1:sendNotification(GAME.GET_PLAYER_SUMMARY_INFO, {
				activityId = var0_2.id
			})
		end
	end)

	local var1_1 = var0_1:getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

	arg0_1.viewComponent:setActivity(var1_1)

	local var2_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setPlayer(var2_1:getData())

	local var3_1 = var2_1:getSummaryInfo()

	arg0_1.viewComponent:setSummaryInfo(var3_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.GET_PLAYER_SUMMARY_INFO_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.GET_PLAYER_SUMMARY_INFO_DONE then
		arg0_4.viewComponent:setSummaryInfo(var1_4)
		arg0_4.viewComponent:initSummaryInfo()
	end
end

return var0_0
