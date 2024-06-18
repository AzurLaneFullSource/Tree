local var0_0 = class("LinkLinkMediator", import("..base.ContextMediator"))

var0_0.EVENT_OPERATION = "event operation"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, arg1_2)
	end)
	arg0_1:SetActivityData()
	arg0_1:SetPlayerData()
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

	if var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:SetPlayer(var1_4)
	elseif var0_4 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
	elseif var0_4 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		local var2_4 = getProxy(ActivityProxy):getActivityById(var1_4)

		if var2_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LINK_LINK then
			arg0_4.viewComponent:DisplayResult(var2_4)
		end
	end
end

function var0_0.SetPlayerData(arg0_5)
	local var0_5 = getProxy(PlayerProxy):getRawData()

	arg0_5.viewComponent:SetPlayer(var0_5)
end

function var0_0.SetActivityData(arg0_6)
	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_LINK_LINK)

	arg0_6.viewComponent:SetActivity(var0_6)
end

return var0_0
