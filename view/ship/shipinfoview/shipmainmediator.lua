local var0_0 = class("ShipMainMediator", import("...base.ContextMediator"))

var0_0.ON_LOCK = "ShipMainMediator:ON_LOCK"
var0_0.ON_TAG = "ShipMainMediator:ON_TAG"
var0_0.ON_UPGRADE = "ShipMainMediator:ON_UPGRADE"
var0_0.ON_MOD = "ShipMainMediator:ON_MOD"
var0_0.ON_SKILL = "ShipMainMediator:ON_SKILL"
var0_0.OPEN_INTENSIFY = "ShipMainMediator:OPEN_INTENSIFY"
var0_0.CLOSE_INTENSIFY = "ShipMainMediator:CLOSE_INTENSIFY"
var0_0.OPEN_EVALUATION = "ShipMainMediator:OPEN_EVALUATION"
var0_0.CLOSE_UPGRADE = "ShipMainMediator:CLOSE_UPGRADE"
var0_0.CHANGE_SKIN = "ShipMainMediator:CHANGE_SKIN"
var0_0.BUY_ITEM = "ShipMainMediator:BUY_ITEM"
var0_0.UNEQUIP_FROM_SHIP_ALL = "ShipMainMediator:UNEQUIP_FROM_SHIP_ALL"
var0_0.UNEQUIP_FROM_SHIP = "ShipMainMediator:UNEQUIP_FROM_SHIP"
var0_0.NEXTSHIP = "ShipMainMediator:NEXTSHIP"
var0_0.ON_NEXTSHIP_PREPARE = "ShipMainMediator:ON_NEXTSHIP_PREPARE"
var0_0.OPEN_ACTIVITY = "ShipMainMediator:OPEN_ACTIVITY"
var0_0.PROPOSE = "ShipMainMediator:PROPOSE"
var0_0.RENAME_SHIP = "ShipMainMediator:RENAME_SHIP"
var0_0.OPEN_REMOULD = "ShipMainMediator:OPEN_REMOULD"
var0_0.CLOSE_REMOULD = "ShipMainMediator:CLOSE_REMOULD"
var0_0.ON_RECORD_EQUIPMENT = "ShipMainMediator:ON_RECORD_EQUIPMENT"
var0_0.ON_SELECT_EQUIPMENT = "ShipMainMediator:ON_SELECT_EQUIPMENT"
var0_0.ON_SELECT_EQUIPMENT_SKIN = "ShipMainMediator:ON_SELECT_EQUIPMENT_SKIN"
var0_0.ON_SKIN_INFO = "ShipMainMediator:ON_SKIN_INFO"
var0_0.ON_UPGRADE_MAX_LEVEL = "ShipMainMediator:ON_UPGRADE_MAX_LEVEL"
var0_0.ON_TECHNOLOGY = "ShipMainMediator:ON_TECHNOLOGY"
var0_0.OPEN_SHIPPROFILE = "ShipMainMediator:OPEN_SHIPPROFILE"
var0_0.ON_META = "ShipMainMediator:ON_META"
var0_0.ON_SEL_COMMANDER = "ShipMainMediator:ON_SEL_COMMANDER"
var0_0.OPEN_EQUIP_UPGRADE = "ShipMainMediator:OPEN_EQUIP_UPGRADE"
var0_0.BUY_ITEM_BY_ACT = "ShipMainMediator:BUY_ITEM_BY_ACT"
var0_0.ON_ADD_SHIP_EXP = "ShipMainMediator:ON_ADD_SHIP_EXP"
var0_0.OPEN_EQUIPMENT_INDEX = "ShipMainMediator:OPEN_EQUIPMENT_INDEX"
var0_0.EQUIP_CHANGE_NOTICE = "ShipMainMediator:EQUIP_CHANGE_NOTICE"
var0_0.ON_SELECT_SPWEAPON = "ShipMainMediator:ON_SELECT_SPWEAPON"
var0_0.OPEN_EQUIP_CODE = "ShipMainMediator:OPEN_EQUIP_CODE"
var0_0.OPEN_EQUIP_CODE_SHARE = "ShipMainMediator:OPEN_EQUIP_CODE_SHARE"

