local var0_0 = class("EducateSelEndingMediator", import(".base.EducateContextMediator"))

var0_0.ON_SELECT_ENDING = "EducateSelEndingMediator:ON_SELECT_ENDING"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SELECT_ENDING, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.EDUCATE_TRIGGER_END, {
			ids = arg2_2,
			selId = arg1_2
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.EDUCATE_TRIGGER_END_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.EDUCATE_TRIGGER_END_DONE then
		arg0_4.viewComponent:closeView()
	end
end

return var0_0
