local var0 = class("SuperBulinPopMediator", import("..base.ContextMediator"))

var0.ON_SIMULATION_COMBAT = "event simulation combat"

function var0.register(arg0)
	arg0:bind(var0.ON_SIMULATION_COMBAT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1.stageId,
			warnMsg = arg1.warnMsg,
			exitCallback = arg2
		})
	end)
end

return var0