function var0_0.register(arg0_1)
	arg0_1.bayProxy = getProxy(BayProxy)
	arg0_1.contextData.shipVOs = arg0_1.contextData.shipVOs or {}

	local var0_1 = _.detect(arg0_1.contextData.shipVOs, function(arg0_2)
		return arg0_1.contextData.shipId == arg0_2.id
	end)
	local var1_1 = arg0_1.bayProxy:getShipById(arg0_1.contextData.shipId)

	arg0_1.contextData.index = var0_1 and table.indexof(arg0_1.contextData.shipVOs, var0_1) or 1

	arg0_1.viewComponent:setShipList(arg0_1.contextData.shipVOs)
	arg0_1.viewComponent:setSkinList(getProxy(ShipSkinProxy):getSkinList())
	arg0_1.viewComponent:setShip(var1_1)

	if arg0_1.contextData.selectContextData then
		arg0_1.contextData.selectContextData.infoShipId = arg0_1.contextData.shipId
	end

	arg0_1.showTrans = var1_1:isRemoulded()

	local var2_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var2_1)

	local var3_1 = getProxy(ContextProxy)

	arg0_1:bind(var0_0.ON_ADD_SHIP_EXP, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.USE_ADD_SHIPEXP_ITEM, {
			id = arg1_3,
			items = arg2_3
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM_BY_ACT, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1_4,
			cnt = arg2_4
		})
	end)
	arg0_1:bind(var0_0.OPEN_SHIPPROFILE, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIP_PROFILE, {
			showTrans = arg2_5,
			groupId = arg1_5
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENT_INDEX, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_6
		}))
	end)
	arg0_1:bind(var0_0.EQUIP_CHANGE_NOTICE, function(arg0_7, arg1_7)
		arg0_1:sendNotification(arg1_7.notice, arg1_7.data)
	end)
	arg0_1:bind(var0_0.ON_SKIN_INFO, function(arg0_8, arg1_8, arg2_8)
		arg0_1:addSubLayers(Context.New({
			viewComponent = EquipmentSkinLayer,
			mediator = EquipmentSkinMediator,
			data = {
				shipId = arg0_1.contextData.shipId,
				pos = arg1_8,
				mode = EquipmentSkinLayer.DISPLAY,
				skinId = arg2_8
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_RECORD_EQUIPMENT, function(arg0_9, arg1_9, arg2_9, arg3_9)
		arg0_1:sendNotification(GAME.RECORD_SHIP_EQUIPMENT, {
			shipId = arg1_9,
			index = arg2_9,
			type = arg3_9
		})
	end)
	arg0_1:bind(var0_0.OPEN_EVALUATION, function(arg0_10, arg1_10, arg2_10)
		if arg2_10 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_evaluation_tip"))

			return
		end

		arg0_1:sendNotification(GAME.FETCH_EVALUATION, arg1_10)
	end)
	arg0_1:bind(var0_0.ON_SELECT_EQUIPMENT_SKIN, function(arg0_11, arg1_11)
		local var0_11 = var0_0:getEquipmentSkins(arg0_1.viewComponent.shipVO, arg1_11)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			equipmentVOs = var0_11,
			shipId = arg0_1.contextData.shipId,
			pos = arg1_11,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.SKIN
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_EQUIPMENT, function(arg0_12, arg1_12)
		local var0_12 = getProxy(EquipmentProxy):getEquipments(true)
		local var1_12 = getProxy(BayProxy)
		local var2_12 = var1_12:getShipById(arg0_1.contextData.shipId)
		local var3_12 = var1_12:getEquipsInShips(function(arg0_13, arg1_13)
			return var2_12.id ~= arg1_13 and not var2_12:isForbiddenAtPos(arg0_13, arg1_12)
		end)

		for iter0_12, iter1_12 in ipairs(var0_12) do
			if not var2_12:isForbiddenAtPos(iter1_12, arg1_12) then
				table.insert(var3_12, iter1_12)
			end
		end

		_.each(var3_12, function(arg0_14)
			if not var2_12:canEquipAtPos(arg0_14, arg1_12) then
				arg0_14.mask = true
			end
		end)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			lock = true,
			equipmentVOs = var3_12,
			shipId = arg0_1.contextData.shipId,
			pos = arg1_12,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_SPWEAPON, function(arg0_15)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SPWEAPON_STOREHOUSE, {
			lock = true,
			shipId = arg0_1.contextData.shipId,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE, function(arg0_16, arg1_16)
		arg0_1:openUpgrade()
	end)
	arg0_1:bind(var0_0.CLOSE_UPGRADE, function(arg0_17)
		arg0_1:closeUpgrade()
	end)
	arg0_1:bind(var0_0.OPEN_INTENSIFY, function(arg0_18)
		arg0_1:openIntensify()
	end)
	arg0_1:bind(var0_0.CLOSE_INTENSIFY, function(arg0_19)
		arg0_1:closeIntensify()
	end)
	arg0_1:bind(var0_0.ON_LOCK, function(arg0_20, arg1_20, arg2_20)
		arg0_1:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1_20,
			is_locked = arg2_20
		})
	end)
	arg0_1:bind(var0_0.ON_TAG, function(arg0_21, arg1_21, arg2_21)
		arg0_1:sendNotification(GAME.UPDATE_PREFERENCE, {
			shipId = arg1_21,
			tag = arg2_21
		})
	end)
	arg0_1:bind(var0_0.ON_SKILL, function(arg0_22, arg1_22, arg2_22, arg3_22)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2_22,
				skillId = arg1_22,
				shipId = arg0_1.contextData.shipId,
				index = arg3_22,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
			}
		}))
	end)
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_23, arg1_23, arg2_23)
		arg0_1:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = arg1_23,
			skinId = arg2_23
		})
	end)
	arg0_1:bind(var0_0.BUY_ITEM, function(arg0_24, arg1_24, arg2_24)
		arg0_1:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1_24,
			count = arg2_24
		})
	end)
	arg0_1:bind(var0_0.UNEQUIP_FROM_SHIP_ALL, function(arg0_25, arg1_25)
		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP_ALL, {
			shipId = arg1_25
		})
	end)
	arg0_1:bind(var0_0.UNEQUIP_FROM_SHIP, function(arg0_26, arg1_26)
		arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP, arg1_26)
	end)
	arg0_1:bind(var0_0.NEXTSHIP, function(arg0_27, arg1_27)
		arg0_1:nextPage(arg1_27)
	end)
	arg0_1:bind(var0_0.OPEN_ACTIVITY, function(arg0_28, arg1_28)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1_28
		})
	end)
	arg0_1:bind(var0_0.OPEN_REMOULD, function(arg0_29)
		arg0_1:openRemould()
	end)
	arg0_1:bind(var0_0.CLOSE_REMOULD, function(arg0_30)
		arg0_1:closeRemould()
	end)
	arg0_1:bind(var0_0.PROPOSE, function(arg0_31, arg1_31, arg2_31)
		arg0_1:addSubLayers(Context.New({
			mediator = ProposeMediator,
			viewComponent = ProposeUI,
			data = {
				shipId = arg1_31,
				callback = arg2_31
			}
		}))
	end)
	arg0_1:bind(var0_0.RENAME_SHIP, function(arg0_32, arg1_32, arg2_32)
		arg0_1:sendNotification(GAME.RENAME_SHIP, {
			shipId = arg1_32,
			name = arg2_32
		})
	end)
	arg0_1:bind(var0_0.ON_SEL_COMMANDER, function(arg0_33)
		local var0_33 = getProxy(BayProxy):getShipById(arg0_1.contextData.shipId)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.COMMANDPOST, {
			selectedMin = 1,
			selectedMax = 1,
			mode = CommanderCatScene.MODE_SELECT,
			onShip = function(arg0_34)
				if arg0_34.shipId == arg0_1.contextData.shipId then
					return false, i18n("commander_ship_already_equip")
				end

				return true
			end,
			onSelected = function(arg0_35)
				if #arg0_35 == 0 then
					arg0_1.contextData.unequipCommander = true
				else
					arg0_1.contextData.selectedId = arg0_35[1]
				end
			end,
			quitTeam = var0_33:hasCommander()
		})
	end)
	arg0_1:bind(var0_0.ON_UPGRADE_MAX_LEVEL, function(arg0_36, arg1_36)
		arg0_1:sendNotification(GAME.UPGRADE_MAX_LEVEL, {
			shipId = arg1_36
		})
	end)
	arg0_1:bind(var0_0.ON_TECHNOLOGY, function(arg0_37, arg1_37)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
			shipId = arg1_37.id
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIP_UPGRADE, function(arg0_38, arg1_38)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipUpgradeMediator,
			viewComponent = EquipUpgradeLayer,
			data = {
				shipId = arg1_38
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_META, function(arg0_39, arg1_39)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenShipConfigID = arg1_39.configId
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIP_CODE, function(arg0_40, arg1_40)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EQUIP_CODE, {
			shipId = arg0_1.contextData.shipId,
			code = arg1_40.code
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIP_CODE_SHARE, function(arg0_41, arg1_41, arg2_41)
		arg0_1:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipId = arg1_41,
				shipGroupId = arg2_41
			}
		}))
	end)

	if arg0_1.contextData.selectedId then
		arg0_1:sendNotification(GAME.COMMANDER_EQUIP_TO_SHIP, {
			shipId = arg0_1.contextData.shipId,
			commanderId = arg0_1.contextData.selectedId
		})

		arg0_1.contextData.selectedId = nil
	elseif arg0_1.contextData.unequipCommander then
		arg0_1.contextData.unequipCommander = nil

		arg0_1:sendNotification(GAME.COMMANDER_EQUIP_TO_SHIP, {
			commanderId = 0,
			shipId = arg0_1.contextData.shipId
		})
	end

	local var4_1 = getProxy(SettingsProxy):getMaxLevelHelp()

	arg0_1.viewComponent:setMaxLevelHelpFlag(var4_1)
