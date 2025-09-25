local var0_0 = class("DockyardScene", import("..base.BaseUI"))
local var1_0 = 2
local var2_0 = 0.2
local var3_0 = 1

var0_0.MODE_OVERVIEW = "overview"
var0_0.MODE_DESTROY = "destroy"
var0_0.MODE_SELECT = "select"
var0_0.MODE_MOD = "modify"
var0_0.MODE_WORLD = "world"
var0_0.MODE_REMOULD = "remould"
var0_0.MODE_UPGRADE = "upgrade"
var0_0.MODE_GUILD_BOSS = "guildboss"
var0_0.MODE_SHIP_PHANTOM = "phantom"
var0_0.TITLE_CN_OVERVIEW = i18n("word_dockyard")
var0_0.TITLE_CN_UPGRADE = i18n("word_dockyardUpgrade")
var0_0.TITLE_CN_DESTROY = i18n("word_dockyardDestroy")
var0_0.TITLE_EN_OVERVIEW = "dockyard"
var0_0.TITLE_EN_UPGRADE = "modernization"
var0_0.TITLE_EN_DESTROY = "retirement"
var0_0.PRIOR_MODE_EQUIP_UP = 1
var0_0.PRIOR_MODE_SHIP_UP = 2

function var0_0.getUIName(arg0_1)
	return "DockyardUI"
end

