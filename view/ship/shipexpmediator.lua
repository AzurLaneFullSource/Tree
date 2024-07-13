local var0_0 = class("ShipExpMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1.contextData.type = arg0_1.contextData.type or ShipExpLayer.TypeDefault
end

return var0_0