end

function var0_0.getEquipmentSkins(arg0_42, arg1_42, arg2_42)
	if not arg1_42 then
		return {}
	end

	local var0_42 = arg1_42:getEquip(arg2_42)
	local var1_42 = var0_42 and {
		var0_42:getType()
	} or arg1_42:getSkinTypes(arg2_42)
	local var2_42 = getProxy(EquipmentProxy):getSkinsByTypes(var1_42)
	local var3_42 = getProxy(BayProxy):getEquipmentSkinInShips(arg1_42, var1_42)
	local var4_42 = _.map(var3_42, function(arg0_43)
		return {
			isSkin = true,
			count = 1,
			id = arg0_43.id,
			shipId = arg0_43.shipId,
			shipPos = arg0_43.shipPos
		}
	end)
	local var5_42 = _.map(var2_42, function(arg0_44)
		return {
			isSkin = true,
			id = arg0_44.id,
			count = arg0_44.count
		}
	end)

	for iter0_42, iter1_42 in ipairs(var4_42 or {}) do
		table.insert(var5_42, iter1_42)
	end

	return var5_42
end

function var0_0.nextPage(arg0_45, arg1_45, arg2_45)
	if #arg0_45.contextData.shipVOs == 0 then
		return
	end

	local var0_45 = 1
	local var1_45 = 1
	local var2_45 = 1

	if arg1_45 then
		var0_45 = arg0_45.contextData.index + 1
		var1_45 = #arg0_45.contextData.shipVOs
	else
		var0_45 = arg0_45.contextData.index - 1
		var2_45 = -1
	end

	local var3_45

	for iter0_45 = var0_45, var1_45, var2_45 do
		local var4_45 = arg0_45.contextData.shipVOs[iter0_45]

		if var4_45 then
			var3_45 = arg0_45.bayProxy:getShipById(var4_45.id)

			if var3_45 then
				arg0_45.contextData.index = iter0_45
				arg0_45.contextData.shipId = var3_45.id

				break
			end
		end
	end

	if var3_45 == nil then
		if arg2_45 == nil then
			return
		end

		local var5_45 = arg0_45.contextData.shipVOs[arg0_45.contextData.index]

		var3_45 = arg0_45.bayProxy:getShipById(var5_45.id)
		arg0_45.contextData.shipId = var3_45.id
	end

	if var3_45 then
		arg0_45.viewComponent:emit(var0_0.ON_NEXTSHIP_PREPARE, var3_45)
		arg0_45.viewComponent:setPreOrNext(arg1_45, var3_45)

		arg0_45.viewComponent.fashionGroup = 0
		arg0_45.viewComponent.fashionSkinId = 0

		arg0_45.viewComponent:setShip(var3_45)

		if arg0_45.contextData.selectContextData then
			arg0_45.contextData.selectContextData.infoShipId = var3_45.id
		end

		arg0_45.viewComponent:updatePreferenceTag()
		arg0_45.viewComponent:displayShipWord("detail", true)
		arg0_45.viewComponent:closeRecordPanel()

		local var6_45 = ShipViewConst.currentPage

		if var6_45 == ShipViewConst.PAGE.UPGRADE then
			arg0_45:closeUpgrade()
		elseif var6_45 == ShipViewConst.PAGE.INTENSIFY and not arg0_45.intensifyContext then
			arg0_45:closeIntensify()
		elseif var6_45 == ShipViewConst.PAGE.EQUIPMENT and arg0_45.contextData.isInEquipmentSkinPage and var3_45:hasEquipEquipmentSkin() and not ShipStatus.ShipStatusCheck("onModify", var3_45) then
			-- block empty
		end

		arg0_45.viewComponent:switchToPage(var6_45, true)
	end

	return var3_45
