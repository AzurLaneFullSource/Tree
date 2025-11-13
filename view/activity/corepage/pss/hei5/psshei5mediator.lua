local var0_0 = class("PSSHei5Mediator", import("view.base.ContextMediator"))

var0_0.EVENT_GET_AWARD_ALL = "PSSHei5Mediator.EVENT_GET_AWARD_ALL"
var0_0.EVENT_OPEN_BIRTHDAY = "PSSHei5Mediator.EVENT_OPEN_BIRTHDAY"
var0_0.ON_TASK_GO = "PSSHei5Mediator.ON_TASK_GO"
var0_0.ON_TASK_SUBMIT = "PSSHei5Mediator.ON_TASK_SUBMIT"
var0_0.ON_TASK_QUICK_SUBMIT = "PSSHei5Mediator.ON_TASK_QUICK_SUBMIT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EVENT_GET_AWARD_ALL, function(arg0_2)
		arg0_1:sendNotification(GAME.CRUSING_CMD, {
			cmd = 1,
			activity_id = arg0_1.viewComponent.activity.id
		})
	end)
	arg0_1:bind(var0_0.EVENT_OPEN_BIRTHDAY, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = ChargeBirthdayMediator,
			viewComponent = ChargeBirthdayLayer,
			data = {}
		}))
	end)
	arg0_1:bind(var0_0.ON_TASK_GO, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_TASK_SUBMIT, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_5.id)
	end)
	arg0_1:bind(var0_0.ON_TASK_QUICK_SUBMIT, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.QUICK_TASK, arg1_6.id)
	end)

	local var0_1 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)

	arg0_1.viewComponent:setActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.CRUSING_CMD_DONE,
		GAME.CHARGE_SUCCESS,
		GAME.SUBMIT_TASK_DONE,
		GAME.SUBMIT_ACTIVITY_TASK_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_8.id == arg0_8.viewComponent.activity.id then
			arg0_8.viewComponent:setActivity(var1_8)
			arg0_8.viewComponent:UpdatePhase()
			arg0_8.viewComponent:UpdateAwardPage()
			arg0_8.viewComponent:UpdateTaskPage()
			arg0_8.viewComponent:UpdateView()
		end
	elseif var0_8 == GAME.CRUSING_CMD_DONE then
		arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards)
		arg0_8.viewComponent:UpdateAwardPage()
		arg0_8.viewComponent:UpdateView()
	elseif var0_8 == GAME.CHARGE_SUCCESS then
		local var2_8 = Goods.Create({
			shop_id = var1_8.shopId
		}, Goods.TYPE_CHARGE)

		arg0_8.viewComponent:OnChargeSuccess(var2_8)
	elseif var0_8 == GAME.SUBMIT_TASK_DONE or var0_8 == GAME.SUBMIT_ACTIVITY_TASK_DONE then
		arg0_8.viewComponent:UpdateTaskPage()
		arg0_8.viewComponent:UpdateView()
	end
end

return var0_0
