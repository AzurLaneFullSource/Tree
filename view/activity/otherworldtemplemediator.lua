local var0_0 = class("OtherWorldTempleMediator", import("..base.ContextMediator"))

var0_0.OPEN_TERMINAL = "OPEN_TERMINAL"
var0_0.SHOW_CHAR_AWARDS = "SHOW_CHAR_AWARDS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_TERMINAL, function()
		arg0_1:addSubLayers(Context.New({
			mediator = OtherworldTerminalMediator,
			viewComponent = OtherworldTerminalLayer
		}))
	end)
	arg0_1:bind(var0_0.SHOW_CHAR_AWARDS, function(arg0_3, arg1_3, arg2_3)
		arg0_1.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_3, arg2_3)
	end)
end

function var0_0.onUIAvalible(arg0_4)
	return
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		if var1_6 == ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID then
			arg0_6.viewComponent:updateActivity()
			arg0_6.viewComponent:displayTempleCharAward()
		end
	elseif var0_6 == ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.awards, function()
			if var1_6.callback then
				var1_6.callback()
			end
		end)
	elseif var0_6 == GAME.ZERO_HOUR_OP_DONE then
		-- block empty
	end
end

return var0_0
