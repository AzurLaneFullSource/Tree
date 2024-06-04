local var0 = class("StoreHouseMediatorTransformVer", import("view.base.ContextMediator"))

var0.ON_DESTROY = "EquipmentMediator:ON_DESTROY"
var0.ON_UNEQUIP_EQUIPMENT = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT"
var0.OPEN_DESIGN = "EquipmentMediator:OPEN_DESIGN"
var0.CLOSE_DESIGN_LAYER = "EquipmentMediator:CLOSE_DESIGN_LAYER"
var0.BATCHDESTROY_MODE = "EquipmentMediator:BATCHDESTROY_MODE"
var0.ON_EQUIPMENT_SKIN_INFO = "EquipmentMediator:ON_EQUIPMENT_SKIN_INFO"
var0.ON_UNEQUIP_EQUIPMENT_SKIN = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT_SKIN"
var0.ON_USE_ITEM = "EquipmentMediator:ON_USE_ITEM"
var0.NO_UPDATE = "EquipmentMediator:NO_UPDATE"
var0.ITEM_GO_SCENE = "item go scene"
var0.OPEN_EQUIPSKIN_INDEX_LAYER = "EquipmentMediator:OPEN_EQUIPSKIN_INDEX_LAYER"
var0.OPEN_EQUIPMENT_INDEX = "OPEN_EQUIPMENT_INDEX"

function var0.register(arg0)
	if not arg0.contextData.warp then
		local var0 = getProxy(SettingsProxy):getEquipSceneIndex()

		arg0.contextData.warp = var0
	end

	arg0:bind(var0.ITEM_GO_SCENE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, arg1, arg2)
	end)
	arg0:bind(var0.ON_USE_ITEM, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.USE_ITEM, {
			id = arg1,
			count = arg2,
			arg = arg3
		})
	end)
	arg0:bind(var0.ON_DESTROY, function(arg0, arg1)
		arg0:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1
		})
	end)
	arg0:bind(var0.ON_UNEQUIP_EQUIPMENT, function(arg0)
		arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos
		})
	end)
	arg0:bind(var0.OPEN_DESIGN, function(arg0)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator) then
			return
		end

		arg0:addSubLayers(Context.New({
			viewComponent = EquipmentDesignLayer,
			mediator = EquipmentDesignMediator,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			}
		}))
	end)
	arg0:bind(var0.CLOSE_DESIGN_LAYER, function(arg0)
		local var0 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator)

		if var0 then
			arg0:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0
			})
		end
	end)
	arg0:bind(var0.ON_EQUIPMENT_SKIN_INFO, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = EquipmentSkinMediator,
			viewComponent = EquipmentSkinLayer,
			data = {
				skinId = arg1,
				shipId = arg0.contextData.shipId,
				mode = arg0.contextData.shipId and EquipmentSkinLayer.REPLACE or EquipmentSkinLayer.DISPLAY,
				oldShipInfo = arg3,
				pos = arg2
			}
		}))
	end)
	arg0:bind(var0.ON_UNEQUIP_EQUIPMENT_SKIN, function(arg0)
		arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos
		})
	end)
	arg0:bind(var0.OPEN_EQUIPSKIN_INDEX_LAYER, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = IndexMediator,
			viewComponent = IndexLayer,
			data = arg1
		}))
	end)
	arg0:bind(var0.OPEN_EQUIPMENT_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)

	arg0.canUpdate = true

	arg0.viewComponent:OnMediatorRegister()

	arg0.equipmentProxy = getProxy(EquipmentProxy)

	local var1 = arg0.contextData.sourceVOs

	arg0.viewComponent:setSources(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		var0.NO_UPDATE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == var0.NO_UPDATE then
		arg0.canUpdate = false
	end
end

function var0.remove(arg0)
	getProxy(SettingsProxy):setEquipSceneIndex(arg0.contextData.warp)
end

return var0
