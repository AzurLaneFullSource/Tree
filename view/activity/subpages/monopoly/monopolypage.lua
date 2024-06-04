local var0 = class("MonopolyPage", import("....base.BaseActivityPage"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")

	arg0:bind(var0.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_AWARD, function(arg0)
		arg0:emit(ActivityMediator.OPEN_LAYER, Context.New({
			mediator = RedPacketMediator,
			viewComponent = RedPacketLayer
		}))
	end)
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	if not arg0.game then
		arg0.game = import("view.activity.subPages.Monopoly.game.MomopolyGame").New()

		arg0.game:SetUp(arg0, arg0.activity)
	else
		arg0.game:NetActivity(arg0.activity)
	end
end

function var0.OnDestroy(arg0)
	arg0.game:Destroy()
end

return var0