function var0_0.init(arg0_2)
	local var0_2 = arg0_2.contextData

	var0_2.mode = defaultValue(var0_2.mode, var0_0.MODE_SELECT)
	var0_2.otherSelectedIds = defaultValue(var0_2.otherSelectedIds, {})
	arg0_2.teamTypeFilter = var0_2.teamFilter
	arg0_2.selectedMin = var0_2.selectedMin or 1
	arg0_2.leastLimitMsg = var0_2.leastLimitMsg
	arg0_2.selectedMax = var0_2.selectedMax or 0
	var0_2.selectedIds = var0_2.selectedIds or {}

	if var0_2.infoShipId then
		table.insert(var0_2.selectedIds, var0_2.infoShipId)

		var0_2.infoShipId = nil
	end

	arg0_2.selectedIds = underscore(var0_2.selectedIds):chain():select(function(arg0_3)
		return getProxy(BayProxy):RawGetShipById(arg0_3) ~= nil
	end):first(arg0_2.selectedMax):value()
	var0_2.selectedIds = nil
	arg0_2.checkShip = var0_2.onShip or function(arg0_4, arg1_4, arg2_4)
		return true
	end
	arg0_2.onCancelShip = var0_2.onCancelShip or function(arg0_5, arg1_5, arg2_5)
		return true
	end
	arg0_2.onClick = var0_2.onClick or function(arg0_6, arg1_6, arg2_6)
		arg0_2:emit(DockyardMediator.ON_SHIP_DETAIL, arg0_6, arg1_6, arg2_6)
	end
	arg0_2.confirmSelect = var0_2.confirmSelect
	arg0_2.callbackQuit = var0_2.callbackQuit
	arg0_2.onSelected = var0_2.onSelected or function(arg0_7, arg1_7)
		warning("not implemented.")
	end
	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.settingBtn = arg0_2.blurPanel:Find("adapt/left_length/frame/setting")
	arg0_2.settingPanel = DockyardQuickSelectSettingPage.New(arg0_2._tf, arg0_2.event)

	arg0_2.settingPanel:OnSettingChanged(function()
		arg0_2:unselecteAllShips()
	end)

	arg0_2.topPanel = arg0_2.blurPanel:Find("adapt/top")
	arg0_2.sortBtn = arg0_2.topPanel:Find("sort_button")
	arg0_2.sortImgAsc = arg0_2.sortBtn:Find("asc")
	arg0_2.sortImgDesc = arg0_2.sortBtn:Find("desc")
	arg0_2.leftTipsText = arg0_2.topPanel:Find("capacity")

	onButton(arg0_2, arg0_2.leftTipsText:Find("switch"), function()
		arg0_2.isCapacityMeta = not arg0_2.isCapacityMeta

		arg0_2:updateCapacityDisplay()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.leftTipsText:Find("plus"), function()
		gotoChargeScene()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.leftTipsText:Find("tip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("specialshipyard_tip")
		})
	end, SFX_PANEL)
	setActive(arg0_2.leftTipsText, false)

	arg0_2.indexBtn = arg0_2.topPanel:Find("index_button")
	arg0_2.switchPanel = arg0_2.topPanel:Find("switch")

	triggerToggle(arg0_2.switchPanel:Find("Image"), true)

	arg0_2.preferenceBtn = arg0_2.switchPanel:Find("toggles/preference_toggle")
	arg0_2.attrBtn = arg0_2.switchPanel:Find("toggles/attr_toggle")
	arg0_2.nameSearchInput = arg0_2.switchPanel:Find("search")

	setText(arg0_2.nameSearchInput:Find("holder"), i18n("dockyard_search_holder"))
	setInputText(arg0_2.nameSearchInput, "")
	onInputChanged(arg0_2, arg0_2.nameSearchInput, function()
		arg0_2:filter()
	end)

	arg0_2.modLockFilter = arg0_2:findTF("mod_flter_lock", arg0_2.topPanel)
	arg0_2.modLeveFilter = arg0_2:findTF("mod_flter_level", arg0_2.topPanel)
	arg0_2.energyDescTF = arg0_2:findTF("energy_desc")
	arg0_2.energyDescTextTF = arg0_2.energyDescTF:Find("Text")
	arg0_2.selectPanel = arg0_2.blurPanel:Find("select_panel")
	arg0_2.bottomTipsText = arg0_2.selectPanel:Find("tip")
	arg0_2.bottomTipsWithFrame = arg0_2.selectPanel:Find("tipwithframe")

	setText(arg0_2.selectPanel:Find("bottom_info/bg_input/selected"), i18n("disassemble_selected") .. ":")

	arg0_2.awardTF = arg0_2.selectPanel:Find("bottom_info/bg_award")

	setText(arg0_2.awardTF:Find("label"), i18n("disassemble_available") .. ":")

	arg0_2.modAttrsTF = arg0_2.selectPanel:Find("bottom_info/bg_mod")
	arg0_2.viewEquipmentBtn = arg0_2.selectPanel:Find("view_equipments")
	arg0_2.tipPanel = arg0_2.blurPanel:Find("TipPanel")

	setActive(arg0_2.tipPanel, false)

	arg0_2.worldPanel = arg0_2.blurPanel:Find("world_port_panel")

	setActive(arg0_2.worldPanel, arg0_2.contextData.mode == var0_0.MODE_WORLD)

	arg0_2.assultBtn = arg0_2.blurPanel:Find("adapt/top/assult_btn")
	arg0_2.stampBtn = arg0_2.topPanel:Find("stamp")
	arg0_2.isRemouldOrUpgradeMode = arg0_2.contextData.mode == var0_0.MODE_REMOULD or arg0_2.contextData.mode == var0_0.MODE_UPGRADE

	setActive(arg0_2.modLeveFilter, arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.modLockFilter, arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.assultBtn, arg0_2.contextData.mode == var0_0.MODE_GUILD_BOSS)
	switch(arg0_2.contextData.mode, {
		[var0_0.MODE_OVERVIEW] = function()
			arg0_2.selecteEnabled = false
		end,
		[var0_0.MODE_DESTROY] = function()
			arg0_2.selecteEnabled = true
			arg0_2.blacklist = {}
			arg0_2.destroyResList = UIItemList.New(arg0_2.awardTF:Find("res_list"), arg0_2.awardTF:Find("res_list/res"))
		end,
		[var0_0.MODE_MOD] = function()
			arg0_2.selecteEnabled = true

			setText(arg0_2.modAttrsTF:Find("title/Text"), i18n("word_mod_value"))

			arg0_2.modAttrContainer = arg0_2.modAttrsTF:Find("attrs")
		end,
		[var0_0.MODE_SHIP_PHANTOM] = function()
			arg0_2.selecteEnabled = false
		end
	}, function()
		arg0_2.selecteEnabled = true
	end)
	setActive(arg0_2.selectPanel, arg0_2.selecteEnabled and arg0_2.contextData.mode ~= var0_0.MODE_WORLD)
	setActive(arg0_2.worldPanel, arg0_2.contextData.mode == var0_0.MODE_WORLD)

	local var1_2 = arg0_2.contextData.mode == var0_0.MODE_DESTROY

	setActive(arg0_2.settingBtn, var1_2)
	setActive(arg0_2.selectPanel:Find("quick_select"), var1_2)

	if arg0_2.contextData.priorEquipUpShipIDList and arg0_2.contextData.priorMode then
		setActive(arg0_2.tipPanel, true)

		local var2_2 = arg0_2:findTF("EquipUP", arg0_2.tipPanel)
		local var3_2 = arg0_2:findTF("ShipUP", arg0_2.tipPanel)

		setText(var2_2, i18n("fightfail_choiceequip"))
		setText(var3_2, i18n("fightfail_choicestrengthen"))
		setActive(var2_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_EQUIP_UP)
		setActive(var3_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_SHIP_UP)
	end

	arg0_2.togglePhantom = arg0_2._tf:Find("blur_panel/adapt/left_length/frame/toggle_phantom")

	onToggle(arg0_2, arg0_2.togglePhantom, function(arg0_18)
		if arg0_2.inPhantom ~= arg0_18 then
			arg0_2.inPhantom = arg0_18

			arg0_2:SwitchContainerDisplay()
		end
	end, SFX_PANEL)
	setActive(arg0_2.togglePhantom, false)

	arg0_2.helpPhantom = arg0_2._tf:Find("blur_panel/adapt/left_length/frame/help_phantom")

	onButton(arg0_2, arg0_2.helpPhantom, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("projection_help")
		})
	end, SFX_PANEL)

	local var4_2 = arg0_2.contextData.mode == var0_0.MODE_SHIP_PHANTOM and "phantom" or "dockyard"

	eachChild(arg0_2.topPanel:Find("titles"), function(arg0_20, arg1_20)
		setActive(arg0_20, arg0_20.name == var4_2)
	end)

	arg0_2.listEmptyTF = arg0_2:findTF("empty")

	setActive(arg0_2.listEmptyTF, false)

	arg0_2.listEmptyTxt = arg0_2:findTF("Text", arg0_2.listEmptyTF)

	setText(arg0_2.listEmptyTxt, i18n("list_empty_tip_dockyardui"))

	arg0_2.destroyPage = ShipDestroyPage.New(arg0_2._tf, arg0_2.event)

	arg0_2.destroyPage:SetCardClickCallBack(function(arg0_21)
		arg0_2.blacklist[arg0_21.shipVO:getGroupId()] = true

		local var0_21 = table.indexof(arg0_2.selectedIds, arg0_21.shipVO.id)

		if var0_21 and var0_21 > 0 then
			table.remove(arg0_2.selectedIds, var0_21)
		end

		arg0_2:updateDestroyRes()
		arg0_2:updateSelected()
	end)
	arg0_2.destroyPage:SetConfirmCallBack(function()
		local var0_22 = {}
		local var1_22, var2_22 = arg0_2:checkDestroyGold()

		if not var2_22 then
			table.insert(var0_22, function(arg0_23)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
					onYes = arg0_23
				})
			end)
		end

		local var3_22 = underscore.map(arg0_2.selectedIds, function(arg0_24)
			return arg0_2.shipVOsById[arg0_24]
		end)

		table.insert(var0_22, function(arg0_25)
			arg0_2:checkDestroyShips(var3_22, arg0_25)
		end)
		seriesAsync(var0_22, function()
			arg0_2:emit(DockyardMediator.ON_DESTROY_SHIPS, arg0_2.selectedIds)
		end)
	end)

	arg0_2.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.SwitchContainerDisplay(arg0_27)
	arg0_27.isPhantomMode = arg0_27.contextData.mode == var0_0.MODE_SHIP_PHANTOM or arg0_27.inPhantom

	setActive(arg0_27.switchPanel, not arg0_27.isRemouldOrUpgradeMode and not arg0_27.isPhantomMode)
	setActive(arg0_27.indexBtn, not arg0_27.isRemouldOrUpgradeMode and not arg0_27.isPhantomMode)
	setActive(arg0_27.sortBtn, not arg0_27.isRemouldOrUpgradeMode and not arg0_27.isPhantomMode)
	setActive(arg0_27._tf:Find("main/ship_container"), not arg0_27.isPhantomMode)
	setActive(arg0_27._tf:Find("main/phantom_container"), arg0_27.isPhantomMode)
	setActive(arg0_27.preferenceBtn, not arg0_27.isPhantomMode)
	arg0_27:updateBarInfo()
	setActive(arg0_27.helpPhantom, arg0_27.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

	if pg.SeriesGuideMgr.GetInstance():isEnd() and PlayerPrefs.GetInt("PHANTOM_HELP_FIRST", 0) == 0 then
		PlayerPrefs.SetInt("PHANTOM_HELP_FIRST", 1)
		triggerButton(arg0_27.helpPhantom)
	end

	switch(tobool(arg0_27.isPhantomMode), {
		[true] = function()
			arg0_27.initDic = arg0_27.initDic or {}

			if arg0_27.initDic.phantom then
				return
			end

			arg0_27.initDic.phantom = true

			local var0_28 = getProxy(TechnologyProxy)
			local var1_28 = arg0_27._tf:Find("main/phantom_container/title/content")
			local var2_28 = var0_28:getConfigMaxVersion()

			UIItemList.StaticAlign(var1_28, var1_28:GetChild(0), var2_28 + 1, function(arg0_29, arg1_29, arg2_29)
				if arg0_29 == UIItemList.EventUpdate then
					arg2_29.name = "phase_" .. arg1_29

					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_29, arg2_29:Find("on"))
					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_29, arg2_29:Find("off"))
					onToggle(arg0_27, arg2_29, function(arg0_30)
						if arg0_30 then
							arg0_27.selectVersion = arg1_29
							arg0_27.filterBluePrint = underscore.filter(arg0_27.shipBluePrints, function(arg0_31)
								return arg1_29 == 0 or arg0_31:getConfig("blueprint_version") == arg1_29
							end)

							arg0_27.phantomContainer:SetTotalCount(#arg0_27.filterBluePrint, 0)
						end
					end, SFX_PANEL)
				end
			end)
			setActive(arg0_27._tf:Find("main/phantom_container/view/tpl"), false)

			arg0_27.phantomContainer = arg0_27._tf:Find("main/phantom_container/view/groups"):GetComponent("LScrollRect")
			arg0_27.phantomContainer.enabled = true
			arg0_27.phantomContainer.decelerationRate = 0.07

			function arg0_27.phantomContainer.onInitItem(arg0_32)
				arg0_27:getOrInitPhantom(arg0_32)
				ClearTweenItemAlphaAndWhite(arg0_32)
			end

			function arg0_27.phantomContainer.onUpdateItem(arg0_33, arg1_33)
				arg0_27:updatePhantomGroup(arg0_27.filterBluePrint[arg0_33 + 1], arg1_33)
				TweenItemAlphaAndWhite(arg1_33)
			end

			function arg0_27.phantomContainer.onReturnItem(arg0_34, arg1_34)
				if arg0_27.exited then
					return
				end

				arg0_27:getOrInitPhantom(arg1_34):clear()
				ClearTweenItemAlphaAndWhite(arg1_34)
			end

			arg0_27.scrollPhantoms = {}
			arg0_27.phantomGroupDic = {}

			local var3_28 = 0

			if arg0_27.contextData.techVersion and #underscore.filter(arg0_27.shipBluePrints, function(arg0_35)
				return arg0_27.contextData.techVersion == 0 or arg0_35:getConfig("blueprint_version") == arg0_27.contextData.techVersion
			end) > 0 then
				var3_28 = arg0_27.contextData.techVersion
			end

			arg0_27.contextData.techVersion = nil

			triggerToggle(arg0_27._tf:Find("main/phantom_container/title/content"):GetChild(var3_28), true)
		end,
		[false] = function()
			arg0_27.initDic = arg0_27.initDic or {}

			if arg0_27.initDic.ship then
				return
			end

			arg0_27.initDic.ship = true
			arg0_27.shipContainer = arg0_27:findTF("main/ship_container/ships"):GetComponent("LScrollRect")
			arg0_27.shipContainer.enabled = true
			arg0_27.shipContainer.decelerationRate = 0.07

			function arg0_27.shipContainer.onInitItem(arg0_37)
				arg0_27:onInitItem(arg0_37)
			end

			function arg0_27.shipContainer.onUpdateItem(arg0_38, arg1_38)
				arg0_27:onUpdateItem(arg0_38, arg1_38)
			end

			function arg0_27.shipContainer.onReturnItem(arg0_39, arg1_39)
				arg0_27:onReturnItem(arg0_39, arg1_39)
			end

			function arg0_27.shipContainer.onStart()
				arg0_27:updateSelected()
			end

			arg0_27.shipLayout = arg0_27:findTF("main/ship_container/ships")
			arg0_27.scrollItems = {}
			arg0_27.cardItemDic = {}

			local var0_36 = _G[arg0_27.contextData.preView]

			if var0_36 then
				arg0_27.sortIndex = var0_36.sortIndex or ShipIndexConst.SortLevel
				arg0_27.selectAsc = var0_36.selectAsc or false
				arg0_27.typeIndex = var0_36.typeIndex or ShipIndexConst.TypeAll
				arg0_27.campIndex = var0_36.campIndex or ShipIndexConst.CampAll
				arg0_27.rarityIndex = var0_36.rarityIndex or ShipIndexConst.RarityAll
				arg0_27.extraIndex = var0_36.extraIndex or ShipIndexConst.ExtraAll
				arg0_27.commonTag = var0_36.commonTag or Ship.PREFERENCE_TAG_NONE
			elseif arg0_27.contextData.sortData then
				local var1_36 = arg0_27.contextData.sortData

				arg0_27.sortIndex = var1_36.sort or ShipIndexConst.SortLevel
				arg0_27.selectAsc = var1_36.Asc or false
				arg0_27.typeIndex = var1_36.typeIndex or ShipIndexConst.TypeAll
				arg0_27.campIndex = var1_36.campIndex or ShipIndexConst.CampAll
				arg0_27.rarityIndex = var1_36.rarityIndex or ShipIndexConst.RarityAll
				arg0_27.extraIndex = var1_36.extraIndex or ShipIndexConst.ExtraAll
				arg0_27.commonTag = var1_36.commonTag or Ship.PREFERENCE_TAG_NONE
			else
				arg0_27.selectAsc = DockyardScene.selectAsc or false
				arg0_27.sortIndex = DockyardScene.sortIndex or ShipIndexConst.SortLevel
				arg0_27.typeIndex = DockyardScene.typeIndex or ShipIndexConst.TypeAll
				arg0_27.campIndex = DockyardScene.campIndex or ShipIndexConst.CampAll
				arg0_27.rarityIndex = DockyardScene.rarityIndex or ShipIndexConst.RarityAll
				arg0_27.extraIndex = DockyardScene.extraIndex or ShipIndexConst.ExtraAll
				arg0_27.commonTag = DockyardScene.commonTag or Ship.PREFERENCE_TAG_NONE
			end

			arg0_27:updateIndexDatas()
			triggerToggle(arg0_27.preferenceBtn, arg0_27.commonTag == Ship.PREFERENCE_TAG_COMMON)
			arg0_27:initIndexPanel()

			arg0_27.itemDetailType = -1

			if arg0_27.contextData.mode == var0_0.MODE_DESTROY then
				arg0_27.blacklist = {}
				arg0_27.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 50

				setActive(arg0_27.selectPanel:Find("quick_select"), true)
				setActive(arg0_27.settingBtn, true)
			else
				arg0_27.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 250

				setActive(arg0_27.selectPanel:Find("quick_select"), false)
				setActive(arg0_27.settingBtn, false)
			end

			if arg0_27.contextData.mode == var0_0.MODE_GUILD_BOSS then
				arg0_27.isShowAssultShips = false

				triggerToggle(arg0_27.assultBtn, true)

				arg0_27.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_27._tf, arg0_27.event)

				arg0_27.guildShipEquipmentsPage:SetCallBack(function()
					arg0_27:TriggerCard(-1)
				end, function()
					arg0_27:TriggerCard(1)
				end)
			end

			eachChild(arg0_27.attrBtn, function(arg0_43)
				setActive(arg0_43, false)
			end)

			arg0_27.isFormTactics = arg0_27.contextData.prevPage == "NewNavalTacticsMediator"

			local var2_36 = arg0_27:findTF("off", arg0_27.attrBtn):GetComponent("Image")
			local var3_36 = arg0_27:findTF("on", arg0_27.attrBtn):GetComponent("Image")

			if arg0_27.isFormTactics then
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var2_36)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var3_36)
			else
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var2_36)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var3_36)
			end

			triggerButton(arg0_27.attrBtn)

			if arg0_27.isRemouldOrUpgradeMode then
				local var4_36 = getProxy(SettingsProxy)

				arg0_27.isFilterLevelForMod = var4_36:GetDockYardLevelBtnFlag()

				arg0_27:OnSwitch(arg0_27.modLeveFilter, arg0_27.isFilterLevelForMod, function(arg0_44)
					arg0_27.isFilterLevelForMod = arg0_44

					arg0_27:filter()
				end)

				arg0_27.isFilterLockForMod = var4_36:GetDockYardLockBtnFlag()

				arg0_27:OnSwitch(arg0_27.modLockFilter, arg0_27.isFilterLockForMod, function(arg0_45)
					arg0_27.isFilterLockForMod = arg0_45

					arg0_27:filter()
				end)
			end

			arg0_27.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7

			arg0_27:filter()
		end
	})

	if arg0_27.isPhantomMode then
		setActive(arg0_27.listEmptyTF, #arg0_27.filterBluePrint == 0)
	else
		setActive(arg0_27.listEmptyTF, #arg0_27.shipVOs <= 0)
	end
end

function var0_0.isDefaultStatus(arg0_46)
	return arg0_46.sortIndex == ShipIndexConst.SortLevel and (not arg0_46.typeIndex or arg0_46.typeIndex == ShipIndexConst.TypeAll) and (not arg0_46.campIndex or arg0_46.campIndex == ShipIndexConst.CampAll) and (not arg0_46.rarityIndex or arg0_46.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_46.extraIndex or arg0_46.extraIndex == ShipIndexConst.ExtraAll)
end

function var0_0.setShipsCount(arg0_47, arg1_47, arg2_47)
	arg0_47.shipsCount = arg1_47
	arg0_47.specialShipCount = arg2_47
end

function var0_0.GetCard(arg0_48, arg1_48)
	return DockyardShipItem.New(arg1_48, arg0_48.contextData.hideTagFlags, arg0_48.contextData.blockTagFlags)
end

function var0_0.OnClickCard(arg0_49, arg1_49)
	if arg1_49.shipVO then
		if not arg0_49.selecteEnabled then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

			DockyardScene.value = arg0_49.shipContainer.value

			arg0_49.onClick(arg1_49.shipVO, arg0_49.shipVOs)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(table.contains(arg0_49.selectedIds, arg1_49.shipVO.id) and SFX_UI_CANCEL or SFX_UI_FORMATION_SELECT)
			arg0_49:selectShip(arg1_49.shipVO)
		end
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

		if arg0_49.callbackQuit then
			arg0_49.onSelected({}, function()
				arg0_49:back()
			end)
		elseif not arg1_49.isLoading then
			arg0_49.onSelected({})
			arg0_49:back()
		end
	end
end

function var0_0.OnClickPhantom(arg0_51, arg1_51)
	if arg1_51.phantomId == 0 then
		return
	else
		arg0_51:emit(DockyardMediator.CHANGE_SKIN, arg1_51)
	end
end

function var0_0.onInitItem(arg0_52, arg1_52)
	if arg0_52.scrollItems[arg1_52] then
		return arg0_52.scrollItems[arg1_52]
	end

	local var0_52 = arg0_52:GetCard(arg1_52)

	var0_52:updateDetail(arg0_52.itemDetailType)

	var0_52.isLoading = true

	onButton(arg0_52, var0_52.go, function()
		arg0_52:OnClickCard(var0_52)
	end)

	local var1_52 = GetOrAddComponent(var0_52.go, "UILongPressTrigger").onLongPressed

	if arg0_52.contextData.preView == NewBackYardShipInfoLayer.__cname then
		var1_52:RemoveAllListeners()
		var1_52:AddListener(function()
			if var0_52.shipVO then
				arg0_52.contextData.selectedIds = arg0_52.selectedIds

				arg0_52.onClick(var0_52.shipVO, underscore.select(arg0_52.shipVOs, function(arg0_55)
					return arg0_55
				end), arg0_52.contextData)
			end
		end)
	else
		var1_52:RemoveAllListeners()
	end

	arg0_52.scrollItems[arg1_52] = var0_52

	return var0_52
end

function var0_0.getOrInitPhantom(arg0_56, arg1_56)
	arg0_56.scrollPhantoms[arg1_56] = arg0_56.scrollPhantoms[arg1_56] or {
		isClear = true,
		go = arg1_56,
		tf = tf(arg1_56),
		updateSelected = function(arg0_57, arg1_57)
			arg0_57.shipCard:updateSelected(arg1_57[0])
			eachChild(arg0_57.tf:Find("phantoms"), function(arg0_58, arg1_58)
				arg1_58 = arg1_58 + 1

				local var0_58 = arg0_57.phantoms[arg1_58 + 1]

				setActive(arg0_58:Find("selected"), var0_58 and arg1_57[var0_58.phantomId])
			end)
		end,
		clear = function(arg0_59)
			if arg0_59.isClear then
				return
			end

			arg0_59.shipCard:clear()

			arg0_59.isClear = true
		end
	}

	return arg0_56.scrollPhantoms[arg1_56]
end

function var0_0.updatePhantomGroup(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg0_60:getOrInitPhantom(arg2_60)

	var0_60.isClear = false
	arg0_60.phantomGroupDic[arg1_60.shipId] = arg2_60
	var0_60.shipCard = var0_60.shipCard or arg0_60:GetCard(var0_60.tf:Find("card"):GetChild(0).gameObject)

	local var1_60 = arg0_60.shipVOsById[arg1_60.shipId]:getAllShipPhantom()

	assert(var1_60[1].phantomId == 0)

	var0_60.phantoms = var1_60

	var0_60.shipCard:update(var1_60[1])
	var0_60.shipCard:updateSelected(underscore.any(arg0_60.selectedIds, function(arg0_61)
		return arg0_61 == var1_60[1].id
	end))
	arg0_60:updateItemBlackBlock(var0_60.shipCard)

	var0_60.shipCard.isLoading = false

	var0_60.shipCard:updateIntimacyEnergy(false)
	var0_60.shipCard:updateIntimacy(false)
	onButton(arg0_60, var0_60.shipCard.tr, function()
		arg0_60:OnClickPhantom(var1_60[1])
	end, SFX_UI_CLICK)

	local var2_60 = getGameset("technology_shadow_num")[1]
	local var3_60 = var0_60.tf:Find("phantoms")

	UIItemList.StaticAlign(var3_60, var3_60:GetChild(0), var2_60, function(arg0_63, arg1_63, arg2_63)
		arg1_63 = arg1_63 + 1

		if arg0_63 == UIItemList.EventUpdate then
			local var0_63 = var1_60[arg1_63 + 1]

			setActive(arg2_63:Find("skin"), tobool(var0_63))
			setActive(arg2_63:Find("lock"), not var0_63)

			if var0_63 then
				GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var0_63:getPainting(), "", arg2_63:Find("skin/Image"))

				local var1_63 = var0_63:getSkinId()

				changeToScrollText(arg2_63:Find("skin/name/Text"), pg.ship_skin_template[var1_63].name)
				setActive(arg2_63:Find("skin/status"), false)

				local var2_63 = var0_63:GetShipPhantomMark()

				setActive(arg2_63:Find("selected"), underscore.any(arg0_60.selectedMarks or {}, function(arg0_64)
					return var2_63 == arg0_64
				end))
				setActive(arg2_63:Find("skin/mark/base"), arg0_60.contextData.mode ~= var0_0.MODE_SHIP_PHANTOM)
				setActive(arg2_63:Find("skin/mark/toggle"), arg0_60.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

				local var3_63 = var0_63:getRandomFlag()

				onToggle(arg0_60, arg2_63:Find("skin/mark/toggle"), function(arg0_65)
					if arg0_65 ~= var3_63 then
						var3_63 = arg0_65

						arg0_60:emit(DockyardMediator.CHANGE_RANDOM_FLAG, var0_63:GetShipPhantomMark(), var3_63)
					end
				end, SFX_UI_CLICK)
				triggerToggle(arg2_63:Find("skin/mark/toggle"), var3_63)
			else
				setActive(arg2_63:Find("selected"), false)
			end

			onButton(arg0_60, arg2_63, function()
				if var0_63 then
					arg0_60:OnClickPhantom(var0_63)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shadow_unlock_tip"))
				end
			end, SFX_UI_CLICK)
		end
	end)
end

function var0_0.showEnergyDesc(arg0_67, arg1_67, arg2_67)
	if LeanTween.isTweening(go(arg0_67.energyDescTF)) then
		LeanTween.cancel(go(arg0_67.energyDescTF))

		arg0_67.energyDescTF.localScale = Vector3.one
	end

	setText(arg0_67.energyDescTextTF, i18n(arg2_67))

	arg0_67.energyDescTF.position = arg1_67

	setActive(arg0_67.energyDescTF, true)
	LeanTween.scale(arg0_67.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0_67.energyDescTF.localScale = Vector3.one

		setActive(arg0_67.energyDescTF, false)
	end))
end

function var0_0.onUpdateItem(arg0_69, arg1_69, arg2_69)
	local var0_69 = arg0_69.shipVOs[arg1_69 + 1]
	local var1_69 = var0_69 and var0_69.id or 0

	arg0_69.cardItemDic[var1_69] = arg2_69

	local var2_69 = arg0_69:onInitItem(arg2_69)

	var2_69:update(var0_69)

	if arg0_69.contextData.mode == DockyardScene.MODE_WORLD then
		var2_69:updateWorld()
	end

	var2_69:updateSelected(var2_69.shipVO and underscore.any(arg0_69.selectedIds, function(arg0_70)
		return var2_69.shipVO.id == arg0_70
	end))
	arg0_69:updateItemBlackBlock(var2_69)

	var2_69.isLoading = false

	var2_69:updateIntimacyEnergy(arg0_69.contextData.energyDisplay or arg0_69.sortIndex == ShipIndexConst.SortEnergy)

	local var3_69 = (arg0_69.sortIndex == ShipIndexConst.SortIntimacy or arg0_69.extraIndex == ShipIndexConst.ExtraMarry) and arg0_69.contextData.mode ~= DockyardScene.MODE_UPGRADE

	var2_69:updateIntimacy(var3_69)
end

function var0_0.onReturnItem(arg0_71, arg1_71, arg2_71)
	if arg0_71.exited then
		return
	end

	local var0_71 = arg0_71.scrollItems[arg2_71]

	if var0_71 then
		var0_71:clear()
	end
end

function var0_0.updateIndexDatas(arg0_72)
	arg0_72.contextData.indexDatas = arg0_72.contextData.indexDatas or {}
	arg0_72.contextData.indexDatas.sortIndex = arg0_72.sortIndex
	arg0_72.contextData.indexDatas.typeIndex = arg0_72.typeIndex
	arg0_72.contextData.indexDatas.campIndex = arg0_72.campIndex
	arg0_72.contextData.indexDatas.rarityIndex = arg0_72.rarityIndex
	arg0_72.contextData.indexDatas.extraIndex = arg0_72.extraIndex
end

function var0_0.initIndexPanel(arg0_73)
	onButton(arg0_73, arg0_73.indexBtn, function()
		local var0_74 = {
			indexDatas = Clone(arg0_73.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				sortIndex = {
					isSort = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.SortIndexs,
					names = ShipIndexConst.SortNames
				},
				sortPropertyIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.SortPropertyIndexs,
					names = ShipIndexConst.SortPropertyNames
				},
				typeIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.TypeIndexs,
					names = ShipIndexConst.TypeNames
				},
				campIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.CampIndexs,
					names = ShipIndexConst.CampNames
				},
				rarityIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.RarityIndexs,
					names = ShipIndexConst.RarityNames
				},
				extraIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.ExtraIndexs,
					names = ShipIndexConst.ExtraNames
				},
				layoutPos = Vector2(0, -25)
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_sort",
					titleENTxt = "indexsort_sorteng",
					tags = {
						"sortIndex"
					},
					simpleDropdown = {
						"sortPropertyIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_index",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"typeIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_camp",
					titleENTxt = "indexsort_campeng",
					tags = {
						"campIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_extraindex",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"extraIndex"
					}
				}
			},
			callback = function(arg0_75)
				arg0_73.sortIndex = arg0_75.sortIndex
				arg0_73.typeIndex = arg0_75.typeIndex
				arg0_73.campIndex = arg0_75.campIndex
				arg0_73.rarityIndex = arg0_75.rarityIndex
				arg0_73.extraIndex = arg0_75.extraIndex

				arg0_73:updateIndexDatas()
				arg0_73:filter()
			end
		}

		arg0_73:emit(DockyardMediator.OPEN_DOCKYARD_INDEX, var0_74)
	end, SFX_PANEL)
	onToggle(arg0_73, arg0_73.preferenceBtn, function(arg0_76)
		if arg0_76 then
			arg0_73.commonTag = Ship.PREFERENCE_TAG_COMMON
		else
			arg0_73.commonTag = Ship.PREFERENCE_TAG_NONE
		end

		arg0_73:filter()
	end)
