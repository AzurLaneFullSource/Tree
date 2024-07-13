local var0_0 = class("CombatLoadMediator", import("..base.ContextMediator"))

var0_0.FINISH = "CombatLoadMediator:FINISH"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.FINISH, function(arg0_2, arg1_2)
		arg0_1.contextData.loadObs = arg1_2
		arg0_1.contextData.prePause = arg0_1._prePauseBattle

		arg0_1:sendNotification(GAME.CHANGE_SCENE, SCENE.BATTLE, arg0_1.contextData)
	end)
end

function var0_0.remove(arg0_3)
	return
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.PAUSE_BATTLE,
		GAME.STOP_BATTLE_LOADING
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.PAUSE_BATTLE then
		arg0_5._prePauseBattle = true
	elseif var0_5 == GAME.STOP_BATTLE_LOADING then
		ys.Battle.BattleResourceManager.GetInstance():Clear()
	end
end

return var0_0
