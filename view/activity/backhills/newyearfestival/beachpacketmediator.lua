local var0_0 = class("BeachPacketMediator", import("view.base.ContextMediator"))

function var0_0.listNotificationInterests(arg0_1)
	return {
		ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_2, arg1_2)
	local var0_2 = arg1_2:getName()
	local var1_2 = arg1_2:getBody()

	if var0_2 == ActivityProxy.ACTIVITY_SHOW_RED_PACKET_AWARDS then
		arg0_2.viewComponent:playAni(function()
			arg0_2.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_2.awards, var1_2.callback)
		end)
	elseif var0_2 == ActivityProxy.ACTIVITY_UPDATED and var1_2.id == arg0_2.viewComponent.activityID then
		arg0_2.viewComponent:onSubmitFinished()
	end
end

return var0_0
