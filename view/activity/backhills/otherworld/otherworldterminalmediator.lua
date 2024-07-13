local var0_0 = class("OtherworldTerminalMediator", import("view.base.ContextMediator"))

var0_0.ON_GET_PT_ALL_AWARD = "OtherworldTerminalMediator.ON_GET_PT_AWARD"
var0_0.ON_BUFF_LIST_CHANGE = "OtherworldTerminalMediator.ON_BUFF_LIST_CHANGE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_GET_PT_ALL_AWARD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 4,
			activity_id = arg1_2.actId,
			arg1 = arg1_2.arg1
		})
	end)
	arg0_1:bind(var0_0.ON_BUFF_LIST_CHANGE, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 3,
			activity_id = arg1_3.actId,
			arg_list = arg1_3.ids
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		local var2_5 = var1_5

		if var2_5.id == TerminalAdventurePage.BIND_PT_ACT_ID then
			arg0_5.viewComponent:UpdateAdventurePtAct(var2_5)
		elseif var2_5.id == TerminalAdventurePage.BIND_TASK_ACT_ID then
			arg0_5.viewComponent:UpdateAdventureTaskAct(var2_5)
		elseif var2_5.id == ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID then
			arg0_5.viewComponent:UpdateGuardianAct(var2_5)
		end
	elseif var0_5 == GAME.ACT_NEW_PT_DONE then
		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards)
		arg0_5.viewComponent:UpdateAdventureTip()
	end
end

return var0_0
