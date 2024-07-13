local var0_0 = class("EducateTargetMediator", import(".base.EducateContextMediator"))

var0_0.ON_TASK_SUBMIT = "EducateTargetMediator:ON_TASK_SUBMIT"
var0_0.ON_GET_TARGET_AWARD = "EducateTargetMediator:ON_GET_TARGET_AWARD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.EDUCATE_SUBMIT_TASK, {
			id = arg1_2.id,
			system = arg1_2:GetSystemType()
		})
	end)
	arg0_1:bind(var0_0.ON_GET_TARGET_AWARD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.EDUCATE_GET_TARGET_AWARD)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.EDUCATE_SUBMIT_TASK_DONE,
		GAME.EDUCATE_GET_TARGET_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.EDUCATE_SUBMIT_TASK_DONE or var0_5 == GAME.EDUCATE_GET_TARGET_AWARD_DONE then
		arg0_5.viewComponent:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
			items = var1_5.awards
		})
		arg0_5.viewComponent:updateView()
	end
end

return var0_0
