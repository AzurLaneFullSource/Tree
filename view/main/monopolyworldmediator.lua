local var0_0 = class("MonthCardSetMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		GAME.MONOPOLY_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == GAME.MONOPOLY_AWARD_DONE then
		arg0_3.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_3.awards, var1_3.callback)
	end
end

return var0_0
