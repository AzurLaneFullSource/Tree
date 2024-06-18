local var0_0 = class("EquipmentMediator", import("..base.ContextMediator"))

var0_0.ON_DESTROY = "EquipmentMediator:ON_DESTROY"
var0_0.ON_UNEQUIP_EQUIPMENT = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT"
var0_0.OPEN_DESIGN = "EquipmentMediator:OPEN_DESIGN"
var0_0.CLOSE_DESIGN_LAYER = "EquipmentMediator:CLOSE_DESIGN_LAYER"
var0_0.OPEN_SPWEAPON_DESIGN = "EquipmentMediator:OPEN_SPWEAPON_DESIGN"
var0_0.CLOSE_SPWEAPON_DESIGN_LAYER = "EquipmentMediator:CLOSE_SPWEAPON_DESIGN_LAYER"
var0_0.BATCHDESTROY_MODE = "EquipmentMediator:BATCHDESTROY_MODE"
var0_0.SWITCH_TO_SPWEAPON_PAGE = "EquipmentMediator:SWITCH_TO_SPWEAPON_PAGE"
var0_0.ON_EQUIPMENT_SKIN_INFO = "EquipmentMediator:ON_EQUIPMENT_SKIN_INFO"
var0_0.ON_UNEQUIP_EQUIPMENT_SKIN = "EquipmentMediator:ON_UNEQUIP_EQUIPMENT_SKIN"
var0_0.ON_USE_ITEM = "EquipmentMediator:ON_USE_ITEM"
var0_0.NO_UPDATE = "EquipmentMediator:NO_UPDATE"
var0_0.ITEM_GO_SCENE = "item go scene"
var0_0.ITEM_ADD_LAYER = "EquipmentMediator.ITEM_ADD_LAYER"
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
	arg0_1:bind(var0_0.ITEM_ADD_LAYER, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(arg1_3)
	end)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_4, arg1_4, arg2_4, arg3_4)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_4,
			count = arg2_4,
			arg = arg3_4
		})
	end)
	arg0_1:bind(var0_0.ON_DESTROY, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1_5
		})
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT, function(arg0_6)
		arg0_1.canUpdate = false

		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_DESIGN, function(arg0_7)
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
	arg0_1:bind(var0_0.CLOSE_DESIGN_LAYER, function(arg0_8)
		local var0_8 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator)

		if var0_8 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_8
			})
		end
	end)
	arg0_1:bind(var0_0.OPEN_SPWEAPON_DESIGN, function(arg0_9)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator) then
			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = SpWeaponDesignLayer,
			mediator = SpWeaponDesignMediator,
			data = {
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_SPWEAPON_DESIGN_LAYER, function(arg0_10)
		local var0_10 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator)

		if var0_10 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_10
			})
		end
	end)
	arg0_1:bind(var0_0.ON_EQUIPMENT_SKIN_INFO, function(arg0_11, arg1_11, arg2_11, arg3_11)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipmentSkinMediator,
			viewComponent = EquipmentSkinLayer,
			data = {
				skinId = arg1_11,
				shipId = arg0_1.contextData.shipId,
				mode = arg0_1.contextData.shipId and EquipmentSkinLayer.REPLACE or EquipmentSkinLayer.DISPLAY,
				oldShipInfo = arg3_11,
				pos = arg2_11
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT_SKIN, function(arg0_12)
		arg0_1.canUpdate = false

		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPSKIN_INDEX_LAYER, function(arg0_13, arg1_13)
		arg0_1:addSubLayers(Context.New({
			mediator = IndexMediator,
			viewComponent = IndexLayer,
			data = arg1_13
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_14, arg1_14)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_14
		}))
	end)

	arg0_1.canUpdate = true

	local var1_1 = getProxy(BayProxy)
	local var2_1 = var1_1:getShipById(arg0_1.contextData.shipId)

	arg0_1.viewComponent:setShip(var2_1)

	if var2_1 then
		if arg0_1.contextData.mode == StoreHouseConst.EQUIPMENT then
			local var3_1 = var2_1:getEquip(arg0_1.contextData.pos)

			arg0_1.contextData.qiutBtn = defaultValue(var3_1, nil)
		elseif arg0_1.contextData.mode == StoreHouseConst.SKIN then
			local var4_1 = var2_1:getEquipSkin(arg0_1.contextData.pos) ~= 0

			arg0_1.contextData.qiutBtn = var4_1
		end
	end

	arg0_1.equipmentProxy = getProxy(EquipmentProxy)

	local var5_1

	if arg0_1.contextData.equipmentVOs then
		var5_1 = arg0_1.contextData.equipmentVOs
	else
		var5_1 = arg0_1.equipmentProxy:getEquipments(true)

		for iter0_1, iter1_1 in ipairs(var1_1:getEquipsInShips()) do
			table.insert(var5_1, iter1_1)
		end

		for iter2_1, iter3_1 in pairs(arg0_1.equipmentProxy:getEquipmentSkins()) do
			table.insert(var5_1, {
				isSkin = true,
				id = iter3_1.id,
				count = iter3_1.count
			})
		end

		for iter4_1, iter5_1 in pairs(var1_1:getEquipmentSkinInShips()) do
			table.insert(var5_1, {
				isSkin = true,
				count = 1,
				id = iter5_1.id,
				shipId = iter5_1.shipId,
				shipPos = iter5_1.shipPos
			})
		end
	end

	arg0_1.viewComponent:setEquipments(var5_1)
	arg0_1.viewComponent:setCapacity(arg0_1.equipmentProxy:getCapacity())
	arg0_1:UpdateSpWeapons()

	local var6_1 = getProxy(BagProxy):getItemsByExclude()

	arg0_1.viewComponent:setItems(var6_1)

	local var7_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var7_1)
