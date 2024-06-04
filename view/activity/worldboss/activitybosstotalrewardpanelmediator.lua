local var0 = class("ActivityBossTotalRewardPanelMediator", import("view.base.ContextMediator"))

function var0.register(arg0)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0
