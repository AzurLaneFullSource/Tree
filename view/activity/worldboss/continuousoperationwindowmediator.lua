local var0_0 = class("ContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0_2)
		getProxy(SettingsProxy):setActBossExchangeTicketTip(arg0_1.contextData.useTicket and 1 or 0)
		arg0_1:sendNotification(GAME.AUTO_BOT, {
			isActiveBot = false,
			system = SYSTEM_ACT_BOSS
		})

		local var0_2 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_ACT_BOSS)

		getProxy(SettingsProxy):RecordContinuousOperationAutoSubStatus(var0_2)
		arg0_1:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = false,
			system = SYSTEM_ACT_BOSS
		})
		arg0_1:sendNotification(PreCombatMediator.CONTINUOUS_OPERATION, {
			mainFleetId = arg0_1.contextData.mainFleetId,
			battleTimes = math.min(arg0_1.contextData.battleTimes, 15)
		})
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	arg0_1.viewComponent:SetActivity(var0_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_4:getConfig("type") == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			arg0_4.viewComponent:SetActivity(var1_4)
		end
	elseif var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:UpdateContent()
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
