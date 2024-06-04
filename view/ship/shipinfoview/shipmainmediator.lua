local var0 = class("ShipMainMediator", import("...base.ContextMediator"))

var0.ON_LOCK = "ShipMainMediator:ON_LOCK"
var0.ON_TAG = "ShipMainMediator:ON_TAG"
var0.ON_UPGRADE = "ShipMainMediator:ON_UPGRADE"
var0.ON_MOD = "ShipMainMediator:ON_MOD"
var0.ON_SKILL = "ShipMainMediator:ON_SKILL"
var0.OPEN_INTENSIFY = "ShipMainMediator:OPEN_INTENSIFY"
var0.CLOSE_INTENSIFY = "ShipMainMediator:CLOSE_INTENSIFY"
var0.OPEN_EVALUATION = "ShipMainMediator:OPEN_EVALUATION"
var0.CLOSE_UPGRADE = "ShipMainMediator:CLOSE_UPGRADE"
var0.CHANGE_SKIN = "ShipMainMediator:CHANGE_SKIN"
var0.BUY_ITEM = "ShipMainMediator:BUY_ITEM"
var0.UNEQUIP_FROM_SHIP_ALL = "ShipMainMediator:UNEQUIP_FROM_SHIP_ALL"
var0.UNEQUIP_FROM_SHIP = "ShipMainMediator:UNEQUIP_FROM_SHIP"
var0.NEXTSHIP = "ShipMainMediator:NEXTSHIP"
var0.ON_NEXTSHIP_PREPARE = "ShipMainMediator:ON_NEXTSHIP_PREPARE"
var0.OPEN_ACTIVITY = "ShipMainMediator:OPEN_ACTIVITY"
var0.PROPOSE = "ShipMainMediator:PROPOSE"
var0.RENAME_SHIP = "ShipMainMediator:RENAME_SHIP"
var0.OPEN_REMOULD = "ShipMainMediator:OPEN_REMOULD"
var0.CLOSE_REMOULD = "ShipMainMediator:CLOSE_REMOULD"
var0.ON_RECORD_EQUIPMENT = "ShipMainMediator:ON_RECORD_EQUIPMENT"
var0.ON_SELECT_EQUIPMENT = "ShipMainMediator:ON_SELECT_EQUIPMENT"
var0.ON_SELECT_EQUIPMENT_SKIN = "ShipMainMediator:ON_SELECT_EQUIPMENT_SKIN"
var0.ON_SKIN_INFO = "ShipMainMediator:ON_SKIN_INFO"
var0.ON_UPGRADE_MAX_LEVEL = "ShipMainMediator:ON_UPGRADE_MAX_LEVEL"
var0.ON_TECHNOLOGY = "ShipMainMediator:ON_TECHNOLOGY"
var0.OPEN_SHIPPROFILE = "ShipMainMediator:OPEN_SHIPPROFILE"
var0.ON_META = "ShipMainMediator:ON_META"
var0.ON_SEL_COMMANDER = "ShipMainMediator:ON_SEL_COMMANDER"
var0.OPEN_EQUIP_UPGRADE = "ShipMainMediator:OPEN_EQUIP_UPGRADE"
var0.BUY_ITEM_BY_ACT = "ShipMainMediator:BUY_ITEM_BY_ACT"
var0.ON_ADD_SHIP_EXP = "ShipMainMediator:ON_ADD_SHIP_EXP"
var0.OPEN_EQUIPMENT_INDEX = "ShipMainMediator:OPEN_EQUIPMENT_INDEX"
var0.EQUIP_CHANGE_NOTICE = "ShipMainMediator:EQUIP_CHANGE_NOTICE"
var0.ON_SELECT_SPWEAPON = "ShipMainMediator:ON_SELECT_SPWEAPON"
var0.OPEN_EQUIP_CODE = "ShipMainMediator:OPEN_EQUIP_CODE"
var0.OPEN_EQUIP_CODE_SHARE = "ShipMainMediator:OPEN_EQUIP_CODE_SHARE"

