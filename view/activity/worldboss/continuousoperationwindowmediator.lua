local var0 = class("ContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0)
		getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0.contextData.useTicket and 1 or 0)
		arg0:sendNotification(GAME.AUTO_BOT, {
			isActiveBot = false,
			system = SYSTEM_ACT_BOSS
		})

		local var0 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_ACT_BOSS)

		getProxy(SettingsProxy):RecordContinuousOperationAutoSubStatus(var0)
		arg0:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = false,
			system = SYSTEM_ACT_BOSS
		})
		arg0:sendNotification(PreCombatMediator.CONTINUOUS_OPERATION, {
			mainFleetId = arg0.contextData.mainFleetId,
			battleTimes = math.min(arg0.contextData.battleTimes, 15)
		})
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	arg0.viewComponent:SetActivity(var0)
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