end

function var0_0.setShips(arg0_77, arg1_77)
	arg0_77.shipVOsById = arg1_77

	local var0_77 = getProxy(TechnologyProxy)

	arg0_77.shipBluePrints = {}

	for iter0_77, iter1_77 in ipairs(var0_77:getAllBluePrintShipIds()) do
		local var1_77 = getProxy(BayProxy):getShipById(iter1_77)

		if #var1_77:getAllShipPhantomMarks() > 1 then
			table.insert(arg0_77.shipBluePrints, var0_77:getBluePrintById(var1_77.groupId))
		end
	end

	table.sort(arg0_77.shipBluePrints, CompareFuncs({
		function(arg0_78)
			return arg0_78:getConfig("blueprint_version")
		end,
		function(arg0_79)
			return arg0_79.id
		end
	}))
end

function var0_0.setPlayer(arg0_80, arg1_80)
	arg0_80.player = arg1_80

	arg0_80:updateBarInfo()
end

function var0_0.updateBarInfo(arg0_81)
	setActive(arg0_81.bottomTipsText, arg0_81.contextData.leftTopInfo)
	setText(arg0_81.bottomTipsText, arg0_81.contextData.leftTopInfo and i18n("dock_yard_left_tips", arg0_81.contextData.leftTopInfo) or "")
	setActive(arg0_81.bottomTipsWithFrame, arg0_81.contextData.leftTopWithFrameInfo)
	setText(arg0_81.bottomTipsWithFrame:Find("Text"), arg0_81.contextData.leftTopWithFrameInfo or "")

	if arg0_81.contextData.mode == var0_0.MODE_WORLD or arg0_81.contextData.mode == var0_0.MODE_GUILD_BOSS or arg0_81.contextData.mode == var0_0.MODE_REMOULD or arg0_81.isPhantomMode then
		setActive(arg0_81.leftTipsText, false)
	else
		setActive(arg0_81.leftTipsText, true)
		arg0_81:updateCapacityDisplay()
	end