end

function var0_0.UpdateSpWeapons(arg0_15)
	local var0_15 = getProxy(BayProxy):RawGetShipById(arg0_15.contextData.shipId)
	local var1_15 = getProxy(BayProxy):GetSpWeaponsInShips(var0_15)
	local var2_15 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0_15, iter1_15 in ipairs(var2_15) do
		if not var0_15 or not var0_15:IsSpWeaponForbidden(iter1_15) then
			table.insert(var1_15, iter1_15)
		end
	end

	arg0_15.viewComponent:SetSpWeapons(var1_15)
end

function var0_0.listNotificationInterests(arg0_16)
	return {
		EquipmentProxy.EQUIPMENT_UPDATED,
		BayProxy.SHIP_EQUIPMENT_ADDED,
		BayProxy.SHIP_EQUIPMENT_REMOVED,
		BayProxy.SHIP_UPDATED,
		PlayerProxy.UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.DESTROY_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		var0_0.BATCHDESTROY_MODE,
		var0_0.SWITCH_TO_SPWEAPON_PAGE,
		GAME.EQUIP_TO_SHIP_DONE,
		GAME.REVERT_EQUIPMENT_DONE,
		EquipmentProxy.EQUIPMENT_SKIN_UPDATED,
		GAME.UNEQUIP_FROM_SHIP_DONE,
		GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE,
		GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE,
		var0_0.NO_UPDATE,
		GAME.FRAG_SELL_DONE,
		GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED,
		EquipmentProxy.SPWEAPONS_UPDATED
	}
end

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()

	if var0_17 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0_17.viewComponent:setCapacity(arg0_17.equipmentProxy:getCapacity())
		arg0_17.viewComponent:setEquipment(var1_17)

		if arg0_17.canUpdate then
			arg0_17.viewComponent:setEquipmentUpdate()
		end
	elseif var0_17 == BayProxy.SHIP_EQUIPMENT_ADDED then
		arg0_17.viewComponent:addShipEquipment(var1_17)

		if arg0_17.canUpdate then
			arg0_17.viewComponent:setEquipmentUpdate()
		end
	elseif var0_17 == BayProxy.SHIP_EQUIPMENT_REMOVED then
		arg0_17.viewComponent:removeShipEquipment(var1_17)

		if arg0_17.canUpdate then
			arg0_17.viewComponent:setEquipmentUpdate()
		end
	elseif var0_17 == EquipmentProxy.EQUIPMENT_SKIN_UPDATED then
		arg0_17.viewComponent:setCapacity(arg0_17.equipmentProxy:getCapacity())
		arg0_17.viewComponent:setEquipmentSkin(var1_17)

		if arg0_17.canUpdate then
			arg0_17.viewComponent:setEquipmentSkinUpdate()
		end
	elseif var0_17 == BayProxy.SHIP_UPDATED then
		if var1_17.id == arg0_17.contextData.shipId then
			arg0_17.viewComponent:setShip(var1_17)
		end
	elseif var0_17 == PlayerProxy.UPDATED then
		arg0_17.viewComponent:setPlayer(var1_17)
	elseif var0_17 == GAME.USE_ITEM_DONE then
		if #var1_17 > 0 then
			arg0_17.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
				animation = true,
				items = var1_17
			})
		end
	elseif var0_17 == GAME.FRAG_SELL_DONE then
		arg0_17.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_17.awards)
	elseif var0_17 == GAME.DESTROY_EQUIPMENTS_DONE then
		arg0_17.canUpdate = true

		arg0_17.viewComponent:setEquipmentUpdate()

		if #var1_17 > 0 then
			arg0_17.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_17
			})
		end
	elseif var0_17 == BagProxy.ITEM_UPDATED then
		if arg0_17.canUpdate then
			local var2_17 = getProxy(BagProxy):getItemsByExclude()

			arg0_17.viewComponent:setItems(var2_17)
		end
	elseif var0_17 == var0_0.BATCHDESTROY_MODE then
		arg0_17.viewComponent:SwitchToDestroy()
	elseif var0_17 == var0_0.SWITCH_TO_SPWEAPON_PAGE then
		arg0_17.viewComponent:SwitchToSpWeaponStoreHouse()
	elseif var0_17 == GAME.REVERT_EQUIPMENT_DONE then
		if #var1_17.awards > 0 then
			arg0_17.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_17.awards
			})
		end
	elseif var0_17 == GAME.EQUIP_TO_SHIP_DONE or var0_17 == GAME.UNEQUIP_FROM_SHIP_DONE then
		arg0_17.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_17 == GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE or var0_17 == GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE then
		arg0_17.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_17 == var0_0.NO_UPDATE then
		arg0_17.canUpdate = false
	elseif var0_17 == GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED then
		arg0_17:getViewComponent():Scroll2Equip(var1_17.newEquip)
	elseif var0_17 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0_17:UpdateSpWeapons()
		arg0_17.viewComponent:SetSpWeaponUpdate()
	end
end

function var0_0.remove(arg0_18)
	getProxy(SettingsProxy):setEquipSceneIndex(arg0_18.contextData.warp)
end

return var0_0
