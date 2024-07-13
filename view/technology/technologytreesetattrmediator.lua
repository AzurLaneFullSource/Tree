local var0_0 = class("TechnologyTreeSetAttrMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH then
		local var2_3 = var1_3.onSuccess

		if var2_3 then
			var2_3()
		end
	end
end

return var0_0
