local var0 = class("MonopolyPtMediator", import("view.base.ContextMediator"))

var0.ON_START = "MonopolyGame:ON_START"
var0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"
var0.ON_STOP = "MonopolyGame:MONOPOLY_ON_STOP"
var0.AWARDS = {}

function var0.register(arg0)
	arg0:bind(MonopolyPtMediator.ON_STOP, function(arg0, arg1, arg2)
		if not arg0.viewComponent.autoFlag and #MonopolyPtMediator.AWARDS > 0 then
			arg0:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, arg2)

			MonopolyPtMediator.AWARDS = {}
		end
	end)
	arg0:bind(MonopolyPtMediator.MONOPOLY_OP_LAST, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyPtMediator.ON_START, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyPtMediator.ON_MOVE, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyPtMediator.ON_TRIGGER, function(arg0, arg1, arg2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2
		})
	end)
	arg0:bind(MonopolyPtMediator.ON_AWARD, function(arg0)
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)

	arg0._configId = arg0.contextData.configId
	arg0._activityId = arg0.contextData.activityId
	arg0._activity = getProxy(ActivityProxy):getActivityById(arg0._activityId)

	arg0.viewComponent:firstUpdata(arg0._activity)

	if not arg0.viewComponent.autoFlag and #MonopolyPtMediator.AWARDS > 0 then
		arg0:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, function()
			return
		end)

		MonopolyPtMediator.AWARDS = {}
	end
end

function var0.getLeftRpCount()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1 = var0.data2_list[2]

	return var0.data2_list[1] - var1
end

function var0.onAward(arg0, arg1, arg2)
	for iter0 = 1, #arg1 do
		table.insert(MonopolyPtMediator.AWARDS, arg1[iter0])
	end

	if arg0.viewComponent.autoFlag then
		arg0.viewComponent:addAwards(arg1)

		if arg2 then
			arg2()
		end
	else
		arg0:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, arg2)

		MonopolyPtMediator.AWARDS = {}
	end
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_ADDED,
		GAME.MONOPOLY_AWARD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == ActivityProxy.ACTIVITY_UPDATED or var0 == ActivityProxy.ACTIVITY_ADDED then
		arg0:updateGameUI()
	elseif var0 == GAME.MONOPOLY_AWARD_DONE then
		if arg0._activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and arg0.viewComponent.onAward then
			arg0.viewComponent:onAward(var1.awards, var1.callback)
		else
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
		end
	end
end

function var0.updateGameUI(arg0)
	if not arg0._activityId then
		return
	end

	arg0._activity = getProxy(ActivityProxy):getActivityById(arg0._activityId)

	arg0.viewComponent:updataActivity(arg0._activity)
end

function var0.remove(arg0)
	if arg0.viewComponent then
		MonopolyPtMediator.AWARDS = {}
	end
end

return var0
