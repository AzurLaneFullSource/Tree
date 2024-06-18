local var0_0 = class("EquipmentSkinMediator", import("..base.ContextMediator"))

var0_0.ON_EQUIP = "EquipmentSkinMediator:ON_EQUIP"
var0_0.ON_UNEQUIP = "EquipmentSkinMediator:ON_UNEQUIP"
var0_0.ON_SELECT = "EquipmentSkinMediator:ON_SELECT"
var0_0.ON_PREVIEW = "EquipmentSkinMediator:ON_PREVIEW"
var0_0.ON_EQUIP_FORM_SHIP = "EquipmentSkinMediator:ON_EQUIP_FORM_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_EQUIP, function(arg0_2)
		arg0_1:sendNotification(EquipmentMediator.NO_UPDATE)
		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos,
			equipmentSkinId = arg0_1.contextData.skinId
		})
	end)
	arg0_1:bind(var0_0.ON_EQUIP_FORM_SHIP, function(arg0_3)
		if not arg0_1.contextData.oldShipInfo then
			return
		end

		local var0_3 = arg0_1.contextData.oldShipInfo.id
		local var1_3, var2_3 = ShipStatus.ShipStatusCheck("onModify", getProxy(BayProxy):getShipById(var0_3))

		if not var1_3 then
			pg.TipsMgr.GetInstance():ShowTips(var2_3)

			return
		end

		local var3_3 = arg0_1.contextData.oldShipInfo

		assert(var3_3.id, "old ship id is nil")
		assert(var3_3.pos, "old ship pos is nil")
		assert(arg0_1.contextData.shipId, "new ship id nil")
		assert(arg0_1.contextData.pos, "new ship id nil")
		arg0_1:sendNotification(EquipmentMediator.NO_UPDATE)
		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP, {
			oldShipId = var3_3.id,
			oldShipPos = var3_3.pos,
			newShipId = arg0_1.contextData.shipId,
			newShipPos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP, function(arg0_4)
		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)

	if arg0_1.contextData.shipId then
		local var0_1 = getProxy(BayProxy):getShipById(arg0_1.contextData.shipId)

		arg0_1.viewComponent:setShip(var0_1)
		arg0_1:bind(var0_0.ON_SELECT, function(arg0_5, arg1_5)
			local var0_5 = ShipMainMediator:getEquipmentSkins(var0_1, arg1_5)

			arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
				equipmentVOs = var0_5,
				shipId = arg0_1.contextData.shipId,
				pos = arg1_5,
				warp = StoreHouseConst.WARP_TO_WEAPON,
				mode = StoreHouseConst.SKIN
			})
		end)
	end

	arg0_1:bind(var0_0.ON_PREVIEW, function(arg0_6, arg1_6)
		local var0_6 = pg.equip_skin_template[arg1_6]
		local var1_6 = Ship.New({
			id = var0_6.ship_config_id,
			configId = var0_6.ship_config_id,
			skin_id = var0_6.ship_skin_id
		})
		local var2_6 = {}

		if var0_6.ship_skin_id ~= 0 then
			var2_6 = {
				equipSkinId = 0,
				shipVO = var1_6,
				weaponIds = {},
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		else
			var2_6 = {
				shipVO = var1_6,
				weaponIds = Clone(var0_6.weapon_ids),
				equipSkinId = arg1_6,
				weight = arg0_1.contextData.weight and arg0_1.contextData.weight + 1
			}
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = EquipmentSkinPreviewWindow,
			mediator = ShipPreviewMediator,
			data = var2_6
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_7)
	return {}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()
end

return var0_0
