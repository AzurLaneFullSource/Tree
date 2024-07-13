local var0_0 = class("LotteryMediator", import("..base.ContextMediator"))

var0_0.ON_LAUNCH = "LotteryMediator:ON_LAUNCH"
var0_0.ON_SWITCH = "LotteryMediator:ON_SWITCH"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy)

	arg0_1:bind(var0_0.ON_LAUNCH, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		local var0_2 = var0_1:getActivityById(arg1_2)

		if not var0_2 or var0_2:isEnd() then
			return
		end

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1_2,
			arg1 = arg3_2,
			arg2 = arg2_2,
			isAwardMerge = arg4_2
		})
	end)
	arg0_1:bind(var0_0.ON_SWITCH, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = var0_1:getActivityById(arg1_3)

		if not var0_3 or var0_3:isEnd() then
			return
		end

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			arg2 = 0,
			activity_id = arg1_3,
			arg1 = arg2_3
		})
	end)

	local var1_1 = arg0_1.contextData.activityId
	local var2_1 = var0_1:getActivityById(var1_1)
	local var3_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:setActivity(var2_1)
	arg0_1.viewComponent:setPlayerVO(var3_1:getData())
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
			arg0_5.viewComponent:onActivityUpdated(var1_5)
		end
	elseif var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:setPlayerVO(var1_5)
	elseif var0_5 == ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS then
		arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, var1_5.callback)
	end
end

return var0_0
