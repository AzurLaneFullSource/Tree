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
	arg0_2.blurPanel = arg0_2._tf:Find("blur_panel")
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
	arg0_2.preferenceAndAttrContainer = arg0_2.switchPanel:Find("toggles")
	arg0_2.preferenceBtn = arg0_2.switchPanel:Find("toggles/preference_toggle")
	arg0_2.attrBtn = arg0_2.switchPanel:Find("toggles/attr_toggle")
	arg0_2.modLockFilter = arg0_2.topPanel:Find("mod_flter_lock")
	arg0_2.modLeveFilter = arg0_2.topPanel:Find("mod_flter_level")
	arg0_2.energyDescTF = arg0_2._tf:Find("energy_desc")
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

		local var2_2 = arg0_2.tipPanel:Find("EquipUP")
		local var3_2 = arg0_2.tipPanel:Find("ShipUP")

		setText(var2_2, i18n("fightfail_choiceequip"))
		setText(var3_2, i18n("fightfail_choicestrengthen"))
		setActive(var2_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_EQUIP_UP)
		setActive(var3_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_SHIP_UP)
	end

	arg0_2.togglePhantom = arg0_2._tf:Find("blur_panel/adapt/left_length/frame/toggle_phantom")

	onToggle(arg0_2, arg0_2.togglePhantom, function(arg0_17)
		if arg0_2.inPhantom ~= arg0_17 then
			arg0_2.inPhantom = arg0_17

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

	eachChild(arg0_2.topPanel:Find("titles"), function(arg0_19, arg1_19)
		setActive(arg0_19, arg0_19.name == var4_2)
	end)

	arg0_2.listEmptyTF = arg0_2._tf:Find("empty")

	setActive(arg0_2.listEmptyTF, false)

	arg0_2.listEmptyTxt = arg0_2.listEmptyTF:Find("Text")

	setText(arg0_2.listEmptyTxt, i18n("list_empty_tip_dockyardui"))

	arg0_2.destroyPage = ShipDestroyPage.New(arg0_2._tf, arg0_2.event)

	arg0_2.destroyPage:SetCardClickCallBack(function(arg0_20)
		arg0_2.blacklist[arg0_20.shipVO:getGroupId()] = true

		local var0_20 = table.indexof(arg0_2.selectedIds, arg0_20.shipVO.id)

		if var0_20 and var0_20 > 0 then
			table.remove(arg0_2.selectedIds, var0_20)
		end

		arg0_2:updateDestroyRes()
		arg0_2:updateSelected()
	end)
	arg0_2.destroyPage:SetConfirmCallBack(function()
		local var0_21 = {}
		local var1_21, var2_21 = arg0_2:checkDestroyGold()

		if not var2_21 then
			table.insert(var0_21, function(arg0_22)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
					onYes = arg0_22
				})
			end)
		end

		local var3_21 = underscore.map(arg0_2.selectedIds, function(arg0_23)
			return arg0_2.shipVOsById[arg0_23]
		end)

		table.insert(var0_21, function(arg0_24)
			arg0_2:checkDestroyShips(var3_21, arg0_24)
		end)
		seriesAsync(var0_21, function()
			arg0_2:emit(DockyardMediator.ON_DESTROY_SHIPS, arg0_2.selectedIds)
		end)
	end)

	arg0_2.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2.searchBar = RecordableSearchBar.New(RecordableSearchBar.CreateData({
		holder = i18n("dockyard_search_holder"),
		onActive = function(arg0_26)
			setActive(arg0_2.preferenceAndAttrContainer, not arg0_26)
		end,
		onInputChanged = function()
			arg0_2:filter()
		end,
		key = arg0_2.__cname,
		parent = arg0_2.blurPanel:Find("adapt"),
		anchoredPosition = Vector3(getAnchoredPosition(arg0_2.switchPanel).x, arg0_2.topPanel.sizeDelta.y * -0.5, 0)
	}))
end

