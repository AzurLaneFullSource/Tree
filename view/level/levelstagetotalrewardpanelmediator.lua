local var0_0 = class("LevelStageTotalRewardPanelMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(LevelMediator2.ON_RETRACKING, function(arg0_2, ...)
		local var0_2 = packEx(...)

		arg0_1:sendNotification(LevelMediator2.ON_RETRACKING, var0_2)
	end)
end

return var0_0