end

function var0_0.updateCapacityDisplay(arg0_82)
	setActive(arg0_82.leftTipsText:Find("plus"), not arg0_82.isCapacityMeta)
	setActive(arg0_82.leftTipsText:Find("tip"), arg0_82.isCapacityMeta)
	setActive(arg0_82.leftTipsText:Find("switch/off"), not arg0_82.isCapacityMeta)
	setActive(arg0_82.leftTipsText:Find("switch/on"), arg0_82.isCapacityMeta)

	if arg0_82.isCapacityMeta then
		setText(arg0_82.leftTipsText:Find("label"), i18n("specialshipyard_name"))
		setText(arg0_82.leftTipsText:Find("Text"), arg0_82.specialShipCount)
	else
		setText(arg0_82.leftTipsText:Find("label"), i18n("ship_dockyardScene_capacity"))
		setText(arg0_82.leftTipsText:Find("Text"), arg0_82.shipsCount .. "/" .. arg0_82.player:getMaxShipBag())
	end
end

function var0_0.initWorldPanel(arg0_83)
	onButton(arg0_83, arg0_83.worldPanel:Find("btn_repair"), function()
		if #arg0_83.selectedIds > 0 then
			arg0_83:repairWorldShip(arg0_83.shipVOsById[arg0_83.selectedIds[1]])
		end
	end, SFX_PANEL)
	onButton(arg0_83, arg0_83.worldPanel:Find("btn_repair_all"), function()
		local var0_85 = {}
		local var1_85 = 0

		for iter0_85, iter1_85 in pairs(arg0_83.shipVOsById) do
			local var2_85 = WorldConst.FetchWorldShip(iter1_85.id)

			if var2_85:IsBroken() or not var2_85:IsHpFull() then
				table.insert(var0_85, var2_85.id)

				var1_85 = var1_85 + nowWorld():CalcRepairCost(var2_85)
			end
		end

		if #var0_85 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_ship_repair_all", var1_85),
				onYes = function()
					arg0_83:emit(DockyardMediator.ON_SHIP_REPAIR, var0_85, var1_85)
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.repairWorldShip(arg0_87, arg1_87)
	local var0_87 = WorldConst.FetchWorldShip(arg1_87.id)
	local var1_87 = nowWorld():CalcRepairCost(var0_87)

	if var0_87:IsBroken() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_2", arg1_87:getName(), var1_87),
			onYes = function()
				arg0_87:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_87.id
				}, var1_87)
			end
		})
	elseif not var0_87:IsHpFull() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_1", arg1_87:getName(), var1_87),
			onYes = function()
				arg0_87:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_87.id
				}, var1_87)
			end
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
	end
end

