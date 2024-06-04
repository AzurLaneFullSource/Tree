local var0 = class("LotteryMediator", import("..base.ContextMediator"))

var0.ON_LAUNCH = "LotteryMediator:ON_LAUNCH"
var0.ON_SWITCH = "LotteryMediator:ON_SWITCH"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy)

	arg0:bind(var0.ON_LAUNCH, function(arg0, arg1, arg2, arg3, arg4)
		local var0 = var0:getActivityById(arg1)

		if not var0 or var0:isEnd() then
			return
		end

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			activity_id = arg1,
			arg1 = arg3,
			arg2 = arg2,
			isAwardMerge = arg4
		})
	end)
	arg0:bind(var0.ON_SWITCH, function(arg0, arg1, arg2)
		local var0 = var0:getActivityById(arg1)

		if not var0 or var0:isEnd() then
			return
		end

		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 2,
			arg2 = 0,
			activity_id = arg1,
			arg1 = arg2
		})
	end)

	local var1 = arg0.contextData.activityId
	local var2 = var0:getActivityById(var1)
	local var3 = getProxy(PlayerProxy)

	arg0.viewComponent:setActivity(var2)
	arg0.viewComponent:setPlayerVO(var3:getData())
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_LOTTERY then
			arg0.viewComponent:onActivityUpdated(var1)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerVO(var1)
	elseif var0 == ActivityProxy.ACTIVITY_LOTTERY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	end
end

return var0
