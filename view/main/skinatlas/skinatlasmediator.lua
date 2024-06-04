local var0 = class("SkinAtlasMediator", import("...base.ContextMediator"))

var0.OPEN_INDEX = "SkinAtlasMediator:OPEN_INDEX"

function var0.register(arg0)
	arg0:bind(var0.OPEN_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = SkinAtlasIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		SetShipSkinCommand.SKIN_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == SetShipSkinCommand.SKIN_UPDATED then
		arg0.viewComponent:UpdateSkinCards()
	end
end

return var0