function var0_0.filter(arg0_90)
	local var0_90 = arg0_90:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	LoadImageSpriteAtlasAsync("ui/dockyardui_atlas", var0_90, arg0_90.indexBtn, true)

	if arg0_90.isRemouldOrUpgradeMode then
		arg0_90:filterForRemouldAndUpgrade()
	else
		arg0_90:filterCommon()
	end

	local var1_90 = 0

	if arg0_90.contextData.quitTeam then
		var1_90 = var1_90 + 1

		table.insert(arg0_90.shipVOs, var1_90, false)
	end

	if arg0_90.contextData.priorEquipUpShipIDList then
		local var2_90 = {}

		for iter0_90, iter1_90 in ipairs(arg0_90.contextData.priorEquipUpShipIDList) do
			var2_90[iter1_90] = true
		end

		for iter2_90 = #arg0_90.shipVOs, 1, -1 do
			local var3_90 = type(arg0_90.shipVOs[iter2_90]) == "table" and arg0_90.shipVOs[iter2_90].id

			if var2_90[var3_90] then
				var2_90[var3_90] = table.remove(arg0_90.shipVOs, iter2_90)
			end
		end

		for iter3_90, iter4_90 in ipairs(arg0_90.contextData.priorEquipUpShipIDList) do
			local var4_90 = var2_90[iter4_90]

			if type(var4_90) == "table" then
				var1_90 = var1_90 + 1

				table.insert(arg0_90.shipVOs, var1_90, var4_90)
			end
		end
	end

	if var0_0.MODE_OVERVIEW == arg0_90.contextData.mode and DockyardScene.value then
		arg0_90:updateShipCount(DockyardScene.value or 0)

		DockyardScene.value = nil
	else
		arg0_90:updateShipCount(0)
	end
end

function var0_0.filterForRemouldAndUpgrade(arg0_91)
	arg0_91.shipVOs = {}

	local var0_91 = arg0_91.isFilterLockForMod
	local var1_91 = arg0_91.isFilterLevelForMod

	local function var2_91(arg0_92)
		local var0_92 = true

		if not var0_91 and arg0_92.lockState == Ship.LOCK_STATE_LOCK then
			var0_92 = false
		end

		if not var1_91 and arg0_92.level > 1 then
			var0_92 = false
		end

		return var0_92
	end

	for iter0_91, iter1_91 in pairs(arg0_91.shipVOsById) do
		if var2_91(iter1_91) then
			table.insert(arg0_91.shipVOs, iter1_91)
		end
	end

	table.sort(arg0_91.shipVOs, CompareFuncs({
		function(arg0_93)
			return arg0_93.level
		end,
		function(arg0_94)
			return arg0_94:isTestShip() and 1 or 0
		end
	}))
end

function var0_0.filterCommon(arg0_95)
	arg0_95.shipVOs = {}

	local var0_95 = arg0_95.sortIndex

	local function var1_95(arg0_96)
		if arg0_95.contextData.mode ~= var0_0.MODE_GUILD_BOSS then
			return true
		end

		if arg0_95.isShowAssultShips then
			return true
		end

		if not arg0_96.user then
			return true
		end

		if arg0_96.user.id == arg0_95.player.id then
			return true
		end

		return false
	end

	for iter0_95, iter1_95 in pairs(arg0_95.shipVOsById) do
		if arg0_95.contextData.blockLock and iter1_95:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0_95.teamTypeFilter and iter1_95:getTeamType() ~= arg0_95.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1_95, arg0_95.typeIndex) and ShipIndexConst.filterByCamp(iter1_95, arg0_95.campIndex) and ShipIndexConst.filterByRarity(iter1_95, arg0_95.rarityIndex) and ShipIndexConst.filterByExtra(iter1_95, arg0_95.extraIndex) and (arg0_95.commonTag == Ship.PREFERENCE_TAG_NONE or arg0_95.commonTag == iter1_95:GetPreferenceTag()) and var1_95(iter1_95) then
			table.insert(arg0_95.shipVOs, iter1_95)
		end
	end

	local var2_95 = getInputText(arg0_95.nameSearchInput)

	if var2_95 and var2_95 ~= "" then
		arg0_95.shipVOs = underscore.filter(arg0_95.shipVOs, function(arg0_97)
			return arg0_97:IsMatchKey(var2_95)
		end)
	end

	local var3_95, var4_95 = ShipIndexConst.getSortFuncAndName(var0_95, arg0_95.selectAsc)

	if (var0_95 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0_95.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3_95, 1, function(arg0_98)
			return arg0_98:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3_95 then
		arg0_95:SortShips(var3_95)
	end

	arg0_95:updateSelected()
	setActive(arg0_95.sortImgAsc, arg0_95.selectAsc)
	setActive(arg0_95.sortImgDesc, not arg0_95.selectAsc)
	setText(arg0_95:findTF("Image", arg0_95.sortBtn), i18n(var4_95))
end

function var0_0.SortShips(arg0_99, arg1_99)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0_99 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1_99 = {
			function(arg0_100)
				return table.contains(var0_99, arg0_100.configId) and 0 or 1
			end
		}
	elseif arg0_99.isFormTactics then
		table.insert(arg1_99, 1, function(arg0_101)
			return arg0_101:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1_99, 1, function(arg0_102)
			return arg0_102:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0_99.contextData.mode == var0_0.MODE_OVERVIEW or arg0_99.contextData.mode == var0_0.MODE_SELECT then
		table.insert(arg1_99, 1, function(arg0_103)
			return -arg0_103.activityNpc
		end)
	elseif arg0_99.contextData.mode == var0_0.MODE_GUILD_BOSS then
		table.insert(arg1_99, 1, function(arg0_104)
			return arg0_104.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0_99.shipVOs, CompareFuncs(arg1_99))
end

function var0_0.UpdateGuildViewEquipmentsBtn(arg0_105)
	setActive(arg0_105.viewEquipmentBtn, arg0_105.contextData.mode == var0_0.MODE_GUILD_BOSS and #arg0_105.selectedIds > 0)
end

function var0_0.GetSelectCount(arg0_106)
	return #arg0_106.selectedIds
end

function var0_0.GetConfirmSelect(arg0_107)
	return arg0_107.selectedIds
end

function var0_0.didEnter(arg0_108)
	if arg0_108:isLayer() then
		arg0_108:OverlayPanel(arg0_108._tf, {
			groupDelta = -1
		})
	end

	arg0_108:OverlayPanel(arg0_108.blurPanel)
	arg0_108:PlayUIAnimation(arg0_108.blurPanel, "enter")
	setActive(arg0_108.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0_108.contextData.mode ~= var0_0.MODE_GUILD_BOSS)
	arg0_108:UpdateGuildViewEquipmentsBtn()
	onButton(arg0_108, arg0_108.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0_108, arg0_108:findTF("back", arg0_108.topPanel), function()
		arg0_108:back()
	end, SFX_CANCEL)
	onButton(arg0_108, arg0_108.sortBtn, function()
		arg0_108.selectAsc = not arg0_108.selectAsc

		arg0_108:filter()
	end, SFX_UI_CLICK)
	onToggle(arg0_108, arg0_108.assultBtn, function(arg0_112)
		arg0_108.isShowAssultShips = arg0_112

		arg0_108:filter()
	end, SFX_PANEL)
	onButton(arg0_108, arg0_108.viewEquipmentBtn, function()
		local var0_113 = arg0_108.selectedIds[#arg0_108.selectedIds]

		if not var0_113 then
			return
		end

		local var1_113 = arg0_108.shipVOsById[var0_113]
		local var2_113 = var1_113.user

		arg0_108.guildShipEquipmentsPage:ExecuteAction("Show", var1_113, var2_113)
	end, SFX_PANEL)
	onButton(arg0_108, arg0_108.attrBtn, function()
		if not arg0_108.isFormTactics then
			arg0_108.itemDetailType = (arg0_108.itemDetailType + 1) % 4
		else
			arg0_108.itemDetailType = arg0_108.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(arg0_108.attrBtn:Find("off"), arg0_108.itemDetailType == DockyardShipItem.DetailType0)
		setActive(arg0_108.attrBtn:Find("on"), arg0_108.itemDetailType ~= DockyardShipItem.DetailType0)

		arg0_108.attrBtn:GetComponent("Button").targetGraphic = arg0_108.itemDetailType == DockyardShipItem.DetailType0 and imageOff or imageOn

		arg0_108:updateItemDetailType()
	end, SFX_PANEL)
	onButton(arg0_108, arg0_108.selectPanel:Find("cancel_button"), function()
		if arg0_108.animating then
			return
		end

		if arg0_108.contextData.mode == var0_0.MODE_DESTROY then
			if #arg0_108.selectedIds > 0 then
				arg0_108:unselecteAllShips()
				arg0_108:back()
			else
				arg0_108:back()
			end
		else
			arg0_108:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0_108, arg0_108.selectPanel:Find("confirm_button"), function()
		if arg0_108.animating then
			return
		end

		if arg0_108.contextData.mode == var0_0.MODE_DESTROY then
			local var0_116, var1_116 = arg0_108:checkDestroyGold()

			if not var0_116 or not var1_116 then
				if not var0_116 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0_116 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if arg0_108:GetSelectCount() < arg0_108.selectedMin then
			if arg0_108.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0_108.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0_108.selectedMin))
			end

			return
		end

		if arg0_108.contextData.mode == var0_0.MODE_DESTROY then
			arg0_108:displayDestroyPanel()
		else
			local var2_116 = {}

			if arg0_108.contextData.destroyCheck then
				local var3_116 = underscore.map(arg0_108.selectedIds, function(arg0_117)
					return arg0_108.shipVOsById[arg0_117]
				end)

				table.insert(var2_116, function(arg0_118)
					arg0_108:checkDestroyShips(var3_116, arg0_118)
				end)
			end

			local var4_116 = arg0_108:GetConfirmSelect()

			if arg0_108.confirmSelect then
				table.insert(var2_116, function(arg0_119)
					arg0_108.confirmSelect(var4_116, function()
						arg0_119(true)
					end, arg0_119)
				end)
				seriesAsync(var2_116, function(arg0_121)
					if arg0_121 then
						arg0_108.onSelected(var4_116)
					end

					arg0_108:back()
				end)
			else
				table.insert(var2_116, function(arg0_122)
					if arg0_108.callbackQuit then
						arg0_108.onSelected(var4_116, arg0_122)
					else
						arg0_108.onSelected(var4_116)
						arg0_122()
					end
				end)
				seriesAsync(var2_116, function()
					arg0_108:back()
				end)
			end
		end
	end, SFX_CONFIRM)
	onButton(arg0_108, arg0_108.selectPanel:Find("quick_select"), function()
		if arg0_108.animating then
			return
		end

		local var0_124 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1_124 = 3
		local var2_124 = {}

		for iter0_124, iter1_124 in pairs(var0_124) do
			if iter1_124 ~= 0 then
				var2_124[iter1_124] = var2_124[iter1_124] or var1_124
				var1_124 = var1_124 - 1
			end
		end

		local var3_124 = getProxy(BayProxy):getShips()
		local var4_124 = {}
		local var5_124 = {}

		for iter2_124, iter3_124 in pairs(var3_124) do
			if iter3_124:isMaxStar() then
				var4_124[iter3_124:getGroupId()] = true
			else
				local var6_124 = iter3_124:getMaxStar() - iter3_124:getStar() + 1

				if iter3_124:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6_124 = var6_124 + 1
				end

				local var7_124 = var5_124[iter3_124:getGroupId()]

				var5_124[iter3_124:getGroupId()] = var7_124 and var7_124 < var6_124 and var7_124 or var6_124
			end
		end

		local var8_124 = _.select(arg0_108.shipVOs, function(arg0_125)
			return arg0_125.configId ~= 100001 and arg0_125.configId ~= 100011 and arg0_125:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0_124, arg0_125:getRarity()) and arg0_125.level == 1 and not arg0_108.blacklist[arg0_125:getGroupId()] and not table.contains(arg0_108.selectedIds, arg0_125.id) and not arg0_125:hasAnyFlag({
				"inFleet",
				"inChapter",
				"inWorld",
				"inEvent",
				"inBackyard",
				"inClass",
				"inTactics",
				"inExercise",
				"inAdmiral",
				"inElite",
				"inActivity",
				"inGuildEvent",
				"inGuildBossEvent"
			})
		end)

		if not _.all(var8_124, function(arg0_126)
			return arg0_108.blacklist[arg0_126:getGroupId()]
		end) then
			var8_124 = _.select(var8_124, function(arg0_127)
				return not arg0_108.blacklist[arg0_127:getGroupId()]
			end)
		elseif #arg0_108.selectedIds > 0 then
			var8_124 = {}
		end

		table.sort(var8_124, function(arg0_128, arg1_128)
			local var0_128 = var2_124[arg0_128:getRarity()] or 0
			local var1_128 = var2_124[arg1_128:getRarity()] or 0

			if var0_128 == var1_128 then
				if arg0_128:getGroupId() == arg1_128:getGroupId() then
					return arg0_128.createTime > arg1_128.createTime
				end

				return arg0_128.configId > arg1_128.configId
			else
				return var1_128 < var0_128
			end
		end)

		local var9_124 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10_124 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11_124 = {}
		local var12_124 = _.select(var8_124, function(arg0_129)
			if var4_124[arg0_129:getGroupId()] then
				if var9_124 == "KeepNone" then
					return true
				elseif var9_124 == "KeepOne" then
					if not var11_124[arg0_129:getGroupId()] then
						var11_124[arg0_129:getGroupId()] = true

						return false
					end

					return true
				elseif var9_124 == "KeepAll" then
					return false
				end
			elseif var10_124 == "KeepNone" then
				return true
			elseif var10_124 == "KeepNeeded" then
				if var5_124[arg0_129:getGroupId()] > 0 then
					var5_124[arg0_129:getGroupId()] = var5_124[arg0_129:getGroupId()] - 1

					return false
				end

				return true
			elseif var10_124 == "KeepAll" then
				return false
			end
		end)
		local var13_124 = 0
		local var14_124 = false
		local var15_124 = false
		local var16_124 = 0
		local var17_124 = 0

		for iter4_124, iter5_124 in ipairs(arg0_108.selectedIds) do
			local var18_124, var19_124 = arg0_108.shipVOsById[iter5_124]:calReturnRes()

			var16_124 = var16_124 + var18_124
			var17_124 = var17_124 + var19_124
		end

		for iter6_124, iter7_124 in ipairs(var12_124) do
			if arg0_108.selectedMax > 0 and arg0_108.selectedMax <= arg0_108:GetSelectCount() then
				break
			end

			local var20_124, var21_124 = iter7_124:calReturnRes()

			var16_124 = var16_124 + var20_124
			var17_124 = var17_124 + var21_124
			var14_124 = arg0_108.player:OilMax(var17_124)
			var15_124 = arg0_108.player:GoldMax(var16_124)

			if var15_124 then
				break
			end

			var13_124 = var13_124 + 1

			arg0_108:selectShip(iter7_124)
		end

		if var13_124 == 0 then
			if var15_124 then
				if #arg0_108.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0_108.selectedIds > 0 then
				arg0_108:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14_124 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0_108:displayDestroyPanel()
				end
			})
		else
			arg0_108:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if isActive(arg0_108.togglePhantom) then
		triggerToggle(arg0_108.togglePhantom, tobool(arg0_108.inPhantom))
	else
		arg0_108:SwitchContainerDisplay()
	end

	arg0_108:updateBarInfo()

	if arg0_108.contextData.mode == var0_0.MODE_WORLD then
		arg0_108:initWorldPanel()
	elseif arg0_108.contextData.mode == var0_0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_108)
	end

	setAnchoredPosition(arg0_108.topPanel, {
		y = arg0_108.topPanel.rect.height
	})
	setAnchoredPosition(arg0_108.selectPanel, {
		y = -1 * arg0_108.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0_108.exited then
			return
		end

		arg0_108:uiStartAnimating()
	end)

	arg0_108.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_108)

	onButton(arg0_108, arg0_108.settingBtn, function()
		arg0_108.settingPanel:Load()
		arg0_108.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0_108)
