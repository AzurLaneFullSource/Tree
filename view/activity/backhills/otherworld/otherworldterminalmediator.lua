local var0 = class("OtherworldTerminalMediator", import("view.base.ContextMediator"))

var0.ON_GET_PT_ALL_AWARD = "OtherworldTerminalMediator.ON_GET_PT_AWARD"
var0.ON_BUFF_LIST_CHANGE = "OtherworldTerminalMediator.ON_BUFF_LIST_CHANGE"

function var0.register(arg0)
	arg0:bind(var0.ON_GET_PT_ALL_AWARD, function(arg0, arg1)
		arg0:sendNotification(GAME.ACT_NEW_PT, {
			cmd = 4,
			activity_id = arg1.actId,
			arg1 = arg1.arg1
		})
	end)
	arg0:bind(var0.ON_BUFF_LIST_CHANGE, function(arg0, arg1)
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 3,
			activity_id = arg1.actId,
			arg_list = arg1.ids
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		GAME.ACT_NEW_PT_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		local var2 = var1

		if var2.id == TerminalAdventurePage.BIND_PT_ACT_ID then
			arg0.viewComponent:UpdateAdventurePtAct(var2)
		elseif var2.id == TerminalAdventurePage.BIND_TASK_ACT_ID then
			arg0.viewComponent:UpdateAdventureTaskAct(var2)
		elseif var2.id == ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID then
			arg0.viewComponent:UpdateGuardianAct(var2)
		end
	elseif var0 == GAME.ACT_NEW_PT_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		arg0.viewComponent:UpdateAdventureTip()
	end
end

return var0
