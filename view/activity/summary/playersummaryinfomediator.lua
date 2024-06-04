local var0 = class("PlayerSummaryInfoMediator", import("...base.ContextMediator"))

var0.GET_PLAYER_SUMMARY_INFO = "PlayerSummaryInfoMediator:GET_PLAYER_SUMMARY_INFO"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy)

	arg0:bind(var0.GET_PLAYER_SUMMARY_INFO, function(arg0)
		local var0 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

		if var0 and not var0:isEnd() then
			arg0:sendNotification(GAME.GET_PLAYER_SUMMARY_INFO, {
				activityId = var0.id
			})
		end
	end)

	local var1 = var0:getActivityByType(ActivityConst.ACTIVITY_TYPE_SUMMARY)

	arg0.viewComponent:setActivity(var1)

	local var2 = getProxy(PlayerProxy)

	arg0.viewComponent:setPlayer(var2:getData())

	local var3 = var2:getSummaryInfo()

	arg0.viewComponent:setSummaryInfo(var3)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.GET_PLAYER_SUMMARY_INFO_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.GET_PLAYER_SUMMARY_INFO_DONE then
		arg0.viewComponent:setSummaryInfo(var1)
		arg0.viewComponent:initSummaryInfo()
	end
end

return var0
