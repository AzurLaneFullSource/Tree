local var0 = class("BossSingleContinuousOperationWindowMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(PreCombatMediator.CONTINUOUS_OPERATION, function(arg0)
		arg0:sendNotification(GAME.AUTO_BOT, {
			isActiveBot = false,
			system = SYSTEM_BOSS_SINGLE
		})

		local var0 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_BOSS_SINGLE)

		getProxy(SettingsProxy):RecordContinuousOperationAutoSubStatus(var0)
		arg0:sendNotification(GAME.AUTO_SUB, {
			isActiveSub = false,
			system = SYSTEM_BOSS_SINGLE
		})
		arg0:sendNotification(BossSinglePreCombatMediator.CONTINUOUS_OPERATION, {
			mainFleetId = arg0.contextData.mainFleetId,
			battleTimes = math.min(arg0.contextData.battleTimes, 15)
		})
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:UpdateContent()
	end
end

function var0.remove(arg0)
	return
end

return var0
