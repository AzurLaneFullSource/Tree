local var0 = class("EducateCollectEntranceMediator", import("..base.EducateContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		EducateProxy.CLEAR_NEW_TIP
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == EducateProxy.CLEAR_NEW_TIP and var1.index == EducateTipHelper.NEW_MEMORY then
		arg0.viewComponent:updateMemoryTip()
	end
end

return var0
