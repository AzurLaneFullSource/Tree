local var0 = class("ContinuousOperationMediator", import("view.base.ContextMediator"))

var0.CONTINUE_OPERATION = "ContinuousOperationMediator:CONTINUE_OPERATION"
var0.ON_REENTER = "ContinuousOperationMediator:ON_REENTER"

function var0.register(arg0)
	arg0:bind(GAME.PAUSE_BATTLE, function()
		arg0:sendNotification(GAME.PAUSE_BATTLE)
	end)
	arg0:bind(var0.ON_REENTER, function()
		arg0:sendNotification(var0.ON_REENTER, {
			autoFlag = arg0.contextData.autoFlag
		})
	end)
	arg0:bind(BattleMediator.HIDE_ALL_BUTTONS, function(arg0, arg1)
		arg0:sendNotification(BattleMediator.HIDE_ALL_BUTTONS, arg1)

		if not arg1 then
			local var0 = ys.Battle.BattleState.GetInstance()

			if not var0.IsAutoBotActive(SYSTEM_ACT_BOSS) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_auto_on"))
				arg0:sendNotification(GAME.AUTO_BOT, {
					isActiveBot = false
				})
				arg0:sendNotification(GAME.AUTO_SUB, {
					isActiveSub = false
				})
				var0:ActiveBot(var0.IsAutoBotActive(SYSTEM_ACT_BOSS))
			end
		end
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		NewBattleResultMediator.ON_ENTER_BATTLE_RESULT,
		NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == NewBattleResultMediator.ON_ENTER_BATTLE_RESULT then
		arg0:sendNotification(NewBattleResultMediator.SET_SKIP_FLAG, true)
		arg0.viewComponent:OnEnterBattleResult()
	elseif var0 == NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT then
		arg0.viewComponent:AnimatingSlider()
	end
end

function var0.remove(arg0)
	return
end

return var0
