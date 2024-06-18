local var0_0 = class("RedPacketMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS then
		arg0_3.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_3.awards, var1_3.callback)
	elseif var0_3 == ActivityProxy.ACTIVITY_UPDATED and var1_3.id == arg0_3.viewComponent.activityID then
		arg0_3.viewComponent:onSubmitFinished()
	end
end

return var0_0
