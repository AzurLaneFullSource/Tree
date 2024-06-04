local var0 = class("Monopoly3thRePage", import("....base.BaseActivityPage"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"
var0.ON_STOP = "MonopolyGame:MONOPOLY_ON_STOP"
var0.AWARDS = {}

function var0.OnInit(arg0)
	arg0:bind(Monopoly3thRePage.ON_STOP, function(arg0, arg1, arg2)
		if not arg0.gameUI.autoFlag and #Monopoly3thRePage.AWARDS > 0 then
			arg0:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, arg2)

			Monopoly3thRePage.AWARDS = {}
		end
	end)
	arg0:bind(Monopoly3thRePage.MONOPOLY_OP_LAST, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thRePage.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thRePage.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thRePage.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(Monopoly3thRePage.ON_AWARD, function(arg0)
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)
end

function var0.getLeftRpCount()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1 = var0.data2_list[2]

	return var0.data2_list[1] - var1
end

function var0.onAward(arg0, arg1, arg2)
	for iter0 = 1, #arg1 do
		table.insert(Monopoly3thRePage.AWARDS, arg1[iter0])
	end

	if arg0.gameUI.autoFlag then
		arg0.gameUI:addAwards(arg1)

		if arg2 then
			arg2()
		end
	else
		arg0:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, arg2)

		Monopoly3thRePage.AWARDS = {}
	end
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
		arg0.gameUI = Monopoly3thReGame.New(arg0, findTF(arg0._tf, "AD"), arg0.event, 4)

		arg0.gameUI:firstUpdata(arg0.activity)

		if not arg0.gameUI.autoFlag and #Monopoly3thRePage.AWARDS > 0 then
			arg0:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, function()
				return
			end)

			Monopoly3thRePage.AWARDS = {}
		end
	end
end

function var0.OnDestroy(arg0)
	if arg0.gameUI then
		Monopoly3thRePage.AWARDS = {}

		arg0.gameUI:dispose()

		arg0.gameUI = nil
	end
end

function var0.OnHideFlush(arg0)
	if arg0.gameUI then
		Monopoly3thRePage.AWARDS = {}

		arg0.gameUI:dispose()

		arg0.gameUI = nil
	end
end

return var0
