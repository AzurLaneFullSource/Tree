local var0_0 = class("EducateCollectMediatorTemplate", import("..base.EducateContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		EducateProxy.CLEAR_NEW_TIP
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == EducateProxy.CLEAR_NEW_TIP and (var1_3.index == EducateTipHelper.NEW_MEMORY or var1_3.index == EducateTipHelper.NEW_POLAROID) then
		arg0_3.viewComponent:updatePage()
	end
end

return var0_0
