local var0_0 = class("LevelContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0_2)
		arg0_1:sendNotification(LevelUIConst.CONTINUOUS_OPERATION, {
			battleTimes = math.min(arg0_1.contextData.battleTimes, 10)
		})
	end)
	arg0_1:bind(LevelMediator2.ON_SPITEM_CHANGED, function(arg0_3, arg1_3)
		arg0_1:sendNotification(LevelMediator2.ON_SPITEM_CHANGED, arg1_3)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0_5.viewComponent:SetActivity(var1_5)
		end
	elseif var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:UpdateContent()
	end
end

function var0_0.remove(arg0_6)
	return
end

return var0_0
