local var0_0 = class("SkinAtlasMediator", import("...base.ContextMediator"))

var0_0.OPEN_INDEX = "SkinAtlasMediator:OPEN_INDEX"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_INDEX, function(arg0_2, arg1_2)
		arg0_1:addSubLayers(Context.New({
			viewComponent = SkinAtlasIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_2
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		SetShipSkinCommand.SKIN_UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == SetShipSkinCommand.SKIN_UPDATED then
		arg0_4.viewComponent:UpdateSkinCards()
	end
end

return var0_0
