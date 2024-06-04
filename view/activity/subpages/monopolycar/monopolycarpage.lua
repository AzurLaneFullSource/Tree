local var0 = class("MonopolyCarPage", import("....base.BaseActivityPage"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"

function var0.OnInit(arg0)
	arg0:bind(MonopolyCarPage.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyCarPage.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyCarPage.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyCarPage.ON_AWARD, function(arg0)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg0.activity.id,
			cmd = ActivityConst.MONOPOLY_OP_AWARD
		})
	end)
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	if arg0.gameUI then
		arg0.gameUI:updataActivity(arg0.activity)
	else
		arg0.gameUI = MonopolyCarGame.New(arg0, findTF(arg0._tf, "AD"), arg0.event)

		arg0.gameUI:firstUpdata(arg0.activity)
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