function var0.register(arg0)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.contextData.shipVOs = arg0.contextData.shipVOs or {}

	local var0 = _.detect(arg0.contextData.shipVOs, function(arg0)
		return arg0.contextData.shipId == arg0.id
	end)
	local var1 = arg0.bayProxy:getShipById(arg0.contextData.shipId)

	arg0.contextData.index = var0 and table.indexof(arg0.contextData.shipVOs, var0) or 1

	arg0.viewComponent:setShipList(arg0.contextData.shipVOs)
	arg0.viewComponent:setSkinList(getProxy(ShipSkinProxy):getSkinList())
	arg0.viewComponent:setShip(var1)

	if arg0.contextData.selectContextData then
		arg0.contextData.selectContextData.infoShipId = arg0.contextData.shipId
	end

	arg0.showTrans = var1:isRemoulded()

	local var2 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var2)

	local var3 = getProxy(ContextProxy)

	arg0:bind(var0.ON_ADD_SHIP_EXP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.USE_ADD_SHIPEXP_ITEM, {
			id = arg1,
			items = arg2
		})
	end)
	arg0:bind(var0.BUY_ITEM_BY_ACT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_COUPON_SHOPPING, {
			shopId = arg1,
			cnt = arg2
		})
	end)
	arg0:bind(var0.OPEN_SHIPPROFILE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIP_PROFILE, {
			showTrans = arg2,
			groupId = arg1
		})
	end)
	arg0:bind(var0.OPEN_EQUIPMENT_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
	arg0:bind(var0.EQUIP_CHANGE_NOTICE, function(arg0, arg1)
		arg0:sendNotification(arg1.notice, arg1.data)
	end)
	arg0:bind(var0.ON_SKIN_INFO, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			viewComponent = EquipmentSkinLayer,
			mediator = EquipmentSkinMediator,
			data = {
				shipId = arg0.contextData.shipId,
				pos = arg1,
				mode = EquipmentSkinLayer.DISPLAY,
				skinId = arg2
			}
		}))
	end)
	arg0:bind(var0.ON_RECORD_EQUIPMENT, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.RECORD_SHIP_EQUIPMENT, {
			shipId = arg1,
			index = arg2,
			type = arg3
		})
	end)
	arg0:bind(var0.OPEN_EVALUATION, function(arg0, arg1, arg2)
		if arg2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("npc_evaluation_tip"))

			return
		end

		arg0:sendNotification(GAME.FETCH_EVALUATION, arg1)
	end)
	arg0:bind(var0.ON_SELECT_EQUIPMENT_SKIN, function(arg0, arg1)
		local var0 = var0:getEquipmentSkins(arg0.viewComponent.shipVO, arg1)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			equipmentVOs = var0,
			shipId = arg0.contextData.shipId,
			pos = arg1,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.SKIN
		})
	end)
	arg0:bind(var0.ON_SELECT_EQUIPMENT, function(arg0, arg1)
		local var0 = getProxy(EquipmentProxy):getEquipments(true)
		local var1 = getProxy(BayProxy)
		local var2 = var1:getShipById(arg0.contextData.shipId)
		local var3 = var1:getEquipsInShips(function(arg0, arg1)
			return var2.id ~= arg1 and not var2:isForbiddenAtPos(arg0, arg1)
		end)

		for iter0, iter1 in ipairs(var0) do
			if not var2:isForbiddenAtPos(iter1, arg1) then
				table.insert(var3, iter1)
			end
		end

		_.each(var3, function(arg0)
			if not var2:canEquipAtPos(arg0, arg1) then
				arg0.mask = true
			end
		end)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIPSCENE, {
			lock = true,
			equipmentVOs = var3,
			shipId = arg0.contextData.shipId,
			pos = arg1,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0:bind(var0.ON_SELECT_SPWEAPON, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SPWEAPON_STOREHOUSE, {
			lock = true,
			shipId = arg0.contextData.shipId,
			warp = StoreHouseConst.WARP_TO_WEAPON,
			mode = StoreHouseConst.EQUIPMENT
		})
	end)
	arg0:bind(var0.ON_UPGRADE, function(arg0, arg1)
		arg0:openUpgrade()
	end)
	arg0:bind(var0.CLOSE_UPGRADE, function(arg0)
		arg0:closeUpgrade()
	end)
	arg0:bind(var0.OPEN_INTENSIFY, function(arg0)
		arg0:openIntensify()
	end)
	arg0:bind(var0.CLOSE_INTENSIFY, function(arg0)
		arg0:closeIntensify()
	end)
	arg0:bind(var0.ON_LOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1,
			is_locked = arg2
		})
	end)
	arg0:bind(var0.ON_TAG, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.UPDATE_PREFERENCE, {
			shipId = arg1,
			tag = arg2
		})
	end)
	arg0:bind(var0.ON_SKILL, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				skillOnShip = arg2,
				skillId = arg1,
				shipId = arg0.contextData.shipId,
				index = arg3,
				LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
			}
		}))
	end)
	arg0:bind(var0.CHANGE_SKIN, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SET_SHIP_SKIN, {
			shipId = arg1,
			skinId = arg2
		})
	end)
	arg0:bind(var0.BUY_ITEM, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SKIN_SHOPPIGN, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.UNEQUIP_FROM_SHIP_ALL, function(arg0, arg1)
		arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP_ALL, {
			shipId = arg1
		})
	end)
	arg0:bind(var0.UNEQUIP_FROM_SHIP, function(arg0, arg1)
		arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP, arg1)
	end)
	arg0:bind(var0.NEXTSHIP, function(arg0, arg1)
		arg0:nextPage(arg1)
	end)
	arg0:bind(var0.OPEN_ACTIVITY, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = arg1
		})
	end)
	arg0:bind(var0.OPEN_REMOULD, function(arg0)
		arg0:openRemould()
	end)
	arg0:bind(var0.CLOSE_REMOULD, function(arg0)
		arg0:closeRemould()
	end)
	arg0:bind(var0.PROPOSE, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = ProposeMediator,
			viewComponent = ProposeUI,
			data = {
				shipId = arg1,
				callback = arg2
			}
		}))
	end)
	arg0:bind(var0.RENAME_SHIP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.RENAME_SHIP, {
			shipId = arg1,
			name = arg2
		})
	end)
	arg0:bind(var0.ON_SEL_COMMANDER, function(arg0)
		local var0 = getProxy(BayProxy):getShipById(arg0.contextData.shipId)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMMANDPOST, {
			selectedMin = 1,
			selectedMax = 1,
			mode = CommanderCatScene.MODE_SELECT,
			onShip = function(arg0)
				if arg0.shipId == arg0.contextData.shipId then
					return false, i18n("commander_ship_already_equip")
				end

				return true
			end,
			onSelected = function(arg0)
				if #arg0 == 0 then
					arg0.contextData.unequipCommander = true
				else
					arg0.contextData.selectedId = arg0[1]
				end
			end,
			quitTeam = var0:hasCommander()
		})
	end)
	arg0:bind(var0.ON_UPGRADE_MAX_LEVEL, function(arg0, arg1)
		arg0:sendNotification(GAME.UPGRADE_MAX_LEVEL, {
			shipId = arg1
		})
	end)
	arg0:bind(var0.ON_TECHNOLOGY, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT, {
			shipId = arg1.id
		})
	end)
	arg0:bind(var0.OPEN_EQUIP_UPGRADE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = EquipUpgradeMediator,
			viewComponent = EquipUpgradeLayer,
			data = {
				shipId = arg1
			}
		}))
	end)
	arg0:bind(var0.ON_META, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.METACHARACTER, {
			autoOpenShipConfigID = arg1.configId
		})
	end)
	arg0:bind(var0.OPEN_EQUIP_CODE, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EQUIP_CODE, {
			shipId = arg0.contextData.shipId,
			code = arg1.code
		})
	end)
	arg0:bind(var0.OPEN_EQUIP_CODE_SHARE, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = EquipCodeShareMediator,
			viewComponent = EquipCodeShareLayer,
			data = {
				shipId = arg1,
				shipGroupId = arg2
			}
		}))
	end)

	if arg0.contextData.selectedId then
		arg0:sendNotification(GAME.COMMANDER_EQUIP_TO_SHIP, {
			shipId = arg0.contextData.shipId,
			commanderId = arg0.contextData.selectedId
		})

		arg0.contextData.selectedId = nil
	elseif arg0.contextData.unequipCommander then
		arg0.contextData.unequipCommander = nil

		arg0:sendNotification(GAME.COMMANDER_EQUIP_TO_SHIP, {
			commanderId = 0,
			shipId = arg0.contextData.shipId
		})
	end

	local var4 = getProxy(SettingsProxy):getMaxLevelHelp()

	arg0.viewComponent:setMaxLevelHelpFlag(var4)