function var0_0.SwitchContainerDisplay(arg0_28)
	arg0_28.isPhantomMode = arg0_28.contextData.mode == var0_0.MODE_SHIP_PHANTOM or arg0_28.inPhantom

	setActive(arg0_28.switchPanel, not arg0_28.isRemouldOrUpgradeMode and not arg0_28.isPhantomMode)
	setActive(arg0_28.indexBtn, not arg0_28.isRemouldOrUpgradeMode and not arg0_28.isPhantomMode)
	setActive(arg0_28.sortBtn, not arg0_28.isRemouldOrUpgradeMode and not arg0_28.isPhantomMode)
	setActive(arg0_28._tf:Find("main/ship_container"), not arg0_28.isPhantomMode)
	setActive(arg0_28._tf:Find("main/phantom_container"), arg0_28.isPhantomMode)
	setActive(arg0_28.preferenceBtn, not arg0_28.isPhantomMode)
	arg0_28:updateBarInfo()
	setActive(arg0_28.helpPhantom, arg0_28.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

	if pg.SeriesGuideMgr.GetInstance():isEnd() and PlayerPrefs.GetInt("PHANTOM_HELP_FIRST", 0) == 0 then
		PlayerPrefs.SetInt("PHANTOM_HELP_FIRST", 1)
		triggerButton(arg0_28.helpPhantom)
	end

	switch(tobool(arg0_28.isPhantomMode), {
		[true] = function()
			arg0_28.initDic = arg0_28.initDic or {}

			if arg0_28.initDic.phantom then
				return
			end

			arg0_28.initDic.phantom = true

			local var0_29 = getProxy(TechnologyProxy)
			local var1_29 = arg0_28._tf:Find("main/phantom_container/title/content")
			local var2_29 = var0_29:getConfigMaxVersion()

			UIItemList.StaticAlign(var1_29, var1_29:GetChild(0), var2_29 + 1, function(arg0_30, arg1_30, arg2_30)
				if arg0_30 == UIItemList.EventUpdate then
					arg2_30.name = "phase_" .. arg1_30

					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_30, arg2_30:Find("on"))
					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_30, arg2_30:Find("off"))
					onToggle(arg0_28, arg2_30, function(arg0_31)
						if arg0_31 then
							arg0_28.selectVersion = arg1_30
							arg0_28.filterBluePrint = underscore.filter(arg0_28.shipBluePrints, function(arg0_32)
								return arg1_30 == 0 or arg0_32:getConfig("blueprint_version") == arg1_30
							end)

							arg0_28.phantomContainer:SetTotalCount(#arg0_28.filterBluePrint, 0)
						end
					end, SFX_PANEL)
				end
			end)
			setActive(arg0_28._tf:Find("main/phantom_container/view/tpl"), false)

			arg0_28.phantomContainer = arg0_28._tf:Find("main/phantom_container/view/groups"):GetComponent("LScrollRect")
			arg0_28.phantomContainer.enabled = true
			arg0_28.phantomContainer.decelerationRate = 0.07

			function arg0_28.phantomContainer.onInitItem(arg0_33)
				arg0_28:getOrInitPhantom(arg0_33)
				ClearTweenItemAlphaAndWhite(arg0_33)
			end

			function arg0_28.phantomContainer.onUpdateItem(arg0_34, arg1_34)
				arg0_28:updatePhantomGroup(arg0_28.filterBluePrint[arg0_34 + 1], arg1_34)
				TweenItemAlphaAndWhite(arg1_34)
			end

			function arg0_28.phantomContainer.onReturnItem(arg0_35, arg1_35)
				if arg0_28.exited then
					return
				end

				arg0_28:getOrInitPhantom(arg1_35):clear()
				ClearTweenItemAlphaAndWhite(arg1_35)
			end

			arg0_28.scrollPhantoms = {}
			arg0_28.phantomGroupDic = {}

			local var3_29 = 0

			if arg0_28.contextData.techVersion and #underscore.filter(arg0_28.shipBluePrints, function(arg0_36)
				return arg0_28.contextData.techVersion == 0 or arg0_36:getConfig("blueprint_version") == arg0_28.contextData.techVersion
			end) > 0 then
				var3_29 = arg0_28.contextData.techVersion
			end

			arg0_28.contextData.techVersion = nil

			triggerToggle(arg0_28._tf:Find("main/phantom_container/title/content"):GetChild(var3_29), true)
		end,
		[false] = function()
			arg0_28.initDic = arg0_28.initDic or {}

			if arg0_28.initDic.ship then
				return
			end

			arg0_28.initDic.ship = true
			arg0_28.shipContainer = arg0_28._tf:Find("main/ship_container/ships"):GetComponent("LScrollRect")
			arg0_28.shipContainer.enabled = true
			arg0_28.shipContainer.decelerationRate = 0.07

			function arg0_28.shipContainer.onInitItem(arg0_38)
				arg0_28:onInitItem(arg0_38)
			end

			function arg0_28.shipContainer.onUpdateItem(arg0_39, arg1_39)
				arg0_28:onUpdateItem(arg0_39, arg1_39)
			end

			function arg0_28.shipContainer.onReturnItem(arg0_40, arg1_40)
				arg0_28:onReturnItem(arg0_40, arg1_40)
			end

			function arg0_28.shipContainer.onStart()
				arg0_28:updateSelected()
			end

			arg0_28.shipLayout = arg0_28._tf:Find("main/ship_container/ships")
			arg0_28.scrollItems = {}
			arg0_28.cardItemDic = {}

			local var0_37 = _G[arg0_28.contextData.preView]

			if var0_37 then
				arg0_28.sortIndex = var0_37.sortIndex or ShipIndexConst.SortLevel
				arg0_28.selectAsc = var0_37.selectAsc or false
				arg0_28.typeIndex = var0_37.typeIndex or ShipIndexConst.TypeAll
				arg0_28.campIndex = var0_37.campIndex or ShipIndexConst.CampAll
				arg0_28.rarityIndex = var0_37.rarityIndex or ShipIndexConst.RarityAll
				arg0_28.extraIndex = var0_37.extraIndex or ShipIndexConst.ExtraAll
				arg0_28.commonTag = var0_37.commonTag or Ship.PREFERENCE_TAG_NONE
			elseif arg0_28.contextData.sortData then
				local var1_37 = arg0_28.contextData.sortData

				arg0_28.sortIndex = var1_37.sort or ShipIndexConst.SortLevel
				arg0_28.selectAsc = var1_37.Asc or false
				arg0_28.typeIndex = var1_37.typeIndex or ShipIndexConst.TypeAll
				arg0_28.campIndex = var1_37.campIndex or ShipIndexConst.CampAll
				arg0_28.rarityIndex = var1_37.rarityIndex or ShipIndexConst.RarityAll
				arg0_28.extraIndex = var1_37.extraIndex or ShipIndexConst.ExtraAll
				arg0_28.commonTag = var1_37.commonTag or Ship.PREFERENCE_TAG_NONE
			else
				arg0_28.selectAsc = DockyardScene.selectAsc or false
				arg0_28.sortIndex = DockyardScene.sortIndex or ShipIndexConst.SortLevel
				arg0_28.typeIndex = DockyardScene.typeIndex or ShipIndexConst.TypeAll
				arg0_28.campIndex = DockyardScene.campIndex or ShipIndexConst.CampAll
				arg0_28.rarityIndex = DockyardScene.rarityIndex or ShipIndexConst.RarityAll
				arg0_28.extraIndex = DockyardScene.extraIndex or ShipIndexConst.ExtraAll
				arg0_28.commonTag = DockyardScene.commonTag or Ship.PREFERENCE_TAG_NONE
			end

			arg0_28:updateIndexDatas()
			triggerToggle(arg0_28.preferenceBtn, arg0_28.commonTag == Ship.PREFERENCE_TAG_COMMON)
			arg0_28:initIndexPanel()

			arg0_28.itemDetailType = -1

			if arg0_28.contextData.mode == var0_0.MODE_DESTROY then
				arg0_28.blacklist = {}
				arg0_28.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 50

				setActive(arg0_28.selectPanel:Find("quick_select"), true)
				setActive(arg0_28.settingBtn, true)
			else
				arg0_28.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 250

				setActive(arg0_28.selectPanel:Find("quick_select"), false)
				setActive(arg0_28.settingBtn, false)
			end

			if arg0_28.contextData.mode == var0_0.MODE_GUILD_BOSS then
				arg0_28.isShowAssultShips = false

				triggerToggle(arg0_28.assultBtn, true)

				arg0_28.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_28._tf, arg0_28.event)

				arg0_28.guildShipEquipmentsPage:SetCallBack(function()
					arg0_28:TriggerCard(-1)
				end, function()
					arg0_28:TriggerCard(1)
				end)
			end

			eachChild(arg0_28.attrBtn, function(arg0_44)
				setActive(arg0_44, false)
			end)

			arg0_28.isFormTactics = arg0_28.contextData.prevPage == "NewNavalTacticsMediator"

			local var2_37 = arg0_28.attrBtn:Find("off"):GetComponent("Image")
			local var3_37 = arg0_28.attrBtn:Find("on"):GetComponent("Image")

			if arg0_28.isFormTactics then
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var2_37)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var3_37)
			else
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var2_37)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var3_37)
			end

			triggerButton(arg0_28.attrBtn)

			if arg0_28.isRemouldOrUpgradeMode then
				local var4_37 = getProxy(SettingsProxy)

				arg0_28.isFilterLevelForMod = var4_37:GetDockYardLevelBtnFlag()

				arg0_28:OnSwitch(arg0_28.modLeveFilter, arg0_28.isFilterLevelForMod, function(arg0_45)
					arg0_28.isFilterLevelForMod = arg0_45

					arg0_28:filter()
				end)

				arg0_28.isFilterLockForMod = var4_37:GetDockYardLockBtnFlag()

				arg0_28:OnSwitch(arg0_28.modLockFilter, arg0_28.isFilterLockForMod, function(arg0_46)
					arg0_28.isFilterLockForMod = arg0_46

					arg0_28:filter()
				end)
			end

			arg0_28.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7

			arg0_28:filter()
		end
	})

	if arg0_28.isPhantomMode then
		setActive(arg0_28.listEmptyTF, #arg0_28.filterBluePrint == 0)
	else
		setActive(arg0_28.listEmptyTF, #arg0_28.shipVOs <= 0)
	end
end

function var0_0.isDefaultStatus(arg0_47)
	return arg0_47.sortIndex == ShipIndexConst.SortLevel and (not arg0_47.typeIndex or arg0_47.typeIndex == ShipIndexConst.TypeAll) and (not arg0_47.campIndex or arg0_47.campIndex == ShipIndexConst.CampAll) and (not arg0_47.rarityIndex or arg0_47.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_47.extraIndex or arg0_47.extraIndex == ShipIndexConst.ExtraAll)
end

function var0_0.setShipsCount(arg0_48, arg1_48, arg2_48)
	arg0_48.shipsCount = arg1_48
	arg0_48.specialShipCount = arg2_48
end

function var0_0.GetCard(arg0_49, arg1_49)
	return DockyardShipItem.New(arg1_49, arg0_49.contextData.hideTagFlags, arg0_49.contextData.blockTagFlags)
end

function var0_0.OnClickCard(arg0_50, arg1_50)
	if arg1_50.shipVO then
		if not arg0_50.selecteEnabled then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

			DockyardScene.value = arg0_50.shipContainer.value

			arg0_50.onClick(arg1_50.shipVO, arg0_50.shipVOs)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(table.contains(arg0_50.selectedIds, arg1_50.shipVO.id) and SFX_UI_CANCEL or SFX_UI_FORMATION_SELECT)
			arg0_50:selectShip(arg1_50.shipVO)
		end
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

		if arg0_50.callbackQuit then
			arg0_50.onSelected({}, function()
				arg0_50:back()
			end)
		elseif not arg1_50.isLoading then
			arg0_50.onSelected({})
			arg0_50:back()
		end
	end
end

function var0_0.OnClickPhantom(arg0_52, arg1_52)
	if arg1_52.phantomId == 0 then
		return
	else
		arg0_52:emit(DockyardMediator.CHANGE_SKIN, arg1_52)
	end
end

function var0_0.onInitItem(arg0_53, arg1_53)
	if arg0_53.scrollItems[arg1_53] then
		return arg0_53.scrollItems[arg1_53]
	end

	local var0_53 = arg0_53:GetCard(arg1_53)

	var0_53:updateDetail(arg0_53.itemDetailType)

	var0_53.isLoading = true

	onButton(arg0_53, var0_53.go, function()
		arg0_53:OnClickCard(var0_53)
	end)

	local var1_53 = GetOrAddComponent(var0_53.go, "UILongPressTrigger").onLongPressed

	if arg0_53.contextData.preView == NewBackYardShipInfoLayer.__cname then
		var1_53:RemoveAllListeners()
		var1_53:AddListener(function()
			if var0_53.shipVO then
				arg0_53.contextData.selectedIds = arg0_53.selectedIds

				arg0_53.onClick(var0_53.shipVO, underscore.select(arg0_53.shipVOs, function(arg0_56)
					return arg0_56
				end), arg0_53.contextData)
			end
		end)
	else
		var1_53:RemoveAllListeners()
	end

	arg0_53.scrollItems[arg1_53] = var0_53

	return var0_53
end

function var0_0.getOrInitPhantom(arg0_57, arg1_57)
	arg0_57.scrollPhantoms[arg1_57] = arg0_57.scrollPhantoms[arg1_57] or {
		isClear = true,
		go = arg1_57,
		tf = tf(arg1_57),
		updateSelected = function(arg0_58, arg1_58)
			arg0_58.shipCard:updateSelected(arg1_58[0])
			eachChild(arg0_58.tf:Find("phantoms"), function(arg0_59, arg1_59)
				arg1_59 = arg1_59 + 1

				local var0_59 = arg0_58.phantoms[arg1_59 + 1]

				setActive(arg0_59:Find("selected"), var0_59 and arg1_58[var0_59.phantomId])
			end)
		end,
		clear = function(arg0_60)
			if arg0_60.isClear then
				return
			end

			arg0_60.shipCard:clear()

			arg0_60.isClear = true
		end
	}

	return arg0_57.scrollPhantoms[arg1_57]
end

function var0_0.updatePhantomGroup(arg0_61, arg1_61, arg2_61)
	local var0_61 = arg0_61:getOrInitPhantom(arg2_61)

	var0_61.isClear = false
	arg0_61.phantomGroupDic[arg1_61.shipId] = arg2_61
	var0_61.shipCard = var0_61.shipCard or arg0_61:GetCard(var0_61.tf:Find("card"):GetChild(0).gameObject)

	local var1_61 = arg0_61.shipVOsById[arg1_61.shipId]:getAllShipPhantom()

	assert(var1_61[1].phantomId == 0)

	var0_61.phantoms = var1_61

	var0_61.shipCard:update(var1_61[1])
	var0_61.shipCard:updateSelected(underscore.any(arg0_61.selectedIds, function(arg0_62)
		return arg0_62 == var1_61[1].id
	end))
	arg0_61:updateItemBlackBlock(var0_61.shipCard)

	var0_61.shipCard.isLoading = false

	var0_61.shipCard:updateIntimacyEnergy(false)
	var0_61.shipCard:updateIntimacy(false)
	onButton(arg0_61, var0_61.shipCard.tr, function()
		arg0_61:OnClickPhantom(var1_61[1])
	end, SFX_UI_CLICK)

	local var2_61 = getGameset("technology_shadow_num")[1]
	local var3_61 = var0_61.tf:Find("phantoms")

	UIItemList.StaticAlign(var3_61, var3_61:GetChild(0), var2_61, function(arg0_64, arg1_64, arg2_64)
		arg1_64 = arg1_64 + 1

		if arg0_64 == UIItemList.EventUpdate then
			local var0_64 = var1_61[arg1_64 + 1]

			setActive(arg2_64:Find("skin"), tobool(var0_64))
			setActive(arg2_64:Find("lock"), not var0_64)

			if var0_64 then
				GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var0_64:getPainting(), "", arg2_64:Find("skin/Image"))

				local var1_64 = var0_64:getSkinId()

				changeToScrollText(arg2_64:Find("skin/name/Text"), pg.ship_skin_template[var1_64].name)
				setActive(arg2_64:Find("skin/status"), false)

				local var2_64 = var0_64:GetShipPhantomMark()

				setActive(arg2_64:Find("selected"), underscore.any(arg0_61.selectedMarks or {}, function(arg0_65)
					return var2_64 == arg0_65
				end))
				setActive(arg2_64:Find("skin/mark/base"), arg0_61.contextData.mode ~= var0_0.MODE_SHIP_PHANTOM)
				setActive(arg2_64:Find("skin/mark/toggle"), arg0_61.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

				local var3_64 = var0_64:getRandomFlag()

				onToggle(arg0_61, arg2_64:Find("skin/mark/toggle"), function(arg0_66)
					if arg0_66 ~= var3_64 then
						var3_64 = arg0_66

						arg0_61:emit(DockyardMediator.CHANGE_RANDOM_FLAG, var0_64:GetShipPhantomMark(), var3_64)
					end
				end, SFX_UI_CLICK)
				triggerToggle(arg2_64:Find("skin/mark/toggle"), var3_64)
			else
				setActive(arg2_64:Find("selected"), false)
			end

			onButton(arg0_61, arg2_64, function()
				if var0_64 then
					arg0_61:OnClickPhantom(var0_64)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shadow_unlock_tip"))
				end
			end, SFX_UI_CLICK)
		end
	end)
end

function var0_0.showEnergyDesc(arg0_68, arg1_68, arg2_68)
	if LeanTween.isTweening(go(arg0_68.energyDescTF)) then
		LeanTween.cancel(go(arg0_68.energyDescTF))

		arg0_68.energyDescTF.localScale = Vector3.one
	end

	setText(arg0_68.energyDescTextTF, i18n(arg2_68))

	arg0_68.energyDescTF.position = arg1_68

	setActive(arg0_68.energyDescTF, true)
	LeanTween.scale(arg0_68.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0_68.energyDescTF.localScale = Vector3.one

		setActive(arg0_68.energyDescTF, false)
	end))
end

function var0_0.onUpdateItem(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70.shipVOs[arg1_70 + 1]
	local var1_70 = var0_70 and var0_70.id or 0

	arg0_70.cardItemDic[var1_70] = arg2_70

	local var2_70 = arg0_70:onInitItem(arg2_70)

	var2_70:update(var0_70)

	if arg0_70.contextData.mode == DockyardScene.MODE_WORLD then
		var2_70:updateWorld()
	end

	var2_70:updateSelected(var2_70.shipVO and underscore.any(arg0_70.selectedIds, function(arg0_71)
		return var2_70.shipVO.id == arg0_71
	end))
	arg0_70:updateItemBlackBlock(var2_70)

	var2_70.isLoading = false

	var2_70:updateIntimacyEnergy(arg0_70.contextData.energyDisplay or arg0_70.sortIndex == ShipIndexConst.SortEnergy)

	local var3_70 = (arg0_70.sortIndex == ShipIndexConst.SortIntimacy or arg0_70.extraIndex == ShipIndexConst.ExtraMarry) and arg0_70.contextData.mode ~= DockyardScene.MODE_UPGRADE

	var2_70:updateIntimacy(var3_70)
end

function var0_0.onReturnItem(arg0_72, arg1_72, arg2_72)
	if arg0_72.exited then
		return
	end

	local var0_72 = arg0_72.scrollItems[arg2_72]

	if var0_72 then
		var0_72:clear()
	end
end

function var0_0.updateIndexDatas(arg0_73)
	arg0_73.contextData.indexDatas = arg0_73.contextData.indexDatas or {}
	arg0_73.contextData.indexDatas.sortIndex = arg0_73.sortIndex
	arg0_73.contextData.indexDatas.typeIndex = arg0_73.typeIndex
	arg0_73.contextData.indexDatas.campIndex = arg0_73.campIndex
	arg0_73.contextData.indexDatas.rarityIndex = arg0_73.rarityIndex
	arg0_73.contextData.indexDatas.extraIndex = arg0_73.extraIndex
end

function var0_0.initIndexPanel(arg0_74)
	onButton(arg0_74, arg0_74.indexBtn, function()
		local var0_75 = {
			indexDatas = Clone(arg0_74.contextData.indexDatas),
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
			callback = function(arg0_76)
				arg0_74.sortIndex = arg0_76.sortIndex
				arg0_74.typeIndex = arg0_76.typeIndex
				arg0_74.campIndex = arg0_76.campIndex
				arg0_74.rarityIndex = arg0_76.rarityIndex
				arg0_74.extraIndex = arg0_76.extraIndex

				arg0_74:updateIndexDatas()
				arg0_74:filter()
			end
		}

		arg0_74:emit(DockyardMediator.OPEN_DOCKYARD_INDEX, var0_75)
	end, SFX_PANEL)
	onToggle(arg0_74, arg0_74.preferenceBtn, function(arg0_77)
		if arg0_77 then
			arg0_74.commonTag = Ship.PREFERENCE_TAG_COMMON
		else
			arg0_74.commonTag = Ship.PREFERENCE_TAG_NONE
		end

		arg0_74:filter()
	end)
end

function var0_0.setShips(arg0_78, arg1_78)
	arg0_78.shipVOsById = arg1_78

	local var0_78 = getProxy(TechnologyProxy)

	arg0_78.shipBluePrints = {}

	for iter0_78, iter1_78 in ipairs(var0_78:getAllBluePrintShipIds()) do
		local var1_78 = getProxy(BayProxy):getShipById(iter1_78)

		if #var1_78:getAllShipPhantomMarks() > 1 then
			table.insert(arg0_78.shipBluePrints, var0_78:getBluePrintById(var1_78.groupId))
		end
	end

	table.sort(arg0_78.shipBluePrints, CompareFuncs({
		function(arg0_79)
			return arg0_79:getConfig("blueprint_version")
		end,
		function(arg0_80)
			return arg0_80.id
		end
	}))
end

function var0_0.setPlayer(arg0_81, arg1_81)
	arg0_81.player = arg1_81

	arg0_81:updateBarInfo()
end

function var0_0.updateBarInfo(arg0_82)
	setActive(arg0_82.bottomTipsText, arg0_82.contextData.leftTopInfo)
	setText(arg0_82.bottomTipsText, arg0_82.contextData.leftTopInfo and i18n("dock_yard_left_tips", arg0_82.contextData.leftTopInfo) or "")
	setActive(arg0_82.bottomTipsWithFrame, arg0_82.contextData.leftTopWithFrameInfo)
	setText(arg0_82.bottomTipsWithFrame:Find("Text"), arg0_82.contextData.leftTopWithFrameInfo or "")

	if arg0_82.contextData.mode == var0_0.MODE_WORLD or arg0_82.contextData.mode == var0_0.MODE_GUILD_BOSS or arg0_82.contextData.mode == var0_0.MODE_REMOULD or arg0_82.isPhantomMode then
		setActive(arg0_82.leftTipsText, false)
	else
		setActive(arg0_82.leftTipsText, true)
		arg0_82:updateCapacityDisplay()
	end
end

function var0_0.updateCapacityDisplay(arg0_83)
	setActive(arg0_83.leftTipsText:Find("plus"), not arg0_83.isCapacityMeta)
	setActive(arg0_83.leftTipsText:Find("tip"), arg0_83.isCapacityMeta)
	setActive(arg0_83.leftTipsText:Find("switch/off"), not arg0_83.isCapacityMeta)
	setActive(arg0_83.leftTipsText:Find("switch/on"), arg0_83.isCapacityMeta)

	if arg0_83.isCapacityMeta then
		setText(arg0_83.leftTipsText:Find("label"), i18n("specialshipyard_name"))
		setText(arg0_83.leftTipsText:Find("Text"), arg0_83.specialShipCount)
	else
		setText(arg0_83.leftTipsText:Find("label"), i18n("ship_dockyardScene_capacity"))
		setText(arg0_83.leftTipsText:Find("Text"), arg0_83.shipsCount .. "/" .. arg0_83.player:getMaxShipBag())
	end
end

function var0_0.initWorldPanel(arg0_84)
	onButton(arg0_84, arg0_84.worldPanel:Find("btn_repair"), function()
		if #arg0_84.selectedIds > 0 then
			arg0_84:repairWorldShip(arg0_84.shipVOsById[arg0_84.selectedIds[1]])
		end
	end, SFX_PANEL)
	onButton(arg0_84, arg0_84.worldPanel:Find("btn_repair_all"), function()
		local var0_86 = {}
		local var1_86 = 0

		for iter0_86, iter1_86 in pairs(arg0_84.shipVOsById) do
			local var2_86 = WorldConst.FetchWorldShip(iter1_86.id)

			if var2_86:IsBroken() or not var2_86:IsHpFull() then
				table.insert(var0_86, var2_86.id)

				var1_86 = var1_86 + nowWorld():CalcRepairCost(var2_86)
			end
		end

		if #var0_86 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_ship_repair_all", var1_86),
				onYes = function()
					arg0_84:emit(DockyardMediator.ON_SHIP_REPAIR, var0_86, var1_86)
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.repairWorldShip(arg0_88, arg1_88)
	local var0_88 = WorldConst.FetchWorldShip(arg1_88.id)
	local var1_88 = nowWorld():CalcRepairCost(var0_88)

	if var0_88:IsBroken() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_2", arg1_88:getName(), var1_88),
			onYes = function()
				arg0_88:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_88.id
				}, var1_88)
			end
		})
	elseif not var0_88:IsHpFull() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_1", arg1_88:getName(), var1_88),
			onYes = function()
				arg0_88:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_88.id
				}, var1_88)
			end
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
	end
