local var0 = class("ShipExpMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0.contextData.type = arg0.contextData.type or ShipExpLayer.TypeDefault
end

return var0
