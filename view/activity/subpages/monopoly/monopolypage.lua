local var0_0 = class("MonopolyPage", import("....base.BaseActivityPage"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")

	arg0_1:bind(var0_0.ON_START, function(arg0_2, arg1_2, arg2_2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_2,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_2
		})
	end)
	arg0_1:bind(var0_0.ON_MOVE, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_3
		})
	end)
	arg0_1:bind(var0_0.ON_TRIGGER, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ON_AWARD, function(arg0_5)
		arg0_1:emit(ActivityMediator.OPEN_LAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
end

function var0_0.OnFirstFlush(arg0_6)
	return
end

function var0_0.OnUpdateFlush(arg0_7)
	if not arg0_7.game then
		arg0_7.game = import("view.activity.subPages.Monopoly.game.MomopolyGame").New()

		arg0_7.game:SetUp(arg0_7, arg0_7.activity)
	else
		arg0_7.game:NetActivity(arg0_7.activity)
	end
end

function var0_0.OnDestroy(arg0_8)
	arg0_8.game:Destroy()
end

return var0_0
