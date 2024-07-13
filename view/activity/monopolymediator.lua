local var0_0 = class("MonopolyPtMediator", import("view.base.ContextMediator"))

var0_0.ON_START = "MonopolyGame:ON_START"
var0_0.ON_MOVE = "MonopolyGame:ON_MOVE"
var0_0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
var0_0.ON_AWARD = "MonopolyGame:ON_AWARD"
var0_0.MONOPOLY_OP_LAST = "MonopolyGame:MONOPOLY_OP_LAST"
var0_0.ON_STOP = "MonopolyGame:MONOPOLY_ON_STOP"
var0_0.AWARDS = {}

function var0_0.register(arg0_1)
	arg0_1:bind(MonopolyPtMediator.ON_STOP, function(arg0_2, arg1_2, arg2_2)
		if not arg0_1.viewComponent.autoFlag and #MonopolyPtMediator.AWARDS > 0 then
			arg0_1:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, arg2_2)

			MonopolyPtMediator.AWARDS = {}
		end
	end)
	arg0_1:bind(MonopolyPtMediator.MONOPOLY_OP_LAST, function(arg0_3, arg1_3, arg2_3)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_3,
			cmd = ActivityConst.MONOPOLY_OP_LAST,
			callback = arg2_3
		})
	end)
	arg0_1:bind(MonopolyPtMediator.ON_START, function(arg0_4, arg1_4, arg2_4)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_4,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = arg2_4
		})
	end)
	arg0_1:bind(MonopolyPtMediator.ON_MOVE, function(arg0_5, arg1_5, arg2_5)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_5,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = arg2_5
		})
	end)
	arg0_1:bind(MonopolyPtMediator.ON_TRIGGER, function(arg0_6, arg1_6, arg2_6)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = arg1_6,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = arg2_6
		})
	end)
	arg0_1:bind(MonopolyPtMediator.ON_AWARD, function(arg0_7)
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.REDPACKEY)
	end)

	arg0_1._configId = arg0_1.contextData.configId
	arg0_1._activityId = arg0_1.contextData.activityId
	arg0_1._activity = getProxy(ActivityProxy):getActivityById(arg0_1._activityId)

	arg0_1.viewComponent:firstUpdata(arg0_1._activity)

	if not arg0_1.viewComponent.autoFlag and #MonopolyPtMediator.AWARDS > 0 then
		arg0_1:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, function()
			return
		end)

		MonopolyPtMediator.AWARDS = {}
	end
end

function var0_0.getLeftRpCount()
	local var0_9 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)
	local var1_9 = var0_9.data2_list[2]

	return var0_9.data2_list[1] - var1_9
end

function var0_0.onAward(arg0_10, arg1_10, arg2_10)
	for iter0_10 = 1, #arg1_10 do
		table.insert(MonopolyPtMediator.AWARDS, arg1_10[iter0_10])
	end

	if arg0_10.viewComponent.autoFlag then
		arg0_10.viewComponent:addAwards(arg1_10)

		if arg2_10 then
			arg2_10()
		end
	else
		arg0_10:emit(BaseUI.ON_ACHIEVE, MonopolyPtMediator.AWARDS, arg2_10)

		MonopolyPtMediator.AWARDS = {}
	end
end

function var0_0.listNotificationInterests(arg0_11)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_ADDED,
		GAME.MONOPOLY_AWARD_DONE
	}
end

function var0_0.handleNotification(arg0_12, arg1_12)
	local var0_12 = arg1_12:getName()
	local var1_12 = arg1_12:getBody()
	local var2_12 = arg1_12:getType()

	if var0_12 == ActivityProxy.ACTIVITY_UPDATED or var0_12 == ActivityProxy.ACTIVITY_ADDED then
		arg0_12:updateGameUI()
	elseif var0_12 == GAME.MONOPOLY_AWARD_DONE then
		if arg0_12._activity:getConfig("type") == ActivityConst.ACTIVITY_TYPE_MONOPOLY and arg0_12.viewComponent.onAward then
			arg0_12.viewComponent:onAward(var1_12.awards, var1_12.callback)
		else
			arg0_12.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_12.awards, var1_12.callback)
		end
	end
end

function var0_0.updateGameUI(arg0_13)
	if not arg0_13._activityId then
		return
	end

	arg0_13._activity = getProxy(ActivityProxy):getActivityById(arg0_13._activityId)

	arg0_13.viewComponent:updataActivity(arg0_13._activity)
end

function var0_0.remove(arg0_14)
	if arg0_14.viewComponent then
		MonopolyPtMediator.AWARDS = {}
	end
end

return var0_0
