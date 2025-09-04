local var0_0 = class("IslandSettingsPage", import(".IslandExternalBridgePage"))

function var0_0.GetContext(arg0_1)
	return Context.New({
		mediator = NewSettingsMediator,
		viewComponent = IslandSettingsScene
	})
end

return var0_0
