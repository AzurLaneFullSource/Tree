local var0 = class("EquipmentMediator", import("..base.ContextMediator"))

var0.ON_DESTROY = "EquipmentMediator:ON_DESTROY"
var0.ON_UNEQUIP_EQUIPMENT = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT"
var0.OPEN_DESIGN = "EquipmentMediator:OPEN_DESIGN"
var0.CLOSE_DESIGN_LAYER = "EquipmentMediator:CLOSE_DESIGN_LAYER"
var0.OPEN_SPWEAPON_DESIGN = "EquipmentMediator:OPEN_SPWEAPON_DESIGN"
var0.CLOSE_SPWEAPON_DESIGN_LAYER = "EquipmentMediator:CLOSE_SPWEAPON_DESIGN_LAYER"
var0.BATCHDESTROY_MODE = "EquipmentMediator:BATCHDESTROY_MODE"
var0.SWITCH_TO_SPWEAPON_PAGE = "EquipmentMediator:SWITCH_TO_SPWEAPON_PAGE"
var0.ON_EQUIPMENT_SKIN_INFO = "EquipmentMediator:ON_EQUIPMENT_SKIN_INFO"
var0.ON_UNEQUIP_EQUIPMENT_SKIN = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT_SKIN"
var0.ON_USE_ITEM = "EquipmentMediator:ON_USE_ITEM"
var0.NO_UPDATE = "EquipmentMediator:NO_UPDATE"
var0.ITEM_GO_SCENE = "item go scene"
var0.ITEM_ADD_LAYER = "EquipmentMediator.ITEM_ADD_LAYER"
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
	arg0:bind(var0.ITEM_ADD_LAYER, function(arg0, arg1)
		arg0:addSubLayers(arg1)
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
		arg0.canUpdate = false

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
	arg0:bind(var0.OPEN_SPWEAPON_DESIGN, function(arg0)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator) then
			return
		end

		arg0:addSubLayers(Context.New({
			viewComponent = SpWeaponDesignLayer,
			mediator = SpWeaponDesignMediator,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			}
		}))
	end)
	arg0:bind(var0.CLOSE_SPWEAPON_DESIGN_LAYER, function(arg0)
		local var0 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator)

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
		arg0.canUpdate = false

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

	local var1 = getProxy(BayProxy)
	local var2 = var1:getShipById(arg0.contextData.shipId)

	arg0.viewComponent:setShip(var2)

	if var2 then
		if arg0.contextData.mode == StoreHouseConst.EQUIPMENT then
			local var3 = var2:getEquip(arg0.contextData.pos)

			arg0.contextData.qiutBtn = defaultValue(var3, nil)
		elseif arg0.contextData.mode == StoreHouseConst.SKIN then
			local var4 = var2:getEquipSkin(arg0.contextData.pos) ~= 0

			arg0.contextData.qiutBtn = var4
		end
	end

	arg0.equipmentProxy = getProxy(EquipmentProxy)

	local var5

	if arg0.contextData.equipmentVOs then
		var5 = arg0.contextData.equipmentVOs
	else
		var5 = arg0.equipmentProxy:getEquipments(true)

		for iter0, iter1 in ipairs(var1:getEquipsInShips()) do
			table.insert(var5, iter1)
		end

		for iter2, iter3 in pairs(arg0.equipmentProxy:getEquipmentSkins()) do
			table.insert(var5, {
				isSkin = true,
				id = iter3.id,
				count = iter3.count
			})
		end

		for iter4, iter5 in pairs(var1:getEquipmentSkinInShips()) do
			table.insert(var5, {
				isSkin = true,
				count = 1,
				id = iter5.id,
				shipId = iter5.shipId,
				shipPos = iter5.shipPos
			})
		end
	end

	arg0.viewComponent:setEquipments(var5)
	arg0.viewComponent:setCapacity(arg0.equipmentProxy:getCapacity())
	arg0:UpdateSpWeapons()

	local var6 = getProxy(BagProxy):getItemsByExclude()

	arg0.viewComponent:setItems(var6)

	local var7 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var7)
end

