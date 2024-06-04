local var0 = class("CardPairsMediator", import("..base.ContextMediator"))

var0.EVENT_OPERATION = "event operation"

function var0.register(arg0)
	arg0:bind(var0.EVENT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:setActivityData()
	arg0:setPlayerData()
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		ActivityProxy.ACTIVITY_OPERATION_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		arg0.viewComponent:setActivityData(var1)
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerData(var1)
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0.viewComponent:checkActivityEnd()
	end
end

function var0.setPlayerData(arg0)
	local var0 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayerData(var0)
end

function var0.setActivityData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_CARD_PAIRS)

	arg0.viewComponent:setActivityData(var0)
end

return var0
