local var0_0 = class("MonopolyWorldScene", import("..base.BaseUI"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0_0.ON_CLOSE = "MonopolyGame:ON_CLOSE"

function var0_0.getUIName(arg0_1)
	return "MonopolyWorldUI"
end

function var0_0.init(arg0_2)
	arg0_2.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

	arg0_2:bind(MonopolyWorldScene.ON_START, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_3
		})
	end)
	arg0_2:bind(MonopolyWorldScene.ON_MOVE, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_4
		})
	end)
	arg0_2:bind(MonopolyWorldScene.ON_TRIGGER, function(arg0_5, arg1_5, arg2_5)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_5,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_5
		})
	end)
	arg0_2:bind(MonopolyWorldScene.ON_AWARD, function(arg0_6)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg0_2.activity.id,
			cmd = ActivityConst.MONOPOLY_OP_AWARD
		})
	end)

	arg0_2.gameUI = MonopolyWorldGame.New(arg0_2, findTF(arg0_2._tf, "AD"), arg0_2.event)

	arg0_2.gameUI:firstUpdata(arg0_2.activity)
end

function var0_0.willExit(arg0_7)
	if arg0_7.gameUI then
		arg0_7.gameUI:dispose()
	end
end

function var0_0.onBackPressed(arg0_8)
	if arg0_8.gameUI.inAnimatedFlag then
		return
	end

	arg0_8:emit(var0_0.ON_BACK_PRESSED)
end

return var0_0
