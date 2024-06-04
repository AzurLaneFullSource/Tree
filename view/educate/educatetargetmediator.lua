local var0 = class("EducateTargetMediator", import(".base.EducateContextMediator"))

var0.ON_TASK_SUBMIT = "EducateTargetMediator:ON_TASK_SUBMIT"
var0.ON_GET_TARGET_AWARD = "EducateTargetMediator:ON_GET_TARGET_AWARD"

function var0.register(arg0)
	arg0:bind(var0.ON_TASK_SUBMIT, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_SUBMIT_TASK, {
			id = arg1.id,
			system = arg1:GetSystemType()
		})
	end)
	arg0:bind(var0.ON_GET_TARGET_AWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.EDUCATE_GET_TARGET_AWARD)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EDUCATE_SUBMIT_TASK_DONE,
		GAME.EDUCATE_GET_TARGET_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EDUCATE_SUBMIT_TASK_DONE or var0 == GAME.EDUCATE_GET_TARGET_AWARD_DONE then
		arg0.viewComponent:emit(EducateBaseUI.EDUCATE_ON_AWARD, {
			items = var1.awards
		})
		arg0.viewComponent:updateView()
	end
end

return var0
