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
var0_0.DESIGN_FILTER_CHANGED = "EquipmentMediator:DESIGN_FILTER_CHANGED"

function var0_0.register(arg0_1)
	if not arg0_1.contextData.warp then
		local var0_1 = getProxy(SettingsProxy):getEquipSceneIndex()

		arg0_1.contextData.warp = var0_1
	end

	arg0_1:bind(var0_0.DESIGN_FILTER_CHANGED, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TOGGLE_ALL_DESIGN_EQUIPMENT, arg1_2)
	end)
	arg0_1:bind(var0_0.ITEM_GO_SCENE, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, arg2_3)
	end)
	arg0_1:bind(var0_0.ITEM_ADD_LAYER, function(arg0_4, arg1_4)
		arg0_1:addSubLayers(arg1_4)
	end)
	arg0_1:bind(var0_0.ON_USE_ITEM, function(arg0_5, arg1_5, arg2_5, arg3_5)
		arg0_1:sendNotification(GAME.USE_ITEM, {
			id = arg1_5,
			count = arg2_5,
			arg = arg3_5
		})
	end)
	arg0_1:bind(var0_0.ON_DESTROY, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.DESTROY_EQUIPMENTS, {
			equipments = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT, function(arg0_7)
		arg0_1.canUpdate = false

		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_DESIGN, function(arg0_8)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator) then
			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = EquipmentDesignLayer,
			mediator = EquipmentDesignMediator,
			data = {
				groupName = arg0_1.viewComponent:getGroupName(),
				isShowAllDesign = arg0_1.viewComponent.isShowAllDesign
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_DESIGN_LAYER, function(arg0_9)
		local var0_9 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(EquipmentDesignMediator)

		if var0_9 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_9
			})
		end
	end)
	arg0_1:bind(var0_0.OPEN_SPWEAPON_DESIGN, function(arg0_10)
		if getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator) then
			return
		end

		arg0_1:addSubLayers(Context.New({
			viewComponent = SpWeaponDesignLayer,
			mediator = SpWeaponDesignMediator,
			data = {
				groupName = arg0_1.viewComponent:getGroupName()
			}
		}))
	end)
	arg0_1:bind(var0_0.CLOSE_SPWEAPON_DESIGN_LAYER, function(arg0_11)
		local var0_11 = getProxy(ContextProxy):getContextByMediator(EquipmentMediator):getContextByMediator(SpWeaponDesignMediator)

		if var0_11 then
			arg0_1:sendNotification(GAME.REMOVE_LAYERS, {
				context = var0_11
			})
		end
	end)
	arg0_1:bind(var0_0.ON_EQUIPMENT_SKIN_INFO, function(arg0_12, arg1_12, arg2_12, arg3_12)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipmentSkinMediator,
			viewComponent = EquipmentSkinLayer,
			data = {
				skinId = arg1_12,
				shipId = arg0_1.contextData.shipId,
				mode = arg0_1.contextData.shipId and EquipmentSkinLayer.REPLACE or EquipmentSkinLayer.DISPLAY,
				oldShipInfo = arg3_12,
				pos = arg2_12
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_UNEQUIP_EQUIPMENT_SKIN, function(arg0_13)
		arg0_1.canUpdate = false

		arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
			equipmentSkinId = 0,
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPSKIN_INDEX_LAYER, function(arg0_14, arg1_14)
		arg0_1:addSubLayers(Context.New({
			mediator = IndexMediator,
			viewComponent = IndexLayer,
			data = arg1_14
		}))
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_15, arg1_15)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_15
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

function var0_0.UpdateSpWeapons(arg0_16)
	local var0_16 = getProxy(BayProxy):RawGetShipById(arg0_16.contextData.shipId)
	local var1_16 = getProxy(BayProxy):GetSpWeaponsInShips(var0_16)
	local var2_16 = _.values(getProxy(EquipmentProxy):GetSpWeapons())

	for iter0_16, iter1_16 in ipairs(var2_16) do
		if not var0_16 or not var0_16:IsSpWeaponForbidden(iter1_16) then
			table.insert(var1_16, iter1_16)
		end
	end

	arg0_16.viewComponent:SetSpWeapons(var1_16)
end

function var0_0.listNotificationInterests(arg0_17)
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
		EquipmentProxy.SPWEAPONS_UPDATED,
		GAME.LOVE_ITEM_MAIL_REPAIR_DONE,
		GAME.SELL_ITEM_DONE
	}
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0_18.viewComponent:setCapacity(arg0_18.equipmentProxy:getCapacity())
		arg0_18.viewComponent:setEquipment(var1_18)

		if arg0_18.canUpdate then
			arg0_18.viewComponent:setEquipmentUpdate()
		end
	elseif var0_18 == BayProxy.SHIP_EQUIPMENT_ADDED then
		arg0_18.viewComponent:addShipEquipment(var1_18)

		if arg0_18.canUpdate then
			arg0_18.viewComponent:setEquipmentUpdate()
		end
	elseif var0_18 == BayProxy.SHIP_EQUIPMENT_REMOVED then
		arg0_18.viewComponent:removeShipEquipment(var1_18)

		if arg0_18.canUpdate then
			arg0_18.viewComponent:setEquipmentUpdate()
		end
	elseif var0_18 == EquipmentProxy.EQUIPMENT_SKIN_UPDATED then
		arg0_18.viewComponent:setCapacity(arg0_18.equipmentProxy:getCapacity())
		arg0_18.viewComponent:setEquipmentSkin(var1_18)

		if arg0_18.canUpdate then
			arg0_18.viewComponent:setEquipmentSkinUpdate()
		end
	elseif var0_18 == BayProxy.SHIP_UPDATED then
		if var1_18.id == arg0_18.contextData.shipId then
			arg0_18.viewComponent:setShip(var1_18)
		end
	elseif var0_18 == PlayerProxy.UPDATED then
		arg0_18.viewComponent:setPlayer(var1_18)
	elseif var0_18 == GAME.USE_ITEM_DONE then
		if #var1_18.drops > 0 then
			arg0_18.viewComponent:emit(BaseUI.ON_WORLD_ACHIEVE, {
				animation = true,
				items = var1_18.drops,
				removeFunc = function()
					if var1_18.isEquipBox then
						local var0_19 = underscore.map(var1_18.drops, function(arg0_20)
							return Equipment.New({
								id = arg0_20.id,
								count = arg0_20.count
							})
						end)

						arg0_18:addSubLayers(Context.New({
							viewComponent = ResolveEquipmentLayer,
							mediator = ResolveEquipmentMediator,
							data = {
								Equipments = var0_19
							}
						}))
					end
				end
			})
		end
	elseif var0_18 == GAME.FRAG_SELL_DONE then
		arg0_18.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_18.awards)
	elseif var0_18 == GAME.DESTROY_EQUIPMENTS_DONE then
		arg0_18.canUpdate = true

		arg0_18.viewComponent:setEquipmentUpdate()

		if #var1_18 > 0 then
			arg0_18.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_18
			})
		end
	elseif var0_18 == BagProxy.ITEM_UPDATED then
		if arg0_18.canUpdate then
			local var2_18 = getProxy(BagProxy):getItemsByExclude()

			arg0_18.viewComponent:setItems(var2_18)
		end
	elseif var0_18 == var0_0.BATCHDESTROY_MODE then
		arg0_18.viewComponent:SwitchToDestroy()
	elseif var0_18 == var0_0.SWITCH_TO_SPWEAPON_PAGE then
		arg0_18.viewComponent:SwitchToSpWeaponStoreHouse()
	elseif var0_18 == GAME.REVERT_EQUIPMENT_DONE then
		if #var1_18.awards > 0 then
			arg0_18.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_18.awards
			})
		end
	elseif var0_18 == GAME.EQUIP_TO_SHIP_DONE or var0_18 == GAME.UNEQUIP_FROM_SHIP_DONE then
		arg0_18.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_18 == GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP_DONE or var0_18 == GAME.EQUIP_EQUIPMENTSKIN_FROM_SHIP_DONE then
		arg0_18.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_18 == var0_0.NO_UPDATE then
		arg0_18.canUpdate = false
	elseif var0_18 == GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED then
		arg0_18:getViewComponent():Scroll2Equip(var1_18.newEquip)
	elseif var0_18 == EquipmentProxy.SPWEAPONS_UPDATED then
		arg0_18:UpdateSpWeapons()
		arg0_18.viewComponent:SetSpWeaponUpdate()
	elseif var0_18 == GAME.LOVE_ITEM_MAIL_REPAIR_DONE then
		if #var1_18.awards > 0 then
			arg0_18.viewComponent:emit(BaseUI.ON_AWARD, {
				items = var1_18.awards
			})
		end
	elseif var0_18 == GAME.SELL_ITEM_DONE then
		arg0_18.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_18.awards)
	end
end

function var0_0.remove(arg0_21)
	getProxy(SettingsProxy):setEquipSceneIndex(arg0_21.contextData.warp)
end

return var0_0
