local var0 = class("LevelContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0)
		arg0:sendNotification(LevelUIConst.CONTINUOUS_OPERATION, {
			battleTimes = math.min(arg0.contextData.battleTimes, 10)
		})
	end)
	arg0:bind(LevelMediator2.ON_SPITEM_CHANGED, function(arg0, arg1)
		arg0:sendNotification(LevelMediator2.ON_SPITEM_CHANGED, arg1)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0.viewComponent:SetActivity(var1)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:UpdateContent()
	end
end

function var0.remove(arg0)
	return
end

return var0