end

function var0_0.openRemould(arg0_46)
	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipRemouldMediator) then
		return
	end

	arg0_46:addSubLayers(Context.New({
		viewComponent = ShipRemouldLayer,
		mediator = ShipRemouldMediator,
		data = {
			shipId = arg0_46.contextData.shipId,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	}))
end

function var0_0.closeRemould(arg0_47)
	local var0_47 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipRemouldMediator)

	if var0_47 then
		arg0_47:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_47
		})
	end
end

function var0_0.openUpgrade(arg0_48)
	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipUpgradeMediator2) then
		return
	end

	arg0_48:addSubLayers(Context.New({
		mediator = ShipUpgradeMediator2,
		viewComponent = ShipUpgradeLayer2,
		data = {
			shipId = arg0_48.contextData.shipId,
			shipVOs = arg0_48.contextData.shipVOs,
			index = arg0_48.contextData.index,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	}))
end

function var0_0.closeUpgrade(arg0_49)
	local var0_49 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipUpgradeMediator2)

	if var0_49 then
		arg0_49:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_49
		})
	end
end

function var0_0.openIntensify(arg0_50)
	if arg0_50.intensifyContext ~= nil then
		arg0_50.intensifyContext.data.shipId = arg0_50.contextData.shipId

		return
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipModMediator) then
		return
	end

	arg0_50.intensifyContext = Context.New({
		mediator = ShipModMediator,
		viewComponent = ShipModLayer,
		data = {
			shipId = arg0_50.contextData.shipId,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	})

	arg0_50:addSubLayers(arg0_50.intensifyContext, false, function()
		arg0_50.intensifyContext = nil
	end)
end

function var0_0.closeIntensify(arg0_52)
	local var0_52 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipModMediator)

	if var0_52 then
		arg0_52:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0_52
		})
	end
