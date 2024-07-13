local var0_0 = class("MetaCharacterEnergyMediator", import("...base.ContextMediator"))

var0_0.ON_ACTIVATION = "MetaCharacterEnergyMediator:ON_ACTIVATION"
var0_0.ON_PREVIEW = "MetaCharacterEnergyMediator:ON_PREVIEW"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ACTIVATION, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.ENERGY_META_ACTIVATION, {
			shipId = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_PREVIEW, function(arg0_3, arg1_3, arg2_3)
		local var0_3 = {
			equipSkinId = 0,
			shipVO = arg1_3,
			weaponIds = arg2_3
		}

		arg0_1:addSubLayers(Context.New({
			viewComponent = ShipPreviewLayer,
			mediator = ShipPreviewMediator,
			data = var0_3
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.ENERGY_META_ACTIVATION_DONE,
		BayProxy.SHIP_UPDATED,
		BagProxy.ITEM_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.ENERGY_META_ACTIVATION_DONE then
		arg0_5:addSubLayers(Context.New({
			viewComponent = ShipBreakResultLayer,
			mediator = ShipBreakResultMediator,
			data = {
				newShip = var1_5.newShip,
				oldShip = var1_5.oldShip
			}
		}))
		arg0_5.viewComponent:updateData()
		arg0_5.viewComponent:updateNamePanel()
		arg0_5.viewComponent:updateAttrPanel()
		arg0_5.viewComponent:updateMaterialPanel()
		arg0_5.viewComponent:initPreviewPanel()
	end
end

return var0_0
