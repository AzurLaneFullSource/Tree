local var0_0 = class("ActivityBossBuffSelectMediator", import("view.base.ContextMediator"))

var0_0.ON_START = "ActivityBossBuffSelectMediator:ON_START"
var0_0.SHOW_REWARDS = "ActivityBossBuffSelectMediator:SHOW_REWARDS"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_START, function(arg0_2, arg1_2)
		local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		getProxy(ActivityProxy):GetActivityBossRuntime(var0_2.id).buffIds = _.map(arg1_2, function(arg0_3)
			return arg0_3:GetConfigID()
		end)

		arg0_1:sendNotification(var0_0.ON_START)
		arg0_1.viewComponent:closeView()
	end)
	arg0_1:bind(var0_0.SHOW_REWARDS, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:addSubLayers(Context.New({
			mediator = ActivityBossScoreAwardMediator,
			viewComponent = ActivityBossScoreAwardLayer,
			data = {
				awards = arg1_4,
				targets = arg2_4,
				score = arg3_4
			}
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == nil then
		-- block empty
	end
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
