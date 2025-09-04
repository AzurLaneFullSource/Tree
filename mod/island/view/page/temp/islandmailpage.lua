local var0_0 = class("IslandMailPage", import(".IslandExternalBridgePage"))

function var0_0.GetContext(arg0_1)
	return Context.New({
		mediator = MailMediator,
		viewComponent = IslandMailScene
	})
end

return var0_0