function var0.UpdateSpWeapons(arg0)
	local var0 = getProxy(BayProxy):RawGetShipById(arg0.contextData.shipId)
	local var1 = getProxy(BayProxy):GetSpWeaponsInShips(var0)
	local var2 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0, iter1 in ipairs(var2) do
		if not var0 or not var0:IsSpWeaponForbidden(iter1) then
			table.insert(var1, iter1)
		end
	end

	arg0.viewComponent:SetSpWeapons(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		EquipmentProxy.EQUIPMENT_UPDATED,
		BayProxy.SHIP_EQUIPMENT_ADDED,
		BayProxy.SHIP_EQUIPMENT_REMOVED,
		BayProxy.SHIP_UPDATED,
		PlayerProxy.UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.DESTROY_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		var0.BATCHDESTROY_MODE,
		var0.SWITCH_TO_SPWEAPON_PAGE,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.REVERT_EQUIPMENT_DONE,
		EquipmentProxy.EQUIPMENT_SKIN_UPDATED,
		GAME.UNEQUIP_FROM_SHIP_DONE,
		GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE,
		GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE,
		var0.NO_UPDATE,
		GAME.FRAG_SELL_DONE,
		GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0.viewComponent:setCapacity(arg0.equipmentProxy:getCapacity())
		arg0.viewComponent:setEquipment(var1)

		if arg0.canUpdate then
			arg0.viewComponent:setEquipmentUpdate()
		end
	elseif var0 == BayProxy.SHIP_EQUIPMENT_ADDED then
		arg0.viewComponent:addShipEquipment(var1)

		if arg0.canUpdate then
			arg0.viewComponent:setEquipmentUpdate()
		end
	elseif var0 == BayProxy.SHIP_EQUIPMENT_REMOVED then
		arg0.viewComponent:removeShipEquipment(var1)

		if arg0.canUpdate then
			arg0.viewComponent:setEquipmentUpdate()
		end
	elseif var0 == EquipmentProxy.EQUIPMENT_SKIN_UPDATED then
		arg0.viewComponent:setCapacity(arg0.equipmentProxy:getCapacity())
		arg0.viewComponent:setEquipmentSkin(var1)

		if arg0.canUpdate then
			arg0.viewComponent:setEquipmentSkinUpdate()
		end
	elseif var0 == BayProxy.SHIP_UPDATED then
		if var1.id == arg0.contextData.shipId then
			arg0.viewComponent:setShip(var1)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.USE_ITEM_DONE then
		if #var1 > 0 then
			arg0.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
				animation = true,
				items = var1
			})
		end
	elseif var0 == GAME.FRAG_SELL_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
	elseif var0 == GAME.DESTROY_EQUIPMENTS_DONE then
		arg0.canUpdate = true

		arg0.viewComponent:setEquipmentUpdate()

		if #var1 > 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1
			})
		end
	elseif var0 == BagProxy.ITEM_UPDATED then
		if arg0.canUpdate then
			local var2 = getProxy(BagProxy):getItemsByExclude()

			arg0.viewComponent:setItems(var2)
		end
	elseif var0 == var0.BATCHDESTROY_MODE then
		arg0.viewComponent:SwitchToDestroy()
	elseif var0 == var0.SWITCH_TO_SPWEAPON_PAGE then
		arg0.viewComponent:SwitchToSpWeaponStoreHouse()
	elseif var0 == GAME.REVERT_EQUIPMENT_DONE then
		if #var1.awards > 0 then
			arg0.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1.awards
			})
		end
	elseif var0 == GAME.EQUIP_TO_SHIP_DONE or var0 == GAME.UNEQUIP_FROM_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0 == GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE or var0 == GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0 == var0.NO_UPDATE then
		arg0.canUpdate = false
	elseif var0 == GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED then
		arg0:getViewComponent():Scroll2Equip(var1.newEquip)
	elseif var0 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0:UpdateSpWeapons()
		arg0.viewComponent:SetSpWeaponUpdate()
	end
end

function var0.remove(arg0)
	getProxy(SettingsProxy):setEquipSceneIndex(arg0.contextData.warp)
end

return var0
