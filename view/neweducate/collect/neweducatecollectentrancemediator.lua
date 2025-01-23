local var0_0 = class("NewEducateCollectEntranceMediator", import("view.base.ContextMediator"))

var0_0.GO_SUBLAYER = "NewEducateCollectEntranceMediator.GO_SUBLAYER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(arg1_2, nil, arg2_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		EducateProxy.CLEAR_NEW_TIP
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == EducateProxy.CLEAR_NEW_TIP and var1_4.index == EducateTipHelper.NEW_MEMORY then
		arg0_4.viewComponent:UpdateMemoryTip()
	end
end

return var0_0
