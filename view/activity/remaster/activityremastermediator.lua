local var0_0 = class("ActivityRemasterMediator", import("view.base.ContextMediator"))

var0_0.ACTIVE_ACT = "ActivityRemasterMediator.ACTIVE_ACT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ACTIVE_ACT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_REMASTER_ACTIVE, {
			id = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ACT_REMASTER_ACTIVE_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ACT_REMASTER_ACTIVE_DONE then
		arg0_4.viewComponent:emit(BaseUI.ON_BACK)
	end
end

return var0_0
