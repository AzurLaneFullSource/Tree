local var0_0 = class("CardPuzzleCombatPauseMediator", ContextMediator)

var0_0.QUIT_COMBAT = "QUIT_COMBAT"
var0_0.RESUME_COMBAT = "RESUME_COMBAT"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.QUIT_COMBAT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.QUIT_BATTLE)
	end)
	arg0_1:bind(var0_0.RESUME_COMBAT, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.RESUME_BATTLE)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {}
end

function var0_0.remove(arg0_5)
	return
end

function var0_0.onBackPressed(arg0_6, arg1_6)
	arg0_6:sendNotification(GAME.RESUME_BATTLE)
	var0_0.super.onBackPressed(arg0_6, arg1_6)
end

return var0_0
