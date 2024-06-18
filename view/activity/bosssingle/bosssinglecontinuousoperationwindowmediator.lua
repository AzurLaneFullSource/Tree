local var0_0 = class("BossSingleContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0_2)
		arg0_1:sendNotification(GAME.AUTO_BOT, {
			isActiveBot = false,
			system = SYSTEM_BOSS_SINGLE
		})

		local var0_2 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_BOSS_SINGLE)

		getProxy(SettingsProxy):RecordContinuousOperationAutoSubStatus(var0_2)
		arg0_1:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = false,
			system = SYSTEM_BOSS_SINGLE
		})
		arg0_1:sendNotification(BossSinglePreCombatMediator.CONTINUOUS_OPERATION, {
			mainFleetId = arg0_1.contextData.mainFleetId,
			battleTimes = math.min(arg0_1.contextData.battleTimes, 15)
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == PlayerProxy.UPDATED then
		arg0_4.viewComponent:UpdateContent()
	end
end

function var0_0.remove(arg0_5)
	return
end

return var0_0
