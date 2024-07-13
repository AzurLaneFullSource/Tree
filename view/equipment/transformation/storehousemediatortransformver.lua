local var0_0 = class("StoreHouseMediatorTransformVer", import("view.base.ContextMediator"))

var0_0.ON_DESTROY = "EquipmentMediator:ON_DESTROY"
var0_0.ON_UNEQUIP_EQUIPMENT = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT"
var0_0.OPEN_DESIGN = "EquipmentMediator:OPEN_DESIGN"
var0_0.CLOSE_DESIGN_LAYER = "EquipmentMediator:CLOSE_DESIGN_LAYER"
var0_0.BATCHDESTROY_MODE = "EquipmentMediator:BATCHDESTROY_MODE"
var0_0.ON_EQUIPMENT_SKIN_INFO = "EquipmentMediator:ON_EQUIPMENT_SKIN_INFO"
var0_0.ON_UNEQUIP_EQUIPMENT_SKIN = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT_SKIN"
var0_0.ON_USE_ITEM = "EquipmentMediator:ON_USE_ITEM"
var0_0.NO_UPDATE = "EquipmentMediator:NO_UPDATE"
var0_0.ITEM_GO_SCENE = "item go scene"
var0_0.OPEN_EQUIPSKIN_INDEX_LAYER = "EquipmentMediator:OPEN_EQUIPSKIN_INDEX_LAYER"
var0_0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0_0.register(arg0_1)
	if not arg0_1.contextData.warp then
		local var0_1 = getProxy(SettingsProxy):getEquipSceneIndex()

		arg0_1.contextData.warp = var0_1
	end

	arg0_1:bind(var0_0.ITEM_GO_SCENE, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_2, arg2_2)
	end)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_3,
			count = arg2_3,
			arg = arg3_3
		})
	end)
	arg0_1:bind(var0_0.ON_DESTROY, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT, function(arg0_5)
		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_DESIGN, function(arg0_6)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator) then
			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = EquipmentDesignLayer,
			mediator = EquipmentDesignMediator,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_DESIGN_LAYER, function(arg0_7)
		local var0_7 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator)

		if var0_7 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_7
			})
		end
	end)
	arg0_1:bind(var0_0.ON_EQUIPMENT_SKIN_INFO, function(arg0_8, arg1_8, arg2_8, arg3_8)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipmentSkinMediator,
			viewComponent = EquipmentSkinLayer,
			data = {
				skinId = arg1_8,
				shipId = arg0_1.contextData.shipId,
				mode = arg0_1.contextData.shipId and EquipmentSkinLayer.REPLACE or EquipmentSkinLayer.DISPLAY,
				oldShipInfo = arg3_8,
				pos = arg2_8
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT_SKIN, function(arg0_9)
		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPSKIN_INDEX_LAYER, function(arg0_10, arg1_10)
		arg0_1:addSubLayers(Context.New({
			mediator = IndexMediator,
			viewComponent = IndexLayer,
			data = arg1_10
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_11, arg1_11)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_11
		}))
	end)

	arg0_1.canUpdate = true

	arg0_1.viewComponent:OnMediatorRegister()

	arg0_1.equipmentProxy = getProxy(EquipmentProxy)

	local var1_1 = arg0_1.contextData.sourceVOs

	arg0_1.viewComponent:setSources(var1_1)
end

function var0_0.listNotificationInterests(arg0_12)
	return {
		PlayerProxy.UPDATED,
		var0_0.NO_UPDATE
	}
end

function var0_0.handleNotification(arg0_13, arg1_13)
	local var0_13 = arg1_13:getName()
	local var1_13 = arg1_13:getBody()

	if var0_13 == var0_0.NO_UPDATE then
		arg0_13.canUpdate = false
	end
end

function var0_0.remove(arg0_14)
	getProxy(SettingsProxy):setEquipSceneIndex(arg0_14.contextData.warp)
end

return var0_0
