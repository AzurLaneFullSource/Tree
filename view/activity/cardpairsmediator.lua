local var0_0 = class("CardPairsMediator", import("..base.ContextMediator"))

var0_0.EVENT_OPERATION = "event operation"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_2)
	end)
	arg0_1:setActivityData()
	arg0_1:setPlayerData()
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ActivityProxy.ACTIVITY_UPDATED then
		arg0_4.viewComponent:setActivityData(var1_4)
	elseif var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:setPlayerData(var1_4)
	elseif var0_4 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
	elseif var0_4 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_4.viewComponent:checkActivityEnd()
	end
end

function var0_0.setPlayerData(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getData()

	arg0_5.viewComponent:setPlayerData(var0_5)
end

function var0_0.setActivityData(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CARD_PAIRS)

	arg0_6.viewComponent:setActivityData(var0_6)
end

return var0_0
