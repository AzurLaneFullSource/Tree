local var0_0 = class("Monopoly3thRePage", import("....base.BaseActivityPage"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0_0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"
var0_0.ON_STOP = "MonopolyGame:MONOPOLY_ON_STOP"
var0_0.AWARDS = {}

function var0_0.OnInit(arg0_1)
	arg0_1:bind(Monopoly3thRePage.ON_STOP, function(arg0_2, arg1_2, arg2_2)
		if not arg0_1.gameUI.autoFlag and #Monopoly3thRePage.AWARDS > 0 then
			arg0_1:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, arg2_2)

			Monopoly3thRePage.AWARDS = {}
		end
	end)
	arg0_1:bind(Monopoly3thRePage.MONOPOLY_OP_LAST, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2_3
		})
	end)
	arg0_1:bind(Monopoly3thRePage.ON_START, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_4
		})
	end)
	arg0_1:bind(Monopoly3thRePage.ON_MOVE, function(arg0_5, arg1_5, arg2_5)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_5,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_5
		})
	end)
	arg0_1:bind(Monopoly3thRePage.ON_TRIGGER, function(arg0_6, arg1_6, arg2_6)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_6,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_6
		})
	end)
	arg0_1:bind(Monopoly3thRePage.ON_AWARD, function(arg0_7)
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)
end

function var0_0.getLeftRpCount()
	local var0_8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1_8 = var0_8.data2_list[2]

	return var0_8.data2_list[1] - var1_8
end

function var0_0.onAward(arg0_9, arg1_9, arg2_9)
	for iter0_9 = 1, #arg1_9 do
		table.insert(Monopoly3thRePage.AWARDS, arg1_9[iter0_9])
	end

	if arg0_9.gameUI.autoFlag then
		arg0_9.gameUI:addAwards(arg1_9)

		if arg2_9 then
			arg2_9()
		end
	else
		arg0_9:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, arg2_9)

		Monopoly3thRePage.AWARDS = {}
	end
end

function var0_0.OnUpdateFlush(arg0_10)
	arg0_10:updateGameUI()
end

function var0_0.updateGameUI(arg0_11)
	if not arg0_11.activity then
		return
	end

	if arg0_11.gameUI then
		arg0_11.gameUI:updataActivity(arg0_11.activity)
	else
		arg0_11.gameUI = Monopoly3thReGame.New(arg0_11, findTF(arg0_11._tf, "AD"), arg0_11.event, 4)

		arg0_11.gameUI:firstUpdata(arg0_11.activity)

		if not arg0_11.gameUI.autoFlag and #Monopoly3thRePage.AWARDS > 0 then
			arg0_11:emit(BaseUI.ON_ACHIEVE, Monopoly3thRePage.AWARDS, function()
				return
			end)

			Monopoly3thRePage.AWARDS = {}
		end
	end
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13.gameUI then
		Monopoly3thRePage.AWARDS = {}

		arg0_13.gameUI:dispose()

		arg0_13.gameUI = nil
	end
end

function var0_0.OnHideFlush(arg0_14)
	if arg0_14.gameUI then
		Monopoly3thRePage.AWARDS = {}

		arg0_14.gameUI:dispose()

		arg0_14.gameUI = nil
	end
end

return var0_0
