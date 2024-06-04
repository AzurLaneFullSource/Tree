local var0 = class("ActivityBossBuffSelectMediator", import("view.base.ContextMediator"))

var0.ON_START = "ActivityBossBuffSelectMediator:ON_START"
var0.SHOW_REWARDS = "ActivityBossBuffSelectMediator:SHOW_REWARDS"

function var0.register(arg0)
	arg0:bind(var0.ON_START, function(arg0, arg1)
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

		getProxy(ActivityProxy):GetActivityBossRuntime(var0.id).buffIds = _.map(arg1, function(arg0)
			return arg0:GetConfigID()
		end)

		arg0:sendNotification(var0.ON_START)
		arg0.viewComponent:closeView()
	end)
	arg0:bind(var0.SHOW_REWARDS, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = ActivityBossScoreAwardMediator,
			viewComponent = ActivityBossScoreAwardLayer,
			data = {
				awards = arg1,
				targets = arg2,
				score = arg3
			}
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	end
end

function var0.remove(arg0)
	return
end

return var0
