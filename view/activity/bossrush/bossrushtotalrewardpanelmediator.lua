local var0_0 = class("BossRushTotalRewardPanelMediator", import("view.activity.worldboss.ActivityBossTotalRewardPanelMediator"))

var0_0.ON_WILL_EXIT = "BossRushTotalRewardPanelMediator:ON_WILL_EXIT"
var0_0.GET_NEW_SHIP = "BossRushTotalRewardPanelMediator:GET_NEW_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_NEW_SHIP, function(arg0_2, arg1_2, arg2_2)
		arg0_1:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1_2
			},
			onRemoved = arg2_2
		}))
	end)
	getProxy(SettingsProxy):ResetContinuousOperationAutoSub()
end

return var0_0
