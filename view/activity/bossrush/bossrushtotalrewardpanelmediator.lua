local var0_0 = class("BossRushTotalRewardPanelMediator", import("view.activity.worldboss.ActivityBossTotalRewardPanelMediator"))

var0_0.ON_WILL_EXIT = "BossRushTotalRewardPanelMediator:ON_WILL_EXIT"

function var0_0.register(arg0_1)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0_0
