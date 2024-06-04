local var0 = class("CardPuzzleCombatPauseMediator", ContextMediator)

var0.QUIT_COMBAT = "QUIT_COMBAT"
var0.RESUME_COMBAT = "RESUME_COMBAT"

function var0.register(arg0)
	arg0:bind(var0.QUIT_COMBAT, function(arg0, arg1)
		arg0:sendNotification(GAME.QUIT_BATTLE)
	end)
	arg0:bind(var0.RESUME_COMBAT, function(arg0, arg1)
		arg0:sendNotification(GAME.RESUME_BATTLE)
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.remove(arg0)
	return
end

function var0.onBackPressed(arg0, arg1)
	arg0:sendNotification(GAME.RESUME_BATTLE)
	var0.super.onBackPressed(arg0, arg1)
end

return var0