end

function var0_0.TriggerCard(arg0_133, arg1_133)
	local var0_133 = arg0_133.selectedIds[1]

	if not var0_133 then
		return
	end

	local var1_133

	for iter0_133, iter1_133 in ipairs(arg0_133.shipVOs) do
		if iter1_133 and iter1_133.id == var0_133 then
			var1_133 = iter0_133

			break
		end
	end

	if not var1_133 then
		return
	end

	local var2_133 = var1_133
	local var3_133

	local function var4_133()
		var2_133 = var2_133 + arg1_133

		local var0_134 = arg0_133.shipVOs[var2_133]

		if not var0_134 or arg0_133.checkShip(var0_134) then
			return var0_134
		else
			return var4_133()
		end
	end

	local var5_133 = var4_133()

	if not var5_133 then
		return
	end

	local function var6_133()
		local var0_135

		for iter0_135, iter1_135 in pairs(arg0_133.scrollItems) do
			if iter1_135.shipVO and iter1_135.go.name ~= "-1" and iter1_135.shipVO.id == var5_133.id then
				var0_135 = iter1_135

				break
			end
		end

		return var0_135
	end

	local var7_133 = arg0_133.cardItemDic[var0_133]
	local var8_133 = var7_133 and arg0_133.scrollItems[var7_133]
	local var9_133 = var8_133 and var8_133.shipVO.id == var5_133.id and var8_133 or nil

	if var9_133 then
		local var10_133 = getBounds(arg0_133:findTF("main/ship_container"))
		local var11_133 = getBounds(var9_133.tr)

		if not var10_133:Intersects(var11_133) then
			local var12_133 = arg1_133 * (arg0_133.shipContainer:HeadIndexToValue(7) - arg0_133.shipContainer:HeadIndexToValue(1))
			local var13_133 = arg0_133.shipContainer.value + var12_133

			arg0_133.shipContainer:SetNormalizedPosition(var13_133, 1)
		end
	end

	if not var9_133 then
		local var14_133 = (math.ceil(var2_133 / 7) - math.ceil(var1_133 / 7)) * (arg0_133.shipContainer:HeadIndexToValue(21) - arg0_133.shipContainer:HeadIndexToValue(1))
		local var15_133 = arg0_133.shipContainer.value + var14_133

		arg0_133.shipContainer:SetNormalizedPosition(var15_133, 1)

		var9_133 = var6_133()
	end

	if var9_133 then
		triggerButton(var9_133.tr)

		local var16_133 = arg0_133.shipVOsById[var9_133.shipVO.id]

		arg0_133.guildShipEquipmentsPage:Refresh(var16_133, var16_133.user)
	end
end

function var0_0.OnSwitch(arg0_136, arg1_136, arg2_136, arg3_136)
	local function var0_136()
		setActive(arg1_136:Find("off"), not arg2_136)
		setActive(arg1_136:Find("on"), arg2_136)
	end

	onButton(arg0_136, arg1_136, function()
		arg2_136 = not arg2_136

		if arg3_136 then
			arg3_136(arg2_136)
		end

		var0_136()
	end, SFX_PANEL)
	var0_136()
end

