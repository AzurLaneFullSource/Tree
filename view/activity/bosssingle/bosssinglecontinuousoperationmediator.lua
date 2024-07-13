local var0_0 = class("BossSingleContinuousOperationMediator", import("view.base.ContextMediator"))

var0_0.CONTINUE_OPERATION = "BossSingleContinuousOperationMediator:CONTINUE_OPERATION"
var0_0.ON_REENTER = "BossSingleContinuousOperationMediator:ON_REENTER"

function var0_0.register(arg0_1)
	arg0_1:bind(GAME.PAUSE_BATTLE, function()
		arg0_1:sendNotification(GAME.PAUSE_BATTLE)
	end)
	arg0_1:bind(var0_0.ON_REENTER, function()
		arg0_1:sendNotification(var0_0.ON_REENTER, {
			autoFlag = arg0_1.contextData.autoFlag
		})
	end)
	arg0_1:bind(BattleMediator.HIDE_ALL_BUTTONS, function(arg0_4, arg1_4)
		arg0_1:sendNotification(BattleMediator.HIDE_ALL_BUTTONS, arg1_4)

		if not arg1_4 then
			local var0_4 = ys.Battle.BattleState.GetInstance()

			if not var0_4.IsAutoBotActive(SYSTEM_BOSS_SINGLE) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("multiple_sorties_auto_on"))
				arg0_1:sendNotification(GAME.AUTO_BOT, {
					isActiveBot = false
				})
				arg0_1:sendNotification(GAME.AUTO_SUB, {
					isActiveSub = false
				})
				var0_4:ActiveBot(var0_4.IsAutoBotActive(SYSTEM_BOSS_SINGLE))
			end
		end
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		NewBattleResultMediator.ON_ENTER_BATTLE_RESULT,
		NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == NewBattleResultMediator.ON_ENTER_BATTLE_RESULT then
		arg0_6:sendNotification(NewBattleResultMediator.SET_SKIP_FLAG, true)
		arg0_6.viewComponent:OnEnterBattleResult()
	elseif var0_6 == NewBattleResultMediator.ON_COMPLETE_BATTLE_RESULT then
		arg0_6.viewComponent:AnimatingSlider()
	end
end

function var0_0.remove(arg0_7)
	return
end

return var0_0
