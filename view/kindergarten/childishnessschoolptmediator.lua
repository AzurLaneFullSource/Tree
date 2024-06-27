local var0_0 = class("ChildishnessSchoolPtMediator", import("view.base.ContextMediator"))

var0_0.EVENT_PT_OPERATION = "event pt op"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_PT_OPERATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.ACT_NEW_PT_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.ACT_NEW_PT_DONE then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
		arg0_4.viewComponent:Show()
	end
end

return var0_0
