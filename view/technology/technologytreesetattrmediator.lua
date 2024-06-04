local var0 = class("TechnologyTreeSetAttrMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH then
		local var2 = var1.onSuccess

		if var2 then
			var2()
		end
	end
end

return var0