function var0_0.OnShipSkinChanged(arg0_139, arg1_139)
	local var0_139, var1_139 = ShipPhantom.UnpackMark(arg1_139)
	local var2_139 = arg0_139.phantomGroupDic[var0_139]
	local var3_139 = var2_139 and arg0_139.scrollPhantoms[var2_139]

	if var3_139 and var3_139.shipCard.shipVO.id == var0_139 then
		arg0_139:updatePhantomGroup(underscore.detect(arg0_139.filterBluePrint, function(arg0_140)
			return arg0_140.shipId == var0_139
		end), var2_139)
	end
end

function var0_0.onBackPressed(arg0_141)
	if arg0_141.destroyConfirmWindow:isShowing() then
		arg0_141.destroyConfirmWindow:Hide()

		return
	end

	if arg0_141.destroyPage:isShowing() then
		arg0_141.destroyPage:Hide()

		return
	end

	if arg0_141.settingPanel:isShowing() then
		arg0_141.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_141:back()
end

function var0_0.updateShipStatusById(arg0_142, arg1_142)
	local var0_142 = arg0_142.cardItemDic[arg1_142]
	local var1_142 = var0_142 and arg0_142.scrollItems[var0_142]

	if var1_142 and var1_142.shipVO.id == arg1_142 then
		var1_142:flush(arg0_142.selectedIds)

		if arg0_142.contextData.mode == DockyardScene.MODE_WORLD then
			var1_142:updateWorld()
		end
	end
end

function var0_0.checkDestroyGold(arg0_143, arg1_143)
	local var0_143 = 0
	local var1_143 = 0

	for iter0_143, iter1_143 in ipairs(arg0_143.selectedIds) do
		local var2_143, var3_143 = arg0_143.shipVOsById[iter1_143]:calReturnRes()

		var0_143 = var0_143 + var2_143
		var1_143 = var1_143 + var3_143
	end

	if arg1_143 then
		local var4_143, var5_143 = arg1_143:calReturnRes()

		var0_143 = var0_143 + var4_143
		var1_143 = var1_143 + var5_143
	end

	local var6_143 = arg0_143.player:OilMax(var1_143)

	if arg0_143.player:GoldMax(var0_143) then
		return false, not var6_143
	end

	return true, not var6_143
end

function var0_0.selectShip(arg0_144, arg1_144)
	local var0_144 = false
	local var1_144

	for iter0_144, iter1_144 in ipairs(arg0_144.selectedIds) do
		if iter1_144 == arg1_144.id then
			var0_144 = true
			var1_144 = iter0_144

			break
		end
	end

	if var0_144 or arg0_144.selectedMax == 1 and arg0_144:GetSelectCount() > 0 then
		local var2_144 = defaultValue(var1_144, 1)
		local var3_144 = arg0_144.shipVOsById[arg0_144.selectedIds[var2_144]]
		local var4_144, var5_144 = arg0_144.onCancelShip(var3_144, function()
			if not arg0_144.exited then
				return
			end

			arg0_144:selectShip(arg1_144)
		end, arg0_144.selectedIds)

		if not var4_144 then
			if var5_144 then
				pg.TipsMgr.GetInstance():ShowTips(var5_144)
			end

			return
		end

		table.remove(arg0_144.selectedIds, var2_144)

		if arg0_144.selectedMax ~= 1 then
			arg0_144:updateBlackBlocks(var3_144)
		end
	end

	if not var0_144 then
		local var6_144, var7_144 = arg0_144.checkShip(arg1_144, function()
			if arg0_144.exited then
				return
			end

			arg0_144:selectShip(arg1_144)
		end, arg0_144.selectedIds)

		if not var6_144 then
			if var7_144 then
				pg.TipsMgr.GetInstance():ShowTips(var7_144)
			end

			return
		end

		if arg0_144.selectedMax == 0 or arg0_144:GetSelectCount() < arg0_144.selectedMax then
			table.insert(arg0_144.selectedIds, arg1_144.id)

			if arg0_144.selectedMax ~= 1 then
				arg0_144:updateBlackBlocks(removeShip)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_144.selectedMax))

			return
		end
	end

	arg0_144:updateSelected()

	if arg0_144.contextData.mode == var0_0.MODE_DESTROY then
		arg0_144:updateDestroyRes()
	elseif arg0_144.contextData.mode == var0_0.MODE_MOD then
		arg0_144:updateModAttr()
	end

	arg0_144:UpdateGuildViewEquipmentsBtn()
end

function var0_0.updateBlackBlocks(arg0_147, arg1_147)
	if not arg0_147.contextData.useBlackBlock or not arg1_147 then
		return
	end

	for iter0_147, iter1_147 in pairs(arg0_147.scrollItems) do
		arg0_147:updateItemBlackBlock(iter1_147)
	end
end

function var0_0.updateItemBlackBlock(arg0_148, arg1_148)
	if arg0_148.contextData.useBlackBlock then
		if arg0_148.selectedMax == 1 then
			arg1_148:updateBlackBlock(arg0_148.contextData.otherSelectedIds)
		else
			arg1_148:updateBlackBlock(arg0_148.selectedIds)
		end
	else
		arg1_148:updateBlackBlock()
	end
end

function var0_0.unselecteAllShips(arg0_149)
	arg0_149.selectedIds = {}

	arg0_149:updateSelected()
	arg0_149:updateDestroyRes()
end

