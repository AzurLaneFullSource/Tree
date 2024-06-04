local var0 = class("CombatLoadMediator", import("..base.ContextMediator"))

var0.FINISH = "CombatLoadMediator:FINISH"

function var0.register(arg0)
	arg0:bind(var0.FINISH, function(arg0, arg1)
		arg0.contextData.loadObs = arg1
		arg0.contextData.prePause = arg0._prePauseBattle

		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.BATTLE, arg0.contextData)
	end)
end

function var0.remove(arg0)
	return
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.PAUSE_BATTLE,
		GAME.STOP_BATTLE_LOADING
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.PAUSE_BATTLE then
		arg0._prePauseBattle = true
	elseif var0 == GAME.STOP_BATTLE_LOADING then
		ys.Battle.BattleResourceManager.GetInstance():Clear()
	end
end

return var0