end

function var0_0.filter(arg0_91)
	local var0_91 = arg0_91:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	LoadImageSpriteAtlasAsync("ui/dockyardui_atlas", var0_91, arg0_91.indexBtn, true)

	if arg0_91.isRemouldOrUpgradeMode then
		arg0_91:filterForRemouldAndUpgrade()
	else
		arg0_91:filterCommon()
	end

	local var1_91 = 0

	if arg0_91.contextData.quitTeam then
		var1_91 = var1_91 + 1

		table.insert(arg0_91.shipVOs, var1_91, false)
	end

	if arg0_91.contextData.priorEquipUpShipIDList then
		local var2_91 = {}

		for iter0_91, iter1_91 in ipairs(arg0_91.contextData.priorEquipUpShipIDList) do
			var2_91[iter1_91] = true
		end

		for iter2_91 = #arg0_91.shipVOs, 1, -1 do
			local var3_91 = type(arg0_91.shipVOs[iter2_91]) == "table" and arg0_91.shipVOs[iter2_91].id

			if var2_91[var3_91] then
				var2_91[var3_91] = table.remove(arg0_91.shipVOs, iter2_91)
			end
		end

		for iter3_91, iter4_91 in ipairs(arg0_91.contextData.priorEquipUpShipIDList) do
			local var4_91 = var2_91[iter4_91]

			if type(var4_91) == "table" then
				var1_91 = var1_91 + 1

				table.insert(arg0_91.shipVOs, var1_91, var4_91)
			end
		end
	end

	if var0_0.MODE_OVERVIEW == arg0_91.contextData.mode and DockyardScene.value then
		arg0_91:updateShipCount(DockyardScene.value or 0)

		DockyardScene.value = nil
	else
		arg0_91:updateShipCount(0)
	end
