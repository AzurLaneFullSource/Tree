local var0 = class("EquipmentSkinMediator", import("..base.ContextMediator"))

var0.ON_EQUIP = "EquipmentSkinMediator:ON_EQUIP"
var0.ON_UNEQUIP = "EquipmentSkinMediator:ON_UNEQUIP"
var0.ON_SELECT = "EquipmentSkinMediator:ON_SELECT"
var0.ON_PREVIEW = "EquipmentSkinMediator:ON_PREVIEW"
var0.ON_EQUIP_FORM_SHIP = "EquipmentSkinMediator:ON_EQUIP_FORM_SHIP"

function var0.register(arg0)
	arg0:bind(var0.ON_EQUIP, function(arg0)
		arg0:sendNotification(EquipmentMediator.NO_UPDATE)
		arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos,
			equipmentSkinId = arg0.contextData.skinId
		})
	end)
	arg0:bind(var0.ON_EQUIP_FORM_SHIP, function(arg0)
		if not arg0.contextData.oldShipInfo then
			return
		end

		local var0 = arg0.contextData.oldShipInfo.id
		local var1, var2 = ShipStatus.ShipStatusCheck("onModify", getProxy(BayProxy):getShipById(var0))

		if not var1 then
			pg.TipsMgr.GetInstance():ShowTips(var2)

			return
		end

		local var3 = arg0.contextData.oldShipInfo

		assert(var3.id, "old ship id is nil")
		assert(var3.pos, "old ship pos is nil")
		assert(arg0.contextData.shipId, "new ship id nil")
		assert(arg0.contextData.pos, "new ship id nil")
		arg0:sendNotification(EquipmentMediator.NO_UPDATE)
		arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP, {
			oldShipId = var3.id,
			oldShipPos = var3.pos,
			newShipId = arg0.contextData.shipId,
			newShipPos = arg0.contextData.pos
		})
	end)
	arg0:bind(var0.ON_UNEQUIP, function(arg0)
		arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos
		})
	end)

	if arg0.contextData.shipId then
		local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)

		arg0.viewComponent:setShip(var0)
		arg0:bind(var0.ON_SELECT, function(arg0, arg1)
			local var0 = ShipMainMediator:getEquipmentSkins(var0, arg1)

			arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				equipmentVOs = var0,
				shipId = arg0.contextData.shipId,
				pos = arg1,
				warp = StoreHouseConst.WARP_TO_WEAPON,
				mode = StoreHouseConst.SKIN
			})
		end)
	end

	arg0:bind(var0.ON_PREVIEW, function(arg0, arg1)
		local var0 = pg.equip_skin_template[arg1]
		local var1 = Ship.New({
			id = var0.ship_config_id,
			configId = var0.ship_config_id,
			skin_id = var0.ship_skin_id
		})
		local var2 = {}

		if var0.ship_skin_id ~= 0 then
			var2 = {
				equipSkinId = 0,
				shipVO = var1,
				weaponIds = {},
				weight = arg0.contextData.weight and arg0.contextData.weight + 1
			}
		else
			var2 = {
				shipVO = var1,
				weaponIds = Clone(var0.weapon_ids),
				equipSkinId = arg1,
				weight = arg0.contextData.weight and arg0.contextData.weight + 1
			}
		end

		arg0:addSubLayers(Context.New({
			viewComponent = EquipmentSkinPreviewWindow,
			mediator = ShipPreviewMediator,
			data = var2
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
