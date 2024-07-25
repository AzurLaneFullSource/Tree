local var0_0 = class("MonopolyCar2024Mediator", import("view.base.ContextMediator"))

var0_0.ON_START = "MonopolyCar2024Mediator:ON_START"
var0_0.ON_MOVE = "MonopolyCar2024Mediator:ON_MOVE"
var0_0.ON_PICK = "MonopolyCar2024Mediator:ON_PICK"
var0_0.ON_DIALOGUE = "MonopolyCar2024Mediator:ON_DIALOGUE"
var0_0.ON_AUTO = "MonopolyCar2024Mediator:ON_AUTO"
var0_0.ON_TRIGGER = "MonopolyCar2024Mediator:ON_TRIGGER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_TRIGGER, function(arg0_2, arg1_2, arg2_2)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_2 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_2 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_2,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			autoFlag = var0_2,
			awardCollector = var1_2,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_AUTO, function(arg0_3, arg1_3)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_3 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_3 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			autoFlag = var0_3,
			awardCollector = var1_3,
			cmd = ActivityConst.MONOPOLY_OP_AUTO
		})
	end)
	arg0_1:bind(var0_0.ON_PICK, function(arg0_4, arg1_4, arg2_4, arg3_4)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_4 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_4 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			arg1 = arg2_4,
			autoFlag = var0_4,
			awardCollector = var1_4,
			cmd = ActivityConst.MONOPOLY_OP_PICK,
			callback = arg3_4
		})
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_5, arg1_5, arg2_5)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_5 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_5 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_5,
			autoFlag = var0_5,
			awardCollector = var1_5,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_MOVE, function(arg0_6, arg1_6, arg2_6)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_6 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_6 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_6,
			autoFlag = var0_6,
			awardCollector = var1_6,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_6
		})
	end)
	arg0_1:bind(var0_0.ON_DIALOGUE, function(arg0_7, arg1_7, arg2_7)
		if not arg0_1.viewComponent.gameUI then
			return
		end

		local var0_7 = arg0_1.viewComponent.gameUI.autoFlag
		local var1_7 = arg0_1.viewComponent.gameUI.awardCollector

		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_7,
			autoFlag = var0_7,
			awardCollector = var1_7,
			cmd = ActivityConst.MONOPOLY_OP_DIALOGUE,
			arg1 = arg2_7
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ActivityProxy.ACTIVITY_UPDATED and var1_9:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY then
		arg0_9.viewComponent:UpdateGame(var1_9)
	end
end

return var0_0
