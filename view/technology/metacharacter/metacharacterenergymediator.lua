local var0 = class("MetaCharacterEnergyMediator", import("...base.ContextMediator"))

var0.ON_ACTIVATION = "MetaCharacterEnergyMediator:ON_ACTIVATION"
var0.ON_PREVIEW = "MetaCharacterEnergyMediator:ON_PREVIEW"

function var0.register(arg0)
	arg0:bind(var0.ON_ACTIVATION, function(arg0, arg1)
		arg0:sendNotification(GAME.ENERGY_META_ACTIVATION, {
			shipId = arg1
		})
	end)
	arg0:bind(var0.ON_PREVIEW, function(arg0, arg1, arg2)
		local var0 = {
			equipSkinId = 0,
			shipVO = arg1,
			weaponIds = arg2
		}

		arg0:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var0
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.ENERGY_META_ACTIVATION_DONE,
		BayProxy.SHIP_UPDATED,
		BagProxy.ITEM_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.ENERGY_META_ACTIVATION_DONE then
		arg0:addSubLayers(Context.New({
			viewComponent = ShipBreakResultLayer,
			mediator = ShipBreakResultMediator,
			data = {
				newShip = var1.newShip,
				oldShip = var1.oldShip
			}
		}))
		arg0.viewComponent:updateData()
		arg0.viewComponent:updateNamePanel()
		arg0.viewComponent:updateAttrPanel()
		arg0.viewComponent:updateMaterialPanel()
		arg0.viewComponent:initPreviewPanel()
	end
end

return var0