end

function var0.getEquipmentSkins(arg0, arg1, arg2)
	if not arg1 then
		return {}
	end

	local var0 = arg1:getEquip(arg2)
	local var1 = var0 and {
		var0:getType()
	} or arg1:getSkinTypes(arg2)
	local var2 = getProxy(EquipmentProxy):getSkinsByTypes(var1)
	local var3 = getProxy(BayProxy):getEquipmentSkinInShips(arg1, var1)
	local var4 = _.map(var3, function(arg0)
		return {
			isSkin = true,
			count = 1,
			id = arg0.id,
			shipId = arg0.shipId,
			shipPos = arg0.shipPos
		}
	end)
	local var5 = _.map(var2, function(arg0)
		return {
			isSkin = true,
			id = arg0.id,
			count = arg0.count
		}
	end)

	for iter0, iter1 in ipairs(var4 or {}) do
		table.insert(var5, iter1)
	end

	return var5
end

function var0.nextPage(arg0, arg1, arg2)
	if #arg0.contextData.shipVOs == 0 then
		return
	end

	local var0 = 1
	local var1 = 1
	local var2 = 1

	if arg1 then
		var0 = arg0.contextData.index + 1
		var1 = #arg0.contextData.shipVOs
	else
		var0 = arg0.contextData.index - 1
		var2 = -1
	end

	local var3

	for iter0 = var0, var1, var2 do
		local var4 = arg0.contextData.shipVOs[iter0]

		if var4 then
			var3 = arg0.bayProxy:getShipById(var4.id)

			if var3 then
				arg0.contextData.index = iter0
				arg0.contextData.shipId = var3.id

				break
			end
		end
	end

	if var3 == nil then
		if arg2 == nil then
			return
		end

		local var5 = arg0.contextData.shipVOs[arg0.contextData.index]

		var3 = arg0.bayProxy:getShipById(var5.id)
		arg0.contextData.shipId = var3.id
	end

	if var3 then
		arg0.viewComponent:emit(var0.ON_NEXTSHIP_PREPARE, var3)
		arg0.viewComponent:setPreOrNext(arg1, var3)

		arg0.viewComponent.fashionGroup = 0
		arg0.viewComponent.fashionSkinId = 0

		arg0.viewComponent:setShip(var3)

		if arg0.contextData.selectContextData then
			arg0.contextData.selectContextData.infoShipId = var3.id
		end

		arg0.viewComponent:updatePreferenceTag()
		arg0.viewComponent:displayShipWord("detail", true)
		arg0.viewComponent:closeRecordPanel()

		local var6 = ShipViewConst.currentPage

		if var6 == ShipViewConst.PAGE.UPGRADE then
			arg0:closeUpgrade()
		elseif var6 == ShipViewConst.PAGE.INTENSIFY and not arg0.intensifyContext then
			arg0:closeIntensify()
		elseif var6 == ShipViewConst.PAGE.EQUIPMENT and arg0.contextData.isInEquipmentSkinPage and var3:hasEquipEquipmentSkin() and not ShipStatus.ShipStatusCheck("onModify", var3) then
			-- block empty
		end

		arg0.viewComponent:switchToPage(var6, true)
	end

	return var3
