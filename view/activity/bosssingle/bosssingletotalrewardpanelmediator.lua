local var0 = class("BossSingleTotalRewardPanelMediator", import("view.activity.worldboss.ActivityBossTotalRewardPanelMediator"))

function var0.register(arg0)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0