function var0_0.updateSelected(arg0_150)
	if arg0_150.shipContainer then
		for iter0_150, iter1_150 in pairs(arg0_150.scrollItems) do
			if not iter1_150.isClear then
				local var0_150 = iter1_150.shipVO and iter1_150.shipVO.id or nil

				iter1_150:updateSelected(iter1_150.shipVO and underscore.any(arg0_150.selectedIds, function(arg0_151)
					return var0_150 == arg0_151
				end))
			end
		end
	end

	if arg0_150.phantomContainer then
		for iter2_150, iter3_150 in pairs(arg0_150.scrollPhantoms) do
			if not iter3_150.isClear then
				local var1_150 = iter3_150.shipCard.shipVO.id
				local var2_150 = {}
				local var3_150 = getGameset("technology_shadow_num")[1]

				for iter4_150 = 0, var3_150 do
					if iter4_150 == 0 then
						var2_150[iter4_150] = underscore.any(arg0_150.selectedIds, function(arg0_152)
							return var1_150 == arg0_152
						end)
					else
						var2_150[iter4_150] = underscore.any(arg0_150.selectedMarks, function(arg0_153)
							return arg0_153 == ShipPhantom.PackMark(var1_150, iter4_150)
						end)
					end
				end

				iter3_150:updateSelected(var2_150)
			end
		end
	end

	if arg0_150.selectedMax == 0 then
		setText(arg0_150.selectPanel:Find("bottom_info/bg_input/count"), arg0_150:GetSelectCount())
	else
		local var4_150 = arg0_150:GetSelectCount()

		if arg0_150.contextData.mode ~= var0_0.MODE_DESTROY or arg0_150:GetSelectCount() == 0 then
			var4_150 = setColorStr(var4_150, COLOR_WHITE)
		elseif arg0_150.contextData.mode == var0_0.MODE_DESTROY then
			var4_150 = setColorStr(var4_150, #arg0_150.selectedIds == 10 and COLOR_RED or COLOR_GREEN)
		end

		setText(arg0_150.selectPanel:Find("bottom_info/bg_input/count"), var4_150 .. "/" .. arg0_150.selectedMax)
	end

	if arg0_150:GetSelectCount() < arg0_150.selectedMin then
		setActive(arg0_150.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0_150.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0_150.contextData.mode == var0_0.MODE_MOD then
		arg0_150:updateModAttr()
	end
end

function var0_0.updateItemDetailType(arg0_154)
	for iter0_154, iter1_154 in pairs(arg0_154.scrollItems) do
		iter1_154:updateDetail(arg0_154.itemDetailType)
	end

	arg0_154.shipLayout.anchoredPosition = arg0_154.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0_0.closeDestroyMode(arg0_155)
	setActive(arg0_155.awardTF, false)
	setActive(arg0_155.bottomTipsText, true)
end

function var0_0.updateDestroyRes(arg0_156)
	if table.getCount(arg0_156.selectedIds) == 0 then
		arg0_156:closeDestroyMode()
	else
		setActive(arg0_156.awardTF, true)
		setActive(arg0_156.bottomTipsText, false)
	end

	local var0_156 = _.map(arg0_156.selectedIds, function(arg0_157)
		return arg0_156.shipVOsById[arg0_157]
	end)
	local var1_156, var2_156, var3_156 = ShipCalcHelper.CalcDestoryRes(var0_156)
	local var4_156 = var2_156 == 0

	if arg0_156.destroyResList then
		local var5_156 = (var4_156 and 1 or 2) + #var3_156

		arg0_156.destroyResList:make(function(arg0_158, arg1_158, arg2_158)
			if arg0_158 == UIItemList.EventUpdate then
				local var0_158 = ""
				local var1_158 = 0

				if arg1_158 == 0 then
					var0_158, var1_158 = "Props/gold", var1_156
				elseif arg1_158 == 1 then
					if not var4_156 then
						var0_158, var1_158 = "Props/oil", var2_156
					else
						local var2_158 = var3_156[1]

						var0_158, var1_158 = Item.getConfigData(var2_158.id).icon, var2_158.count
					end
				elseif arg1_158 > 1 then
					local var3_158 = var4_156 and var3_156[arg1_158] or var3_156[arg1_158 - 1]

					var0_158, var1_158 = Item.getConfigData(var3_158.id).icon, var3_158.count
				end

				GetImageSpriteFromAtlasAsync(var0_158, "", arg2_158:Find("icon"))
				setText(arg2_158:Find("Text"), "X" .. var1_158)
			end
		end)
		arg0_156.destroyResList:align(var5_156)
	end

	if arg0_156.destroyPage and arg0_156.destroyPage:GetLoaded() and arg0_156.destroyPage:isShowing() then
		arg0_156.destroyPage:RefreshRes()
	end
end

function var0_0.setModShip(arg0_159, arg1_159)
	arg0_159.modShip = arg1_159
end

function var0_0.updateModAttr(arg0_160)
	if table.getCount(arg0_160.selectedIds) == 0 then
		arg0_160:closeModAttr()
	else
		setActive(arg0_160.modAttrsTF, true)
		setActive(arg0_160.bottomTipsText, false)
	end

	local var0_160 = arg0_160.contextData.ignoredIds[1]
	local var1_160 = {}

	for iter0_160, iter1_160 in ipairs(arg0_160.selectedIds) do
		table.insert(var1_160, arg0_160.shipVOsById[iter1_160])
	end

	local var2_160 = ShipModLayer.getModExpAdditions(arg0_160.modShip, var1_160)

	for iter2_160, iter3_160 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2_160 ~= ShipModLayer.IGNORE_ID then
			local var3_160 = arg0_160.modAttrContainer:Find("attr_" .. iter2_160)

			setText(var3_160:Find("value"), var2_160[iter3_160])
			setText(var3_160:Find("name"), ShipModAttr.id2Name(iter2_160))
		end
	end
end

function var0_0.closeModAttr(arg0_161)
	setActive(arg0_161.modAttrsTF, false)
	setActive(arg0_161.bottomTipsText, true)
end

function var0_0.removeShip(arg0_162, arg1_162)
	for iter0_162, iter1_162 in ipairs(arg0_162.selectedIds) do
		if iter1_162 == arg1_162 then
			table.remove(arg0_162.selectedIds, iter0_162)

			break
		end
	end

	for iter2_162 = #arg0_162.shipVOs, 1, -1 do
		if arg0_162.shipVOs[iter2_162].id == arg1_162 then
			table.remove(arg0_162.shipVOs, iter2_162)

			break
		end
	end

	arg0_162.shipVOsById[arg1_162] = nil
end

function var0_0.updateShipCount(arg0_163, arg1_163)
	arg0_163.shipContainer:SetTotalCount(#arg0_163.shipVOs, defaultValue(arg1_163, -1))
	setActive(arg0_163.listEmptyTF, #arg0_163.shipVOs <= 0)
end

function var0_0.ClearShipsBlackBlock(arg0_164)
	if not arg0_164.shipVOsById then
		return
	end

	for iter0_164, iter1_164 in pairs(arg0_164.shipVOsById) do
		iter1_164.blackBlock = false
	end
end

function var0_0.willExit(arg0_165)
	arg0_165:closeDestroyMode()
	arg0_165:closeModAttr()
	arg0_165:ClearShipsBlackBlock()

	if arg0_165.guildShipEquipmentsPage then
		arg0_165.guildShipEquipmentsPage:Destroy()
	end

	if arg0_165.settingPanel then
		arg0_165.settingPanel:Destroy()
	end

	if arg0_165.destroyPage then
		arg0_165.destroyPage:Destroy()
	end

	if arg0_165.destroyConfirmWindow then
		arg0_165.destroyConfirmWindow:Destroy()
	end

	if arg0_165.contextData.mode == var0_0.MODE_MOD then
		-- block empty
	elseif not arg0_165.contextData.sortData then
		if _G[arg0_165.contextData.preView] then
			_G[arg0_165.contextData.preView].sortIndex = arg0_165.sortIndex
			_G[arg0_165.contextData.preView].selectAsc = arg0_165.selectAsc
			_G[arg0_165.contextData.preView].typeIndex = arg0_165.typeIndex
			_G[arg0_165.contextData.preView].campIndex = arg0_165.campIndex
			_G[arg0_165.contextData.preView].rarityIndex = arg0_165.rarityIndex
			_G[arg0_165.contextData.preView].extraIndex = arg0_165.extraIndex
			_G[arg0_165.contextData.preView].commonTag = arg0_165.commonTag
		else
			DockyardScene.sortIndex = arg0_165.sortIndex
			DockyardScene.selectAsc = arg0_165.selectAsc
			DockyardScene.typeIndex = arg0_165.typeIndex
			DockyardScene.campIndex = arg0_165.campIndex
			DockyardScene.rarityIndex = arg0_165.rarityIndex
			DockyardScene.extraIndex = arg0_165.extraIndex
			DockyardScene.commonTag = arg0_165.commonTag
		end
	end

	if arg0_165.shipContainer then
		arg0_165.shipContainer.enabled = false

		for iter0_165, iter1_165 in pairs(arg0_165.scrollItems) do
			iter1_165:clear()
			GetOrAddComponent(iter1_165.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
		end
	end

	if arg0_165.phantomContainer then
		arg0_165.phantomContainer.enabled = false

		for iter2_165, iter3_165 in pairs(arg0_165.scrollPhantoms) do
			iter3_165:clear()
		end
	end

	if LeanTween.isTweening(go(arg0_165.energyDescTF)) then
		setActive(arg0_165.energyDescTF, false)
		LeanTween.cancel(go(arg0_165.energyDescTF))
	end

	arg0_165:cancelAnimating()

	if arg0_165.isRemouldOrUpgradeMode then
		local var0_165 = getProxy(SettingsProxy)

		var0_165:SetDockYardLockBtnFlag(arg0_165.isFilterLockForMod)
		var0_165:SetDockYardLevelBtnFlag(arg0_165.isFilterLevelForMod)
	end

	if arg0_165.bulinTip then
		arg0_165.bulinTip:Destroy()

		arg0_165.bulinTip = nil
	end

	arg0_165:UnOverlayPanel(arg0_165.blurPanel, arg0_165._tf)

	if arg0_165:isLayer() then
		arg0_165:UnOverlayPanel(arg0_165._tf)
	end
end

function var0_0.uiStartAnimating(arg0_166)
	local var0_166 = arg0_166:findTF("back", arg0_166.topPanel)
	local var1_166 = 0
	local var2_166 = 0.3

	if isActive(arg0_166.selectPanel) then
		shiftPanel(arg0_166.selectPanel, nil, 0, var2_166, var1_166, true, true)
	end
end

function var0_0.uiExitAnimating(arg0_167)
	if arg0_167.contextData.mode == var0_0.MODE_OVERVIEW then
		-- block empty
	else
		local var0_167 = 0
		local var1_167 = 0.3

		shiftPanel(arg0_167.selectPanel, nil, -1 * arg0_167.selectPanel.rect.height, var1_167, var0_167, true, true)
	end
end

function var0_0.back(arg0_168)
	if arg0_168.exited then
		return
	end

	arg0_168:closeView()
end

function var0_0.cancelAnimating(arg0_169)
	if LeanTween.isTweening(go(arg0_169.topPanel)) then
		LeanTween.cancel(go(arg0_169.topPanel))
	end

	if LeanTween.isTweening(go(arg0_169.selectPanel)) then
		LeanTween.cancel(go(arg0_169.selectPanel))
	end

	if arg0_169.tweens then
		cancelTweens(arg0_169.tweens)
	end
end

function var0_0.quickExitFunc(arg0_170)
	seriesAsync({
		function(arg0_171)
			if arg0_170.contextData.onQuickHome then
				arg0_170.contextData.onQuickHome(arg0_171)
			else
				arg0_171()
			end
		end,
		function(arg0_172)
			arg0_170:emit(var0_0.ON_HOME)
		end
	})
end

function var0_0.displayDestroyPanel(arg0_173)
	arg0_173.destroyPage:ExecuteAction("Show")
	arg0_173.destroyPage:ActionInvoke("Refresh", arg0_173.selectedIds, arg0_173.shipVOsById)
end

function var0_0.closeDestroyPanel(arg0_174)
	if arg0_174.destroyPage:isShowing() then
		arg0_174.destroyPage:Hide()
	end
end

function var0_0.checkDestroyShips(arg0_175, arg1_175, arg2_175)
	local var0_175 = {}

	if PlayerPrefs.GetInt("RetireProtect", 1) == 0 then
		local var1_175 = {}

		for iter0_175, iter1_175 in pairs(arg1_175) do
			local var2_175 = 0

			for iter2_175, iter3_175 in pairs(arg1_175) do
				if iter3_175:getGroupId() == iter1_175:getGroupId() then
					var2_175 = var2_175 + 1
				end
			end

			if #getProxy(BayProxy):findShipsByGroup(iter1_175:getGroupId()) == var2_175 then
				local var3_175 = false

				for iter4_175, iter5_175 in pairs(var1_175) do
					if iter5_175:getGroupId() == iter1_175:getGroupId() then
						var3_175 = true

						break
					end
				end

				if not var3_175 then
					table.insert(var1_175, iter1_175)
				end
			end
		end

		if #var1_175 > 0 then
			table.insert(var0_175, function(arg0_176)
				arg0_175.destroyConfirmWindow:ExecuteAction("ShowOneShipProtect", var1_175, arg0_176)
			end)
		end
	end

	local var4_175, var5_175 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1_175)

	if #var4_175 > 0 or #var5_175 > 0 then
		table.insert(var0_175, function(arg0_177)
			local var0_177 = false

			if arg0_175.contextData.mode == var0_0.MODE_DESTROY then
				var0_177 = ({
					ShipCalcHelper.CalcDestoryRes(arg1_175)
				})[4]
			end

			arg0_175.destroyConfirmWindow:ExecuteAction("Show", var4_175, var5_175, var0_177, arg0_177)
		end)
	end

	local var6_175 = underscore.filter(arg1_175, function(arg0_178)
		return arg0_178:getFlag("inElite")
	end)

	if #var6_175 > 0 then
		table.insert(var0_175, function(arg0_179)
			arg0_175.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var6_175, arg0_179)
		end)
	end

	seriesAsync(var0_175, arg2_175)
end

return var0_0
