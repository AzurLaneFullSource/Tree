local var0_0 = class("SuperBulinPopMediator", import("..base.ContextMediator"))

var0_0.ON_SIMULATION_COMBAT = "event simulation combat"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_SIMULATION_COMBAT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_SIMULATION,
			stageId = arg1_2.stageId,
			warnMsg = arg1_2.warnMsg,
			exitCallback = arg2_2
		})
	end)
end

return var0_0