end

function var0.openRemould(arg0)
	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipRemouldMediator) then
		return
	end

	arg0:addSubLayers(Context.New({
		viewComponent = ShipRemouldLayer,
		mediator = ShipRemouldMediator,
		data = {
			shipId = arg0.contextData.shipId,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	}))
end

function var0.closeRemould(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipRemouldMediator)

	if var0 then
		arg0:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})
	end
end

function var0.openUpgrade(arg0)
	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipUpgradeMediator2) then
		return
	end

	arg0:addSubLayers(Context.New({
		mediator = ShipUpgradeMediator2,
		viewComponent = ShipUpgradeLayer2,
		data = {
			shipId = arg0.contextData.shipId,
			shipVOs = arg0.contextData.shipVOs,
			index = arg0.contextData.index,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	}))
end

function var0.closeUpgrade(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipUpgradeMediator2)

	if var0 then
		arg0:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})
	end
end

function var0.openIntensify(arg0)
	if arg0.intensifyContext ~= nil then
		arg0.intensifyContext.data.shipId = arg0.contextData.shipId

		return
	end

	if getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipModMediator) then
		return
	end

	arg0.intensifyContext = Context.New({
		mediator = ShipModMediator,
		viewComponent = ShipModLayer,
		data = {
			shipId = arg0.contextData.shipId,
			LayerWeightMgr_groupName = LayerWeightConst.GROUP_SHIPINFOUI
		}
	})

	arg0:addSubLayers(arg0.intensifyContext, false, function()
		arg0.intensifyContext = nil
	end)
end

function var0.closeIntensify(arg0)
	local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(ShipModMediator)

	if var0 then
		arg0:sendNotification(GAME.REMOVE_LAYERS, {
			context = var0
		})
	end
end

