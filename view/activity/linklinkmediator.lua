local var0 = class("LinkLinkMediator", import("..base.ContextMediator"))

var0.EVENT_OPERATION = "event operation"

function var0.register(arg0)
	arg0:bind(var0.EVENT_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, arg1)
	end)
	arg0:SetActivityData()
	arg0:SetPlayerData()
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

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayer(var1)
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var2 = getProxy(ActivityProxy):getActivityById(var1)

		if var2:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
			arg0.viewComponent:DisplayResult(var2)
		end
	end
end

function var0.SetPlayerData(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.viewComponent:SetPlayer(var0)
end

function var0.SetActivityData(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINK_LINK)

	arg0.viewComponent:SetActivity(var0)
end

return var0
