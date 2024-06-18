local var0_0 = class("BossSingleTotalRewardPanelMediator", import("view.activity.worldboss.ActivityBossTotalRewardPanelMediator"))

function var0_0.register(arg0_1)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0_0