end

function var0_0.listNotificationInterests(arg0_53)
	return {
		GAME.DESTROY_SHIP_DONE,
		BayProxy.SHIP_UPDATED,
		GAME.UPDATE_LOCK_DONE,
		GAME.UPDATE_PREFERENCE_DONE,
		PlayerProxy.UPDATED,
		GAME.FETCH_EVALUATION_DONE,
		GAME.MOD_SHIP_DONE,
		ShipSkinProxy.SHIP_SKINS_UPDATE,
		ShipUpgradeMediator2.NEXTSHIP,
		GAME.REMOVE_LAYERS,
		ShipModMediator.LOADEND,
		GAME.RENAME_SHIP_DONE,
		GAME.RECORD_SHIP_EQUIPMENT_DONE,
		GAME.SKIN_SHOPPIGN_DONE,
		GAME.UPGRADE_MAX_LEVEL_DONE,
		GAME.SKIN_COUPON_SHOPPING_DONE,
		GAME.HIDE_Ship_MAIN_SCENE_WORD,
		GAME.PROPOSE_SHIP_DONE,
		GAME.USE_ADD_SHIPEXP_ITEM_DONE,
		GAME.CHANGE_SKIN_UPDATE,
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.WILL_LOGOUT,
		PaintingGroupConst.NotifyPaintingDownloadFinish
	}
end

