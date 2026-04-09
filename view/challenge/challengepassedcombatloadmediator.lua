local var0_0 = class("ChallengePassedCombatLoadMediator", import("..base.ContextMediator"))

var0_0.FINISH = "ChallengePassedCombatLoadMediator:FINISH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.FINISH, function(arg0_2, arg1_2)
		arg0_1.contextData.loadObs = arg1_2
		arg0_1.contextData.prePause = arg0_1._prePauseBattle

		arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.BATTLE, arg0_1.contextData)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.PAUSE_BATTLE,
		GAME.STOP_BATTLE_LOADING
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.PAUSE_BATTLE then
		arg0_4._prePauseBattle = true
	elseif var0_4 == GAME.STOP_BATTLE_LOADING then
		ys.Battle.BattleResourceManager.GetInstance():Clear()
	end
end

return var0_0