end

function var0_0.filterForRemouldAndUpgrade(arg0_92)
	arg0_92.shipVOs = {}

	local var0_92 = arg0_92.isFilterLockForMod
	local var1_92 = arg0_92.isFilterLevelForMod

	local function var2_92(arg0_93)
		local var0_93 = true

		if not var0_92 and arg0_93.lockState == Ship.LOCK_STATE_LOCK then
			var0_93 = false
		end

		if not var1_92 and arg0_93.level > 1 then
			var0_93 = false
		end

		return var0_93
	end

	for iter0_92, iter1_92 in pairs(arg0_92.shipVOsById) do
		if var2_92(iter1_92) then
			table.insert(arg0_92.shipVOs, iter1_92)
		end
	end

	table.sort(arg0_92.shipVOs, CompareFuncs({
		function(arg0_94)
			return arg0_94.level
		end,
		function(arg0_95)
			return arg0_95:isTestShip() and 1 or 0
		end
	}))
end

function var0_0.filterCommon(arg0_96)
	arg0_96.shipVOs = {}

	local var0_96 = arg0_96.sortIndex

	local function var1_96(arg0_97)
		if arg0_96.contextData.mode ~= var0_0.MODE_GUILD_BOSS then
			return true
		end

		if arg0_96.isShowAssultShips then
			return true
		end

		if not arg0_97.user then
			return true
		end

		if arg0_97.user.id == arg0_96.player.id then
			return true
		end

		return false
	end

	for iter0_96, iter1_96 in pairs(arg0_96.shipVOsById) do
		if arg0_96.contextData.blockLock and iter1_96:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0_96.teamTypeFilter and iter1_96:getTeamType() ~= arg0_96.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1_96, arg0_96.typeIndex) and ShipIndexConst.filterByCamp(iter1_96, arg0_96.campIndex) and ShipIndexConst.filterByRarity(iter1_96, arg0_96.rarityIndex) and ShipIndexConst.filterByExtra(iter1_96, arg0_96.extraIndex) and (arg0_96.commonTag == Ship.PREFERENCE_TAG_NONE or arg0_96.commonTag == iter1_96:GetPreferenceTag()) and var1_96(iter1_96) then
			table.insert(arg0_96.shipVOs, iter1_96)
		end
	end

	local var2_96 = arg0_96.searchBar:GetInputText()

	if var2_96 and var2_96 ~= "" then
		arg0_96.shipVOs = underscore.filter(arg0_96.shipVOs, function(arg0_98)
			return arg0_98:IsMatchKey(var2_96)
		end)
	end

	local var3_96, var4_96 = ShipIndexConst.getSortFuncAndName(var0_96, arg0_96.selectAsc)

	if (var0_96 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0_96.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3_96, 1, function(arg0_99)
			return arg0_99:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3_96 then
		arg0_96:SortShips(var3_96)
	end

	arg0_96:updateSelected()
	setActive(arg0_96.sortImgAsc, arg0_96.selectAsc)
	setActive(arg0_96.sortImgDesc, not arg0_96.selectAsc)
	setText(arg0_96.sortBtn:Find("Image"), i18n(var4_96))
end

function var0_0.SortShips(arg0_100, arg1_100)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0_100 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1_100 = {
			function(arg0_101)
				return table.contains(var0_100, arg0_101.configId) and 0 or 1
			end
		}
	elseif arg0_100.isFormTactics then
		table.insert(arg1_100, 1, function(arg0_102)
			return arg0_102:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1_100, 1, function(arg0_103)
			return arg0_103:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0_100.contextData.mode == var0_0.MODE_OVERVIEW or arg0_100.contextData.mode == var0_0.MODE_SELECT then
		table.insert(arg1_100, 1, function(arg0_104)
			return -arg0_104.activityNpc
		end)
	elseif arg0_100.contextData.mode == var0_0.MODE_GUILD_BOSS then
		table.insert(arg1_100, 1, function(arg0_105)
			return arg0_105.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0_100.shipVOs, CompareFuncs(arg1_100))
end

function var0_0.UpdateGuildViewEquipmentsBtn(arg0_106)
	setActive(arg0_106.viewEquipmentBtn, arg0_106.contextData.mode == var0_0.MODE_GUILD_BOSS and #arg0_106.selectedIds > 0)
end

function var0_0.GetSelectCount(arg0_107)
	return #arg0_107.selectedIds
end

function var0_0.GetConfirmSelect(arg0_108)
	return arg0_108.selectedIds
end

function var0_0.didEnter(arg0_109)
	if arg0_109:isLayer() then
		arg0_109:OverlayPanel(arg0_109._tf, {
			groupDelta = -1
		})
	end

	arg0_109:OverlayPanel(arg0_109.blurPanel)
	arg0_109:PlayUIAnimation(arg0_109.blurPanel, "enter")
	setActive(arg0_109.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0_109.contextData.mode ~= var0_0.MODE_GUILD_BOSS)
	arg0_109:UpdateGuildViewEquipmentsBtn()
	onButton(arg0_109, arg0_109.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0_109, arg0_109.topPanel:Find("back"), function()
		arg0_109:back()
	end, SFX_CANCEL)
	onButton(arg0_109, arg0_109.sortBtn, function()
		arg0_109.selectAsc = not arg0_109.selectAsc

		arg0_109:filter()
	end, SFX_UI_CLICK)
	onToggle(arg0_109, arg0_109.assultBtn, function(arg0_113)
		arg0_109.isShowAssultShips = arg0_113

		arg0_109:filter()
	end, SFX_PANEL)
	onButton(arg0_109, arg0_109.viewEquipmentBtn, function()
		local var0_114 = arg0_109.selectedIds[#arg0_109.selectedIds]

		if not var0_114 then
			return
		end

		local var1_114 = arg0_109.shipVOsById[var0_114]
		local var2_114 = var1_114.user

		arg0_109.guildShipEquipmentsPage:ExecuteAction("Show", var1_114, var2_114)
	end, SFX_PANEL)
	onButton(arg0_109, arg0_109.attrBtn, function()
		if not arg0_109.isFormTactics then
			arg0_109.itemDetailType = (arg0_109.itemDetailType + 1) % 4
		else
			arg0_109.itemDetailType = arg0_109.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(arg0_109.attrBtn:Find("off"), arg0_109.itemDetailType == DockyardShipItem.DetailType0)
		setActive(arg0_109.attrBtn:Find("on"), arg0_109.itemDetailType ~= DockyardShipItem.DetailType0)

		arg0_109.attrBtn:GetComponent("Button").targetGraphic = arg0_109.itemDetailType == DockyardShipItem.DetailType0 and imageOff or imageOn

		arg0_109:updateItemDetailType()
	end, SFX_PANEL)
	onButton(arg0_109, arg0_109.selectPanel:Find("cancel_button"), function()
		if arg0_109.animating then
			return
		end

		if arg0_109.contextData.mode == var0_0.MODE_DESTROY then
			if #arg0_109.selectedIds > 0 then
				arg0_109:unselecteAllShips()
				arg0_109:back()
			else
				arg0_109:back()
			end
		else
			arg0_109:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0_109, arg0_109.selectPanel:Find("confirm_button"), function()
		if arg0_109.animating then
			return
		end

		if arg0_109.contextData.mode == var0_0.MODE_DESTROY then
			local var0_117, var1_117 = arg0_109:checkDestroyGold()

			if not var0_117 or not var1_117 then
				if not var0_117 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0_117 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if arg0_109:GetSelectCount() < arg0_109.selectedMin then
			if arg0_109.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0_109.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0_109.selectedMin))
			end

			return
		end

		if arg0_109.contextData.mode == var0_0.MODE_DESTROY then
			arg0_109:displayDestroyPanel()
		else
			local var2_117 = {}

			if arg0_109.contextData.destroyCheck then
				local var3_117 = underscore.map(arg0_109.selectedIds, function(arg0_118)
					return arg0_109.shipVOsById[arg0_118]
				end)

				table.insert(var2_117, function(arg0_119)
					arg0_109:checkDestroyShips(var3_117, arg0_119)
				end)
			end

			local var4_117 = arg0_109:GetConfirmSelect()

			if arg0_109.confirmSelect then
				table.insert(var2_117, function(arg0_120)
					arg0_109.confirmSelect(var4_117, function()
						arg0_120(true)
					end, arg0_120)
				end)
				seriesAsync(var2_117, function(arg0_122)
					if arg0_122 then
						arg0_109.onSelected(var4_117)
					end

					arg0_109:back()
				end)
			else
				table.insert(var2_117, function(arg0_123)
					if arg0_109.callbackQuit then
						arg0_109.onSelected(var4_117, arg0_123)
					else
						arg0_109.onSelected(var4_117)
						arg0_123()
					end
				end)
				seriesAsync(var2_117, function()
					arg0_109:back()
				end)
			end
		end
	end, SFX_CONFIRM)
	onButton(arg0_109, arg0_109.selectPanel:Find("quick_select"), function()
		if arg0_109.animating then
			return
		end

		local var0_125 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1_125 = 3
		local var2_125 = {}

		for iter0_125, iter1_125 in pairs(var0_125) do
			if iter1_125 ~= 0 then
				var2_125[iter1_125] = var2_125[iter1_125] or var1_125
				var1_125 = var1_125 - 1
			end
		end

		local var3_125 = getProxy(BayProxy):getShips()
		local var4_125 = {}
		local var5_125 = {}

		for iter2_125, iter3_125 in pairs(var3_125) do
			if iter3_125:isMaxStar() then
				var4_125[iter3_125:getGroupId()] = true
			else
				local var6_125 = iter3_125:getMaxStar() - iter3_125:getStar() + 1

				if iter3_125:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6_125 = var6_125 + 1
				end

				local var7_125 = var5_125[iter3_125:getGroupId()]

				var5_125[iter3_125:getGroupId()] = var7_125 and var7_125 < var6_125 and var7_125 or var6_125
			end
		end

		local var8_125 = _.select(arg0_109.shipVOs, function(arg0_126)
			return arg0_126.configId ~= 100001 and arg0_126.configId ~= 100011 and arg0_126:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0_125, arg0_126:getRarity()) and arg0_126.level == 1 and not arg0_109.blacklist[arg0_126:getGroupId()] and not table.contains(arg0_109.selectedIds, arg0_126.id) and not arg0_126:hasAnyFlag({
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

		if not _.all(var8_125, function(arg0_127)
			return arg0_109.blacklist[arg0_127:getGroupId()]
		end) then
			var8_125 = _.select(var8_125, function(arg0_128)
				return not arg0_109.blacklist[arg0_128:getGroupId()]
			end)
		elseif #arg0_109.selectedIds > 0 then
			var8_125 = {}
		end

		table.sort(var8_125, function(arg0_129, arg1_129)
			local var0_129 = var2_125[arg0_129:getRarity()] or 0
			local var1_129 = var2_125[arg1_129:getRarity()] or 0

			if var0_129 == var1_129 then
				if arg0_129:getGroupId() == arg1_129:getGroupId() then
					return arg0_129.createTime > arg1_129.createTime
				end

				return arg0_129.configId > arg1_129.configId
			else
				return var1_129 < var0_129
			end
		end)

		local var9_125 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10_125 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11_125 = {}
		local var12_125 = _.select(var8_125, function(arg0_130)
			if var4_125[arg0_130:getGroupId()] then
				if var9_125 == "KeepNone" then
					return true
				elseif var9_125 == "KeepOne" then
					if not var11_125[arg0_130:getGroupId()] then
						var11_125[arg0_130:getGroupId()] = true

						return false
					end

					return true
				elseif var9_125 == "KeepAll" then
					return false
				end
			elseif var10_125 == "KeepNone" then
				return true
			elseif var10_125 == "KeepNeeded" then
				if var5_125[arg0_130:getGroupId()] > 0 then
					var5_125[arg0_130:getGroupId()] = var5_125[arg0_130:getGroupId()] - 1

					return false
				end

				return true
			elseif var10_125 == "KeepAll" then
				return false
			end
		end)
		local var13_125 = 0
		local var14_125 = false
		local var15_125 = false
		local var16_125 = 0
		local var17_125 = 0

		for iter4_125, iter5_125 in ipairs(arg0_109.selectedIds) do
			local var18_125, var19_125 = arg0_109.shipVOsById[iter5_125]:calReturnRes()

			var16_125 = var16_125 + var18_125
			var17_125 = var17_125 + var19_125
		end

		for iter6_125, iter7_125 in ipairs(var12_125) do
			if arg0_109.selectedMax > 0 and arg0_109.selectedMax <= arg0_109:GetSelectCount() then
				break
			end

			local var20_125, var21_125 = iter7_125:calReturnRes()

			var16_125 = var16_125 + var20_125
			var17_125 = var17_125 + var21_125
			var14_125 = arg0_109.player:OilMax(var17_125)
			var15_125 = arg0_109.player:GoldMax(var16_125)

			if var15_125 then
				break
			end

			var13_125 = var13_125 + 1

			arg0_109:selectShip(iter7_125)
		end

		if var13_125 == 0 then
			if var15_125 then
				if #arg0_109.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0_109.selectedIds > 0 then
				arg0_109:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14_125 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0_109:displayDestroyPanel()
				end
			})
		else
			arg0_109:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if isActive(arg0_109.togglePhantom) then
		triggerToggle(arg0_109.togglePhantom, tobool(arg0_109.inPhantom))
	else
		arg0_109:SwitchContainerDisplay()
	end

	arg0_109:updateBarInfo()

	if arg0_109.contextData.mode == var0_0.MODE_WORLD then
		arg0_109:initWorldPanel()
	elseif arg0_109.contextData.mode == var0_0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_109)
	end

	setAnchoredPosition(arg0_109.topPanel, {
		y = arg0_109.topPanel.rect.height
	})
	setAnchoredPosition(arg0_109.selectPanel, {
		y = -1 * arg0_109.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0_109.exited then
			return
		end

		arg0_109:uiStartAnimating()
	end)

	arg0_109.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_109)

	onButton(arg0_109, arg0_109.settingBtn, function()
		arg0_109.settingPanel:Load()
		arg0_109.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0_109)
end

function var0_0.TriggerCard(arg0_134, arg1_134)
	local var0_134 = arg0_134.selectedIds[1]

	if not var0_134 then
		return
	end

	local var1_134

	for iter0_134, iter1_134 in ipairs(arg0_134.shipVOs) do
		if iter1_134 and iter1_134.id == var0_134 then
			var1_134 = iter0_134

			break
		end
	end

	if not var1_134 then
		return
	end

	local var2_134 = var1_134
	local var3_134

	local function var4_134()
		var2_134 = var2_134 + arg1_134

		local var0_135 = arg0_134.shipVOs[var2_134]

		if not var0_135 or arg0_134.checkShip(var0_135) then
			return var0_135
		else
			return var4_134()
		end
	end

	local var5_134 = var4_134()

	if not var5_134 then
		return
	end

	local function var6_134()
		local var0_136

		for iter0_136, iter1_136 in pairs(arg0_134.scrollItems) do
			if iter1_136.shipVO and iter1_136.go.name ~= "-1" and iter1_136.shipVO.id == var5_134.id then
				var0_136 = iter1_136

				break
			end
		end

		return var0_136
	end

	local var7_134 = arg0_134.cardItemDic[var0_134]
	local var8_134 = var7_134 and arg0_134.scrollItems[var7_134]
	local var9_134 = var8_134 and var8_134.shipVO.id == var5_134.id and var8_134 or nil

	if var9_134 then
		local var10_134 = getBounds(arg0_134._tf:Find("main/ship_container"))
		local var11_134 = getBounds(var9_134.tr)

		if not var10_134:Intersects(var11_134) then
			local var12_134 = arg1_134 * (arg0_134.shipContainer:HeadIndexToValue(7) - arg0_134.shipContainer:HeadIndexToValue(1))
			local var13_134 = arg0_134.shipContainer.value + var12_134

			arg0_134.shipContainer:SetNormalizedPosition(var13_134, 1)
		end
	end

	if not var9_134 then
		local var14_134 = (math.ceil(var2_134 / 7) - math.ceil(var1_134 / 7)) * (arg0_134.shipContainer:HeadIndexToValue(21) - arg0_134.shipContainer:HeadIndexToValue(1))
		local var15_134 = arg0_134.shipContainer.value + var14_134

		arg0_134.shipContainer:SetNormalizedPosition(var15_134, 1)

		var9_134 = var6_134()
	end

	if var9_134 then
		triggerButton(var9_134.tr)

		local var16_134 = arg0_134.shipVOsById[var9_134.shipVO.id]

		arg0_134.guildShipEquipmentsPage:Refresh(var16_134, var16_134.user)
	end
end

function var0_0.OnSwitch(arg0_137, arg1_137, arg2_137, arg3_137)
	local function var0_137()
		setActive(arg1_137:Find("off"), not arg2_137)
		setActive(arg1_137:Find("on"), arg2_137)
	end

	onButton(arg0_137, arg1_137, function()
		arg2_137 = not arg2_137

		if arg3_137 then
			arg3_137(arg2_137)
		end

		var0_137()
	end, SFX_PANEL)
	var0_137()
end

function var0_0.OnShipSkinChanged(arg0_140, arg1_140)
	local var0_140, var1_140 = ShipPhantom.UnpackMark(arg1_140)
	local var2_140 = arg0_140.phantomGroupDic[var0_140]
	local var3_140 = var2_140 and arg0_140.scrollPhantoms[var2_140]

	if var3_140 and var3_140.shipCard.shipVO.id == var0_140 then
		arg0_140:updatePhantomGroup(underscore.detect(arg0_140.filterBluePrint, function(arg0_141)
			return arg0_141.shipId == var0_140
		end), var2_140)
	end
end

function var0_0.onBackPressed(arg0_142)
	if arg0_142.destroyConfirmWindow:isShowing() then
		arg0_142.destroyConfirmWindow:Hide()

		return
	end

	if arg0_142.destroyPage:isShowing() then
		arg0_142.destroyPage:Hide()

		return
	end

	if arg0_142.settingPanel:isShowing() then
		arg0_142.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_142:back()
end

function var0_0.updateShipStatusById(arg0_143, arg1_143)
	local var0_143 = arg0_143.cardItemDic[arg1_143]
	local var1_143 = var0_143 and arg0_143.scrollItems[var0_143]

	if var1_143 and var1_143.shipVO.id == arg1_143 then
		var1_143:flush(arg0_143.selectedIds)

		if arg0_143.contextData.mode == DockyardScene.MODE_WORLD then
			var1_143:updateWorld()
		end
	end
end

function var0_0.checkDestroyGold(arg0_144, arg1_144)
	local var0_144 = 0
	local var1_144 = 0

	for iter0_144, iter1_144 in ipairs(arg0_144.selectedIds) do
		local var2_144, var3_144 = arg0_144.shipVOsById[iter1_144]:calReturnRes()

		var0_144 = var0_144 + var2_144
		var1_144 = var1_144 + var3_144
	end

	if arg1_144 then
		local var4_144, var5_144 = arg1_144:calReturnRes()

		var0_144 = var0_144 + var4_144
		var1_144 = var1_144 + var5_144
	end

	local var6_144 = arg0_144.player:OilMax(var1_144)

	if arg0_144.player:GoldMax(var0_144) then
		return false, not var6_144
	end

	return true, not var6_144
end

function var0_0.selectShip(arg0_145, arg1_145)
	local var0_145 = false
	local var1_145

	for iter0_145, iter1_145 in ipairs(arg0_145.selectedIds) do
		if iter1_145 == arg1_145.id then
			var0_145 = true
			var1_145 = iter0_145

			break
		end
	end

	if var0_145 or arg0_145.selectedMax == 1 and arg0_145:GetSelectCount() > 0 then
		local var2_145 = defaultValue(var1_145, 1)
		local var3_145 = arg0_145.shipVOsById[arg0_145.selectedIds[var2_145]]
		local var4_145, var5_145 = arg0_145.onCancelShip(var3_145, function()
			if not arg0_145.exited then
				return
			end

			arg0_145:selectShip(arg1_145)
		end, arg0_145.selectedIds)

		if not var4_145 then
			if var5_145 then
				pg.TipsMgr.GetInstance():ShowTips(var5_145)
			end

			return
		end

		table.remove(arg0_145.selectedIds, var2_145)

		if arg0_145.selectedMax ~= 1 then
			arg0_145:updateBlackBlocks(var3_145)
		end
	end

	if not var0_145 then
		local var6_145, var7_145 = arg0_145.checkShip(arg1_145, function()
			if arg0_145.exited then
				return
			end

			arg0_145:selectShip(arg1_145)
		end, arg0_145.selectedIds)

		if not var6_145 then
			if var7_145 then
				pg.TipsMgr.GetInstance():ShowTips(var7_145)
			end

			return
		end

		if arg0_145.selectedMax == 0 or arg0_145:GetSelectCount() < arg0_145.selectedMax then
			table.insert(arg0_145.selectedIds, arg1_145.id)

			if arg0_145.selectedMax ~= 1 then
				arg0_145:updateBlackBlocks(removeShip)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_145.selectedMax))

			return
		end
	end

	arg0_145:updateSelected()

	if arg0_145.contextData.mode == var0_0.MODE_DESTROY then
		arg0_145:updateDestroyRes()
	elseif arg0_145.contextData.mode == var0_0.MODE_MOD then
		arg0_145:updateModAttr()
	end

	arg0_145:UpdateGuildViewEquipmentsBtn()