function var0_0.handleNotification(arg0_54, arg1_54)
	local var0_54 = arg1_54:getName()
	local var1_54 = arg1_54:getBody()

	if var0_54 == BayProxy.SHIP_UPDATED then
		if var1_54.id == arg0_54.contextData.shipId then
			arg0_54.showTrans = var1_54:isRemoulded()

			arg0_54.viewComponent:setShip(var1_54)
		end
	elseif var0_54 == GAME.CHANGE_SKIN_UPDATE then
		if var1_54.id == arg0_54.contextData.shipId then
			arg0_54.showTrans = var1_54:isRemoulded()

			arg0_54.viewComponent:setShip(var1_54)
		end
	elseif var0_54 == GAME.DESTROY_SHIP_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipInfoMediator_destory"))
		arg0_54.viewComponent.event:emit(BaseUI.ON_CLOSE)
	elseif var0_54 == GAME.UPDATE_LOCK_DONE then
		if var1_54.id == arg0_54.contextData.shipId then
			arg0_54.viewComponent:updateLock()
		end
	elseif var0_54 == GAME.UPDATE_PREFERENCE_DONE then
		if var1_54.id == arg0_54.contextData.shipId then
			arg0_54.viewComponent:updatePreferenceTag()
		end
	elseif var0_54 == GAME.MOD_SHIP_DONE then
		arg0_54.viewComponent:displayShipWord("upgrade", true)
	elseif var0_54 == PlayerProxy.UPDATED then
		local var2_54 = getProxy(PlayerProxy):getData()

		arg0_54.viewComponent:setPlayer(var2_54)
	elseif var0_54 == GAME.FETCH_EVALUATION_DONE then
		arg0_54:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1_54,
				showTrans = arg0_54.showTrans,
				LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
			}
		}))
	elseif var0_54 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var3_54 = getProxy(ShipSkinProxy)

		arg0_54.viewComponent:setSkinList(var3_54:getSkinList())

		arg0_54.viewComponent.fashionGroup = 0

		arg0_54.viewComponent.shipFashionView:UpdateFashion(true)
	elseif var0_54 == ShipUpgradeMediator2.NEXTSHIP then
		local var4_54 = arg0_54:nextPage(var1_54, 3)
	elseif var0_54 == ShipModMediator.LOADEND then
		arg0_54.viewComponent:setModPanel(var1_54)
	elseif var0_54 == GAME.RENAME_SHIP_DONE then
		arg0_54.viewComponent:DisplayRenamePanel(false)
	elseif var0_54 == GAME.RECORD_SHIP_EQUIPMENT_DONE then
		if var1_54.shipId == arg0_54.contextData.shipId and var1_54.type == 1 then
			arg0_54.viewComponent:updateRecordEquipments(var1_54.index)
		end
	elseif var0_54 == GAME.SKIN_SHOPPIGN_DONE or var0_54 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var5_54 = pg.shop_template[var1_54.id]

		if var5_54 and var5_54.genre == ShopArgs.SkinShop then
			arg0_54.viewComponent:StopPreVoice()
			arg0_54:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var5_54.effect_args[1]
				}
			}))
		end
	elseif var0_54 == GAME.UPGRADE_MAX_LEVEL_DONE then
		arg0_54:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, false)

		arg0_54.maxLevelCallback = var1_54.callback

		arg0_54.viewComponent:doUpgradeMaxLeveAnim(var1_54.oldShip, var1_54.newShip, function()
			if arg0_54.maxLevelCallback then
				arg0_54.maxLevelCallback()

				arg0_54.maxLevelCallback = nil
			end

			arg0_54:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
			arg0_54.viewComponent:showAwakenCompleteAni(i18n("upgrade_to_next_maxlevel_succeed", var1_54.newShip:getMaxLevel()))
		end)
	elseif var0_54 == GAME.REMOVE_LAYERS then
		if var1_54.context.mediator == ProposeMediator then
			arg0_54.viewComponent:SwitchToDefaultBGM()
		end
	elseif var0_54 == GAME.HIDE_Ship_MAIN_SCENE_WORD then
		arg0_54.viewComponent:hideShipWord()
	elseif var0_54 == GAME.PROPOSE_SHIP_DONE then
		local var6_54 = arg0_54.viewComponent.shipFashionView

		if var6_54 and var6_54:GetLoaded() then
			var6_54:UpdateAllFashion(true)
		end
	elseif var0_54 == GAME.USE_ADD_SHIPEXP_ITEM_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipModLayer_modSuccess"))
		arg0_54.viewComponent:RefreshShipExpItemUsagePage()
	elseif var0_54 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0_54.viewComponent:equipmentChange()
	elseif var0_54 == GAME.WILL_LOGOUT then
		arg0_54.viewComponent:OnWillLogout()
	elseif var0_54 == PaintingGroupConst.NotifyPaintingDownloadFinish then
		arg0_54.viewComponent:updateFashionTag()
	end
end

function var0_0.remove(arg0_56)
	if arg0_56.maxLevelCallback then
		arg0_56.maxLevelCallback()

		arg0_56.maxLevelCallback = nil

		arg0_56:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end
end

return var0_0
