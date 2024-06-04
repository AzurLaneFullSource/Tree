local var0 = class("Monopoly3thPage", import("....base.BaseActivityPage"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"

function var0.OnInit(arg0)
	arg0:bind(Monopoly3thPage.MONOPOLY_OP_LAST, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thPage.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thPage.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thPage.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thPage.ON_AWARD, function(arg0)
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)
end

function var0.getLeftRpCount()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1 = var0.data2_list[2]

	return var0.data2_list[1] - var1
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0:updateGameUI()
end

function var0.updateGameUI(arg0)
	if not arg0.activity then
		return
	end

	if arg0.gameUI then
		arg0.gameUI:updataActivity(arg0.activity)
	else
		arg0.gameUI = Monopoly3thGame.New(arg0, findTF(arg0._tf, "AD"), arg0.event, 4)

		arg0.gameUI:firstUpdata(arg0.activity)
	end
end

function var0.OnDestroy(arg0)
	arg0.gameUI:dispose()
end

return var0