end

function var0_0.updateBlackBlocks(arg0_148, arg1_148)
	if not arg0_148.contextData.useBlackBlock or not arg1_148 then
		return
	end

	for iter0_148, iter1_148 in pairs(arg0_148.scrollItems) do
		arg0_148:updateItemBlackBlock(iter1_148)
	end
end

function var0_0.updateItemBlackBlock(arg0_149, arg1_149)
	if arg0_149.contextData.useBlackBlock then
		if arg0_149.selectedMax == 1 then
			arg1_149:updateBlackBlock(arg0_149.contextData.otherSelectedIds)
		else
			arg1_149:updateBlackBlock(arg0_149.selectedIds)
		end
	else
		arg1_149:updateBlackBlock()
	end
end

function var0_0.unselecteAllShips(arg0_150)
	arg0_150.selectedIds = {}

	arg0_150:updateSelected()
	arg0_150:updateDestroyRes()
end

function var0_0.updateSelected(arg0_151)
	if arg0_151.shipContainer then
		for iter0_151, iter1_151 in pairs(arg0_151.scrollItems) do
			if not iter1_151.isClear then
				local var0_151 = iter1_151.shipVO and iter1_151.shipVO.id or nil

				iter1_151:updateSelected(iter1_151.shipVO and underscore.any(arg0_151.selectedIds, function(arg0_152)
					return var0_151 == arg0_152
				end))
			end
		end
	end

	if arg0_151.phantomContainer then
		for iter2_151, iter3_151 in pairs(arg0_151.scrollPhantoms) do
			if not iter3_151.isClear then
				local var1_151 = iter3_151.shipCard.shipVO.id
				local var2_151 = {}
				local var3_151 = getGameset("technology_shadow_num")[1]

				for iter4_151 = 0, var3_151 do
					if iter4_151 == 0 then
						var2_151[iter4_151] = underscore.any(arg0_151.selectedIds, function(arg0_153)
							return var1_151 == arg0_153
						end)
					else
						var2_151[iter4_151] = underscore.any(arg0_151.selectedMarks, function(arg0_154)
							return arg0_154 == ShipPhantom.PackMark(var1_151, iter4_151)
						end)
					end
				end

				iter3_151:updateSelected(var2_151)
			end
		end
	end

	if arg0_151.selectedMax == 0 then
		setText(arg0_151.selectPanel:Find("bottom_info/bg_input/count"), arg0_151:GetSelectCount())
	else
		local var4_151 = arg0_151:GetSelectCount()

		if arg0_151.contextData.mode ~= var0_0.MODE_DESTROY or arg0_151:GetSelectCount() == 0 then
			var4_151 = setColorStr(var4_151, COLOR_WHITE)
		elseif arg0_151.contextData.mode == var0_0.MODE_DESTROY then
			var4_151 = setColorStr(var4_151, #arg0_151.selectedIds == 10 and COLOR_RED or COLOR_GREEN)
		end

		setText(arg0_151.selectPanel:Find("bottom_info/bg_input/count"), var4_151 .. "/" .. arg0_151.selectedMax)
	end

	if arg0_151:GetSelectCount() < arg0_151.selectedMin then
		setActive(arg0_151.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0_151.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0_151.contextData.mode == var0_0.MODE_MOD then
		arg0_151:updateModAttr()
	end
end

function var0_0.updateItemDetailType(arg0_155)
	for iter0_155, iter1_155 in pairs(arg0_155.scrollItems) do
		iter1_155:updateDetail(arg0_155.itemDetailType)
	end

	arg0_155.shipLayout.anchoredPosition = arg0_155.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0_0.closeDestroyMode(arg0_156)
	setActive(arg0_156.awardTF, false)
	setActive(arg0_156.bottomTipsText, true)
end

function var0_0.updateDestroyRes(arg0_157)
	if table.getCount(arg0_157.selectedIds) == 0 then
		arg0_157:closeDestroyMode()
	else
		setActive(arg0_157.awardTF, true)
		setActive(arg0_157.bottomTipsText, false)
	end

	local var0_157 = _.map(arg0_157.selectedIds, function(arg0_158)
		return arg0_157.shipVOsById[arg0_158]
	end)
	local var1_157, var2_157, var3_157 = ShipCalcHelper.CalcDestoryRes(var0_157)
	local var4_157 = var2_157 == 0

	if arg0_157.destroyResList then
		local var5_157 = (var4_157 and 1 or 2) + #var3_157

		arg0_157.destroyResList:make(function(arg0_159, arg1_159, arg2_159)
			if arg0_159 == UIItemList.EventUpdate then
				local var0_159 = ""
				local var1_159 = 0

				if arg1_159 == 0 then
					var0_159, var1_159 = "Props/gold", var1_157
				elseif arg1_159 == 1 then
					if not var4_157 then
						var0_159, var1_159 = "Props/oil", var2_157
					else
						local var2_159 = var3_157[1]

						var0_159, var1_159 = Item.getConfigData(var2_159.id).icon, var2_159.count
					end
				elseif arg1_159 > 1 then
					local var3_159 = var4_157 and var3_157[arg1_159] or var3_157[arg1_159 - 1]

					var0_159, var1_159 = Item.getConfigData(var3_159.id).icon, var3_159.count
				end

				GetImageSpriteFromAtlasAsync(var0_159, "", arg2_159:Find("icon"))
				setText(arg2_159:Find("Text"), "X" .. var1_159)
			end
		end)
		arg0_157.destroyResList:align(var5_157)
	end

	if arg0_157.destroyPage and arg0_157.destroyPage:GetLoaded() and arg0_157.destroyPage:isShowing() then
		arg0_157.destroyPage:RefreshRes()
	end
end

function var0_0.setModShip(arg0_160, arg1_160)
	arg0_160.modShip = arg1_160
end

function var0_0.updateModAttr(arg0_161)
	if table.getCount(arg0_161.selectedIds) == 0 then
		arg0_161:closeModAttr()
	else
		setActive(arg0_161.modAttrsTF, true)
		setActive(arg0_161.bottomTipsText, false)
	end

	local var0_161 = arg0_161.contextData.ignoredIds[1]
	local var1_161 = {}

	for iter0_161, iter1_161 in ipairs(arg0_161.selectedIds) do
		table.insert(var1_161, arg0_161.shipVOsById[iter1_161])
	end

	local var2_161 = ShipModLayer.getModExpAdditions(arg0_161.modShip, var1_161)

	for iter2_161, iter3_161 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2_161 ~= ShipModLayer.IGNORE_ID then
			local var3_161 = arg0_161.modAttrContainer:Find("attr_" .. iter2_161)

			setText(var3_161:Find("value"), var2_161[iter3_161])
			setText(var3_161:Find("name"), ShipModAttr.id2Name(iter2_161))
		end
	end
end

function var0_0.closeModAttr(arg0_162)
	setActive(arg0_162.modAttrsTF, false)
	setActive(arg0_162.bottomTipsText, true)
end

function var0_0.removeShip(arg0_163, arg1_163)
	for iter0_163, iter1_163 in ipairs(arg0_163.selectedIds) do
		if iter1_163 == arg1_163 then
			table.remove(arg0_163.selectedIds, iter0_163)

			break
		end
	end

	for iter2_163 = #arg0_163.shipVOs, 1, -1 do
		if arg0_163.shipVOs[iter2_163].id == arg1_163 then
			table.remove(arg0_163.shipVOs, iter2_163)

			break
		end
	end

	arg0_163.shipVOsById[arg1_163] = nil
end

function var0_0.updateShipCount(arg0_164, arg1_164)
	arg0_164.shipContainer:SetTotalCount(#arg0_164.shipVOs, defaultValue(arg1_164, -1))
	setActive(arg0_164.listEmptyTF, #arg0_164.shipVOs <= 0)
end

function var0_0.ClearShipsBlackBlock(arg0_165)
	if not arg0_165.shipVOsById then
		return
	end

	for iter0_165, iter1_165 in pairs(arg0_165.shipVOsById) do
		iter1_165.blackBlock = false
	end
end

function var0_0.willExit(arg0_166)
	arg0_166:closeDestroyMode()
	arg0_166:closeModAttr()
	arg0_166:ClearShipsBlackBlock()

	if arg0_166.guildShipEquipmentsPage then
		arg0_166.guildShipEquipmentsPage:Destroy()
	end

	if arg0_166.settingPanel then
		arg0_166.settingPanel:Destroy()
	end

	if arg0_166.destroyPage then
		arg0_166.destroyPage:Destroy()
	end

	if arg0_166.destroyConfirmWindow then
		arg0_166.destroyConfirmWindow:Destroy()
	end

	if arg0_166.contextData.mode == var0_0.MODE_MOD then
		-- block empty
	elseif not arg0_166.contextData.sortData then
		if _G[arg0_166.contextData.preView] then
			_G[arg0_166.contextData.preView].sortIndex = arg0_166.sortIndex
			_G[arg0_166.contextData.preView].selectAsc = arg0_166.selectAsc
			_G[arg0_166.contextData.preView].typeIndex = arg0_166.typeIndex
			_G[arg0_166.contextData.preView].campIndex = arg0_166.campIndex
			_G[arg0_166.contextData.preView].rarityIndex = arg0_166.rarityIndex
			_G[arg0_166.contextData.preView].extraIndex = arg0_166.extraIndex
			_G[arg0_166.contextData.preView].commonTag = arg0_166.commonTag
		else
			DockyardScene.sortIndex = arg0_166.sortIndex
			DockyardScene.selectAsc = arg0_166.selectAsc
			DockyardScene.typeIndex = arg0_166.typeIndex
			DockyardScene.campIndex = arg0_166.campIndex
			DockyardScene.rarityIndex = arg0_166.rarityIndex
			DockyardScene.extraIndex = arg0_166.extraIndex
			DockyardScene.commonTag = arg0_166.commonTag
		end
	end

	if arg0_166.shipContainer then
		arg0_166.shipContainer.enabled = false

		for iter0_166, iter1_166 in pairs(arg0_166.scrollItems) do
			iter1_166:clear()
			GetOrAddComponent(iter1_166.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
		end
	end

	if arg0_166.phantomContainer then
		arg0_166.phantomContainer.enabled = false

		for iter2_166, iter3_166 in pairs(arg0_166.scrollPhantoms) do
			iter3_166:clear()
		end
	end

	if LeanTween.isTweening(go(arg0_166.energyDescTF)) then
		setActive(arg0_166.energyDescTF, false)
		LeanTween.cancel(go(arg0_166.energyDescTF))
	end

	arg0_166:cancelAnimating()

	if arg0_166.isRemouldOrUpgradeMode then
		local var0_166 = getProxy(SettingsProxy)

		var0_166:SetDockYardLockBtnFlag(arg0_166.isFilterLockForMod)
		var0_166:SetDockYardLevelBtnFlag(arg0_166.isFilterLevelForMod)
	end

	if arg0_166.bulinTip then
		arg0_166.bulinTip:Destroy()

		arg0_166.bulinTip = nil
	end

	if arg0_166.searchBar then
		arg0_166.searchBar:Dispose()

		arg0_166.searchBar = nil
	end

	arg0_166:UnOverlayPanel(arg0_166.blurPanel, arg0_166._tf)

	if arg0_166:isLayer() then
		arg0_166:UnOverlayPanel(arg0_166._tf)
	end
end

function var0_0.uiStartAnimating(arg0_167)
	local var0_167 = arg0_167.topPanel:Find("back")
	local var1_167 = 0
	local var2_167 = 0.3

	if isActive(arg0_167.selectPanel) then
		shiftPanel(arg0_167.selectPanel, nil, 0, var2_167, var1_167, true, true)
	end
end

function var0_0.uiExitAnimating(arg0_168)
	if arg0_168.contextData.mode == var0_0.MODE_OVERVIEW then
		-- block empty
	else
		local var0_168 = 0
		local var1_168 = 0.3

		shiftPanel(arg0_168.selectPanel, nil, -1 * arg0_168.selectPanel.rect.height, var1_168, var0_168, true, true)
	end
end

function var0_0.back(arg0_169)
	if arg0_169.exited then
		return
	end

	arg0_169:closeView()
end

function var0_0.cancelAnimating(arg0_170)
	if LeanTween.isTweening(go(arg0_170.topPanel)) then
		LeanTween.cancel(go(arg0_170.topPanel))
	end

	if LeanTween.isTweening(go(arg0_170.selectPanel)) then
		LeanTween.cancel(go(arg0_170.selectPanel))
	end

	if arg0_170.tweens then
		cancelTweens(arg0_170.tweens)
	end
end

function var0_0.quickExitFunc(arg0_171)
	seriesAsync({
		function(arg0_172)
			if arg0_171.contextData.onQuickHome then
				arg0_171.contextData.onQuickHome(arg0_172)
			else
				arg0_172()
			end
		end,
		function(arg0_173)
			arg0_171:emit(var0_0.ON_HOME)
		end
	})
end

function var0_0.displayDestroyPanel(arg0_174)
	arg0_174.destroyPage:ExecuteAction("Show")
	arg0_174.destroyPage:ActionInvoke("Refresh", arg0_174.selectedIds, arg0_174.shipVOsById)
end

function var0_0.closeDestroyPanel(arg0_175)
	if arg0_175.destroyPage:isShowing() then
		arg0_175.destroyPage:Hide()
	end
end

function var0_0.checkDestroyShips(arg0_176, arg1_176, arg2_176)
	local var0_176 = {}

	if PlayerPrefs.GetInt("RetireProtect", 1) == 0 then
		local var1_176 = {}

		for iter0_176, iter1_176 in pairs(arg1_176) do
			local var2_176 = 0

			for iter2_176, iter3_176 in pairs(arg1_176) do
				if iter3_176:getGroupId() == iter1_176:getGroupId() then
					var2_176 = var2_176 + 1
				end
			end

			if #getProxy(BayProxy):findShipsByGroup(iter1_176:getGroupId()) == var2_176 then
				local var3_176 = false

				for iter4_176, iter5_176 in pairs(var1_176) do
					if iter5_176:getGroupId() == iter1_176:getGroupId() then
						var3_176 = true

						break
					end
				end

				if not var3_176 then
					table.insert(var1_176, iter1_176)
				end
			end
		end

		if #var1_176 > 0 then
			table.insert(var0_176, function(arg0_177)
				arg0_176.destroyConfirmWindow:ExecuteAction("ShowOneShipProtect", var1_176, arg0_177)
			end)
		end
	end

	local var4_176, var5_176 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1_176)

	if #var4_176 > 0 or #var5_176 > 0 then
		table.insert(var0_176, function(arg0_178)
			local var0_178 = false

			if arg0_176.contextData.mode == var0_0.MODE_DESTROY then
				var0_178 = ({
					ShipCalcHelper.CalcDestoryRes(arg1_176)
				})[4]
			end

			arg0_176.destroyConfirmWindow:ExecuteAction("Show", var4_176, var5_176, var0_178, arg0_178)
		end)
	end

	local var6_176 = underscore.filter(arg1_176, function(arg0_179)
		return arg0_179:getFlag("inElite")
	end)

	if #var6_176 > 0 then
		table.insert(var0_176, function(arg0_180)
			arg0_176.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var6_176, arg0_180)
		end)
	end

	seriesAsync(var0_176, arg2_176)
end

return var0_0
