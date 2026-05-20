local var0_0 = class("MallStaffMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.ACTIVITY_MALL_OP_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.ACTIVITY_MALL_OP_DONE then
		arg0_3.viewComponent:UpdateData()
		arg0_3.viewComponent:UpdateView()
	end
end

return var0_0
