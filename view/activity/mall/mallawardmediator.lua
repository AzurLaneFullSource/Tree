local var0_0 = class("MallAwardMediator", import("view.base.ContextMediator"))

var0_0.INPUT_GOLD = "MallAwardMediator.INPUT_GOLD"
var0_0.GET_PT_AWARD = "MallAwardMediator.GET_PT_AWARD"
var0_0.SUBMIT_TASK = "MallAwardMediator.SUBMIT_TASK"
var0_0.TASK_GO = "MallAwardMediator.TASK_GO"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.INPUT_GOLD, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_2,
			cmd = ActivityMallOPCommand.CMD.INPUT_GOLD,
			arg1 = arg2_2
		})
	end)
	arg0_1:bind(var0_0.GET_PT_AWARD, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, arg1_3)
	end)
	arg0_1:bind(var0_0.SUBMIT_TASK, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.SUBMIT_TASK, arg1_4.id)
	end)
	arg0_1:bind(var0_0.TASK_GO, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.TASK_GO, {
			taskVO = arg1_5
		})
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.ACT_NEW_PT_DONE,
		GAME.ACTIVITY_MALL_OP_DONE,
		GAME.SUBMIT_TASK_AWARD_DOWN
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.ACT_NEW_PT_DONE then
		if arg0_7:IsAwardHandledByParent() then
			arg0_7.viewComponent:UpdateView()
		else
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7.awards, function()
				arg0_7.viewComponent:UpdateView()
			end)
		end
	elseif var0_7 == GAME.ACTIVITY_MALL_OP_DONE then
		if var1_7.cmd == ActivityMallOPCommand.CMD.INPUT_GOLD then
			arg0_7.viewComponent:UpdateView()
		end
	elseif var0_7 == GAME.SUBMIT_TASK_AWARD_DOWN then
		if arg0_7:IsAwardHandledByParent() then
			arg0_7.viewComponent:UpdateView()
		else
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_7.awards, function()
				arg0_7.viewComponent:UpdateView()
			end)
		end
	end
end

function var0_0.IsAwardHandledByParent(arg0_10)
	return arg0_10.contextData and arg0_10.contextData.awardHandledByParent
end

function var0_0.remove(arg0_11)
	return
end

return var0_0
