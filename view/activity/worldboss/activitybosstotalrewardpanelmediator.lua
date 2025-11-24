local var0_0 = class("ActivityBossTotalRewardPanelMediator", import("view.base.ContextMediator"))

var0_0.GET_NEW_SHIP = "ActivityBossTotalRewardPanelMediator:GET_NEW_SHIP"

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
