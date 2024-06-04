local var0 = class("OtherWorldTempleMediator", import("..base.ContextMediator"))

var0.OPEN_TERMINAL = "OPEN_TERMINAL"
var0.SHOW_CHAR_AWARDS = "SHOW_CHAR_AWARDS"

function var0.register(arg0)
	arg0:bind(var0.OPEN_TERMINAL, function()
		arg0:addSubLayers(Context.New({
			mediator = OtherworldTerminalMediator,
			viewComponent = OtherworldTerminalLayer
		}))
	end)
	arg0:bind(var0.SHOW_CHAR_AWARDS, function(arg0, arg1, arg2)
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1, arg2)
	end)
end

function var0.onUIAvalible(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		if var1 == ActivityConst.OTHER_WORLD_TERMINAL_LOTTERY_ID then
			arg0.viewComponent:updateActivity()
			arg0.viewComponent:displayTempleCharAward()
		end
	elseif var0 == ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
			if var1.callback then
				var1.callback()
			end
		end)
	elseif var0 == GAME.ZERO_HOUR_OP_DONE then
		-- block empty
	end
end

return var0
