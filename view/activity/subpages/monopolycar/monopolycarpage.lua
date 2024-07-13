local var0_0 = class("MonopolyCarPage", import("....base.BaseActivityPage"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"

function var0_0.OnInit(arg0_1)
	arg0_1:bind(MonopolyCarPage.ON_START, function(arg0_2, arg1_2, arg2_2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_2,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_2
		})
	end)
	arg0_1:bind(MonopolyCarPage.ON_MOVE, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_3
		})
	end)
	arg0_1:bind(MonopolyCarPage.ON_TRIGGER, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_4
		})
	end)
	arg0_1:bind(MonopolyCarPage.ON_AWARD, function(arg0_5)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg0_1.activity.id,
			cmd = ActivityConst.MONOPOLY_OP_AWARD
		})
	end)
end

function var0_0.OnFirstFlush(arg0_6)
	return
end

function var0_0.OnUpdateFlush(arg0_7)
	if arg0_7.gameUI then
		arg0_7.gameUI:updataActivity(arg0_7.activity)
	else
		arg0_7.gameUI = MonopolyCarGame.New(arg0_7, findTF(arg0_7._tf, "AD"), arg0_7.event)

		arg0_7.gameUI:firstUpdata(arg0_7.activity)
	end
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
