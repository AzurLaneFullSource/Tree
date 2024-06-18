local var0_0 = class("CommanderHomeMediator", import("...base.ContextMediator"))

var0_0.ON_CLEAN = "CommanderHomeMediator:ON_CLEAN"
var0_0.ON_FEED = "CommanderHomeMediator:ON_FEED"
var0_0.ON_PLAY = "CommanderHomeMediator:ON_PLAY"
var0_0.ON_SEL_COMMANDER = "CommanderHomeMediator:ON_SEL_COMMANDER"
var0_0.ON_CHANGE_STYLE = "CommanderHomeMediator:ON_CHANGE_STYLE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_CLEAN, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 1
		})
	end)
	arg0_1:bind(var0_0.ON_FEED, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 2
		})
	end)
	arg0_1:bind(var0_0.ON_PLAY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.COMMANDER_CATTERY_OP, {
			op = 3
		})
	end)
	arg0_1:bind(var0_0.ON_SEL_COMMANDER, function(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5)
		arg3_5 = defaultValue(arg3_5, true)

		arg0_1:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY, {
			id = arg1_5,
			commanderId = arg2_5,
			tip = arg3_5,
			callback = arg4_5
		})
	end)
	arg0_1:bind(var0_0.ON_CHANGE_STYLE, function(arg0_6, arg1_6, arg2_6)
		arg0_1:sendNotification(GAME.COMMANDER_CHANGE_CATTERY_STYLE, {
			id = arg1_6,
			styleId = arg2_6
		})
	end)
	arg0_1.viewComponent:SetHome(getProxy(CommanderProxy):GetCommanderHome())
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.PUT_COMMANDER_IN_CATTERY_DONE,
		GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE,
		GAME.COMMANDER_CATTERY_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE,
		GAME.CALC_CATTERY_EXP_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.PUT_COMMANDER_IN_CATTERY_DONE then
		arg0_8.viewComponent:OnCatteryUpdate(var1_8.id)
	elseif var0_8 == GAME.COMMANDER_CHANGE_CATTERY_STYLE_DONE then
		arg0_8.viewComponent:OnCatteryStyleUpdate(var1_8.id)
	elseif var0_8 == GAME.COMMANDER_CATTERY_OP_DONE then
		arg0_8.viewComponent.forbiddenClose = true

		seriesAsync({
			function(arg0_9)
				arg0_8.viewComponent:OnCatteryOPDone()
				arg0_8.viewComponent:OnOpAnimtion(var1_8.cmd, var1_8.opCatteries, arg0_9)
			end,
			function(arg0_10)
				arg0_8.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_8.awards, arg0_10)

				arg0_8.viewComponent.forbiddenClose = false
			end,
			function(arg0_11)
				local var0_11 = var1_8.cmd

				arg0_8.viewComponent:OnDisplayAwardDone(var1_8)
			end
		})
	elseif var0_8 == GAME.ZERO_HOUR_OP_DONE then
		arg0_8.viewComponent:OnZeroHour()
	elseif var0_8 == GAME.CALC_CATTERY_EXP_DONE then
		arg0_8.viewComponent:OnCommanderExpChange(var1_8.commanderExps)
	end
end

return var0_0
