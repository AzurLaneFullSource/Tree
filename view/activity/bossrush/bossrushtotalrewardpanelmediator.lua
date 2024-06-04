local var0 = class("BossRushTotalRewardPanelMediator", import("view.activity.worldboss.ActivityBossTotalRewardPanelMediator"))

var0.ON_WILL_EXIT = "BossRushTotalRewardPanelMediator:ON_WILL_EXIT"

function var0.register(arg0)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0