function var0.listNotificationInterests(arg0)
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
		EquipmentProxy.EQUIPMENT_UPDATED,
		GAME.WILL_LOGOUT,
		PaintingGroupConst.NotifyPaintingDownloadFinish
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == BayProxy.SHIP_UPDATED then
		if var1.id == arg0.contextData.shipId then
			arg0.showTrans = var1:isRemoulded()

			arg0.viewComponent:setShip(var1)
		end
	elseif var0 == GAME.DESTROY_SHIP_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipInfoMediator_destory"))
		arg0.viewComponent.event:emit(BaseUI.ON_CLOSE)
	elseif var0 == GAME.UPDATE_LOCK_DONE then
		if var1.id == arg0.contextData.shipId then
			arg0.viewComponent:updateLock()
		end
	elseif var0 == GAME.UPDATE_PREFERENCE_DONE then
		if var1.id == arg0.contextData.shipId then
			arg0.viewComponent:updatePreferenceTag()
		end
	elseif var0 == GAME.MOD_SHIP_DONE then
		arg0.viewComponent:displayShipWord("upgrade", true)
	elseif var0 == PlayerProxy.UPDATED then
		local var2 = getProxy(PlayerProxy):getData()

		arg0.viewComponent:setPlayer(var2)
	elseif var0 == GAME.FETCH_EVALUATION_DONE then
		arg0:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1,
				showTrans = arg0.showTrans,
				LayerWeightMgr_weight = LayerWeightConst.THIRD_LAYER
			}
		}))
	elseif var0 == ShipSkinProxy.SHIP_SKINS_UPDATE then
		local var3 = getProxy(ShipSkinProxy)

		arg0.viewComponent:setSkinList(var3:getSkinList())

		arg0.viewComponent.fashionGroup = 0

		arg0.viewComponent.shipFashionView:UpdateFashion(true)
	elseif var0 == ShipUpgradeMediator2.NEXTSHIP then
		local var4 = arg0:nextPage(var1, 3)
	elseif var0 == ShipModMediator.LOADEND then
		arg0.viewComponent:setModPanel(var1)
	elseif var0 == GAME.RENAME_SHIP_DONE then
		arg0.viewComponent:DisplayRenamePanel(false)
	elseif var0 == GAME.RECORD_SHIP_EQUIPMENT_DONE then
		if var1.shipId == arg0.contextData.shipId and var1.type == 1 then
			arg0.viewComponent:updateRecordEquipments(var1.index)
		end
	elseif var0 == GAME.SKIN_SHOPPIGN_DONE or var0 == GAME.SKIN_COUPON_SHOPPING_DONE then
		local var5 = pg.shop_template[var1.id]

		if var5 and var5.genre == ShopArgs.SkinShop then
			arg0.viewComponent:StopPreVoice()
			arg0:addSubLayers(Context.New({
				mediator = NewSkinMediator,
				viewComponent = NewSkinLayer,
				data = {
					skinId = var5.effect_args[1]
				}
			}))
		end
	elseif var0 == GAME.UPGRADE_MAX_LEVEL_DONE then
		arg0:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, false)

		arg0.maxLevelCallback = var1.callback

		arg0.viewComponent:doUpgradeMaxLeveAnim(var1.oldShip, var1.newShip, function()
			if arg0.maxLevelCallback then
				arg0.maxLevelCallback()

				arg0.maxLevelCallback = nil
			end

			arg0:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
			arg0.viewComponent:showAwakenCompleteAni(i18n("upgrade_to_next_maxlevel_succeed", var1.newShip:getMaxLevel()))
		end)
	elseif var0 == GAME.REMOVE_LAYERS then
		if var1.context.mediator == ProposeMediator then
			arg0.viewComponent:SwitchToDefaultBGM()
		end
	elseif var0 == GAME.HIDE_Ship_MAIN_SCENE_WORD then
		arg0.viewComponent:hideShipWord()
	elseif var0 == GAME.PROPOSE_SHIP_DONE then
		local var6 = arg0.viewComponent.shipFashionView

		if var6 and var6:GetLoaded() then
			var6:UpdateAllFashion(true)
		end
	elseif var0 == GAME.USE_ADD_SHIPEXP_ITEM_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_shipModLayer_modSuccess"))
		arg0.viewComponent:RefreshShipExpItemUsagePage()
	elseif var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0.viewComponent:equipmentChange()
	elseif var0 == GAME.WILL_LOGOUT then
		arg0.viewComponent:OnWillLogout()
	elseif var0 == PaintingGroupConst.NotifyPaintingDownloadFinish then
		arg0.viewComponent:updateFashionTag()
	end
end

function var0.remove(arg0)
	if arg0.maxLevelCallback then
		arg0.maxLevelCallback()

		arg0.maxLevelCallback = nil

		arg0:sendNotification(PlayerResUI.CHANGE_TOUCH_ABLE, true)
	end
end

return var0
