local var0 = class("RedPacketMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1.id == arg0.viewComponent.activityID then
		arg0.viewComponent:onSubmitFinished()
	end
end

return var0
