local var0 = class("LevelStageTotalRewardPanelMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	arg0:bind(LevelMediator2.ON_RETRACKING, function(arg0, ...)
		local var0 = packEx(...)

		arg0:sendNotification(LevelMediator2.ON_RETRACKING, var0)
	end)
end

return var0
