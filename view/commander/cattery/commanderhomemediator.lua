local var0 = class("CommanderHomeMediator", import("...base.ContextMediator"))

var0.ON_CLEAN = "CommanderHomeMediator:ON_CLEAN"
var0.ON_FEED = "CommanderHomeMediator:ON_FEED"
var0.ON_PLAY = "CommanderHomeMediator:ON_PLAY"
var0.ON_SEL_COMMANDER = "CommanderHomeMediator:ON_SEL_COMMANDER"
var0.ON_CHANGE_STYLE = "CommanderHomeMediator:ON_CHANGE_STYLE"

function var0.register(arg0)
	arg0:bind(var0.ON_CLEAN, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 1
		})
	end)
	arg0:bind(var0.ON_FEED, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 2
		})
	end)
	arg0:bind(var0.ON_PLAY, function(arg0, arg1)
		arg0:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 3
		})
	end)
	arg0:bind(var0.ON_SEL_COMMANDER, function(arg0, arg1, arg2, arg3, arg4)
		arg3 = defaultValue(arg3, true)

		arg0:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY, {
			id = arg1,
			commanderId = arg2,
			tip = arg3,
			callback = arg4
		})
	end)
	arg0:bind(var0.ON_CHANGE_STYLE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE, {
			id = arg1,
			styleId = arg2
		})
	end)
	arg0.viewComponent:SetHome(getProxy(CommanderProxy):GetCommanderHome())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.PUT_COMMANDER_IN_CATTERY_DONE,
		GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE,
		GAME.COMMANDER_CATTERY_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE,
		GAME.CALC_CATTERY_EXP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.PUT_COMMANDER_IN_CATTERY_DONE then
		arg0.viewComponent:OnCatteryUpdate(var1.id)
	elseif var0 == GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE then
		arg0.viewComponent:OnCatteryStyleUpdate(var1.id)
	elseif var0 == GAME.COMMANDER_CATTERY_OP_DONE then
		arg0.viewComponent.forbiddenClose = true

		seriesAsync({
			function(arg0)
				arg0.viewComponent:OnCatteryOPDone()
				arg0.viewComponent:OnOpAnimtion(var1.cmd, var1.opCatteries, arg0)
			end,
			function(arg0)
				arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, arg0)

				arg0.viewComponent.forbiddenClose = false
			end,
			function(arg0)
				local var0 = var1.cmd

				arg0.viewComponent:OnDisplayAwardDone(var1)
			end
		})
	elseif var0 == GAME.ZERO_HOUR_OP_DONE then
		arg0.viewComponent:OnZeroHour()
	elseif var0 == GAME.CALC_CATTERY_EXP_DONE then
		arg0.viewComponent:OnCommanderExpChange(var1.commanderExps)
	end
end

return var0
