local var0_0 = class("EducateMindMediator", import(".base.EducateContextMediator"))

var0_0.ON_TASK_SUBMIT = "EducateMindMediator:ON_TASK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_SUBMIT_TASK, {
			id = arg1_2.id,
			system = arg1_2:GetSystemType()
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.EDUCATE_SUBMIT_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.EDUCATE_SUBMIT_TASK_DONE then
		arg0_4.viewComponent:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
			items = var1_4.awards
		})
		arg0_4.viewComponent:updateView()
	end
end

return var0_0
