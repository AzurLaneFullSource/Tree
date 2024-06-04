local var0 = class("MonopolyWorldScene", import("..base.BaseUI"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0.ON_CLOSE = "MonopolyGame:ON_CLOSE"

function var0.getUIName(arg0)
	return "MonopolyWorldUI"
end

function var0.init(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

	arg0:bind(MonopolyWorldScene.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyWorldScene.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyWorldScene.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyWorldScene.ON_AWARD, function(arg0)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg0.activity.id,
			cmd = ActivityConst.MONOPOLY_OP_AWARD
		})
	end)

	arg0.gameUI = MonopolyWorldGame.New(arg0, findTF(arg0._tf, "AD"), arg0.event)

	arg0.gameUI:firstUpdata(arg0.activity)
end

function var0.willExit(arg0)
	if arg0.gameUI then
		arg0.gameUI:dispose()
	end
end

function var0.onBackPressed(arg0)
	if arg0.gameUI.inAnimatedFlag then
		return
	end

	arg0:emit(var0.ON_BACK_PRESSED)
end

return var0
