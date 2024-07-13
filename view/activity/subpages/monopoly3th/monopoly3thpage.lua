local var0_0 = class("Monopoly3thPage", import("....base.BaseActivityPage"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0_0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"

function var0_0.OnInit(arg0_1)
	arg0_1:bind(Monopoly3thPage.MONOPOLY_OP_LAST, function(arg0_2, arg1_2, arg2_2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_2,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2_2
		})
	end)
	arg0_1:bind(Monopoly3thPage.ON_START, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_3
		})
	end)
	arg0_1:bind(Monopoly3thPage.ON_MOVE, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_4
		})
	end)
	arg0_1:bind(Monopoly3thPage.ON_TRIGGER, function(arg0_5, arg1_5, arg2_5)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_5,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_5
		})
	end)
	arg0_1:bind(Monopoly3thPage.ON_AWARD, function(arg0_6)
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)
end

function var0_0.getLeftRpCount()
	local var0_7 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1_7 = var0_7.data2_list[2]

	return var0_7.data2_list[1] - var1_7
end

function var0_0.OnFirstFlush(arg0_8)
	return
end

function var0_0.OnUpdateFlush(arg0_9)
	arg0_9:updateGameUI()
end

function var0_0.updateGameUI(arg0_10)
	if not arg0_10.activity then
		return
	end

	if arg0_10.gameUI then
		arg0_10.gameUI:updataActivity(arg0_10.activity)
	else
		arg0_10.gameUI = Monopoly3thGame.New(arg0_10, findTF(arg0_10._tf, "AD"), arg0_10.event, 4)

		arg0_10.gameUI:firstUpdata(arg0_10.activity)
	end
end

function var0_0.OnDestroy(arg0_11)
	arg0_11.gameUI:dispose()
end

return var0_0
