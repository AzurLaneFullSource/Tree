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

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/dockyardui_atlas",
		"energy",
		"shipstatus",
		"shipframe",
		"shiptype",
		"ui/proposeshipcard",
		"ui/heartshipcard",
		"shipYardIcon/unknown",
		"ui/iconcolorful",
		"ui/recordablesearchbarui"
	}

	table.insertto(var0_2, arg0_2:getDockyardShipResList(arg1_2))

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getDockyardShipResList(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = {}

	if arg1_3 and arg1_3.shipVOs then
		for iter0_3, iter1_3 in ipairs(arg1_3.shipVOs) do
			var1_3[iter1_3.id] = iter1_3
		end
	elseif arg1_3 and arg1_3.mode == var0_0.MODE_WORLD then
		for iter2_3, iter3_3 in ipairs(nowWorld():GetShipVOs()) do
			var1_3[iter3_3.id] = iter3_3
		end
	else
		local var2_3 = getProxy(BayProxy)

		for iter4_3, iter5_3 in pairs(var2_3.data) do
			var1_3[iter4_3] = iter5_3
		end
	end

	if arg1_3 and arg1_3.ignoredIds then
		for iter6_3, iter7_3 in ipairs(arg1_3.ignoredIds) do
			var1_3[iter7_3] = nil
		end
	end

	for iter8_3, iter9_3 in pairs(var1_3) do
		arg0_3:insertDockyardShipItemRes(var0_3, iter9_3)
	end

	if arg1_3 and arg1_3.mode == var0_0.MODE_SHIP_PHANTOM then
		local var3_3 = getProxy(TechnologyProxy)
		local var4_3 = getProxy(BayProxy)

		for iter10_3, iter11_3 in ipairs(var3_3:getAllBluePrintShipIds()) do
			local var5_3 = var4_3:getShipById(iter11_3)

			if var5_3 and #var5_3:getAllShipPhantomMarks() > 1 then
				_.each(var5_3:getAllShipPhantom(), function(arg0_4)
					local var0_4 = ResPathSupport.GetPaintingShipYardIconListByPaintingName(arg0_4:getPainting())

					table.insertto(var0_3, var0_4)
				end)
			end
		end
	end

	return var0_3
end

function var0_0.insertDockyardShipItemRes(arg0_5, arg1_5, arg2_5)
	local var0_5 = string.format(ResPathSupport.ConstPath.BG.ShipCard, arg2_5:rarity2bgPrint())

	table.insert(arg1_5, var0_5)

	local var1_5 = ResPathSupport.GetPaintingShipYardIconListByPaintingName(arg2_5:getPainting())

	table.insertto(arg1_5, var1_5)

	local var2_5, var3_5 = arg2_5:GetFrameAndEffect()
	local var4_5 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.Effect, var3_5)

	table.insert(arg1_5, var4_5)

	local var5_5 = arg2_5.user

	if var5_5 then
		local var6_5 = Ship.New({
			configId = var5_5.icon
		}):getPrefab()
		local var7_5 = ResPathSupport.GetSpineQIconListByPrefabName(var6_5)

		table.insertto(arg1_5, var7_5)

		local var8_5 = AttireFrame.attireFrameRes(var5_5, false, AttireConst.TYPE_ICON_FRAME, var5_5.propose)
		local var9_5 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.UI.IconFrame, var8_5)

		table.insert(arg1_5, var9_5)
	end
end

function var0_0.init(arg0_6)
	local var0_6 = arg0_6.contextData

	var0_6.mode = defaultValue(var0_6.mode, var0_0.MODE_SELECT)
	var0_6.otherSelectedIds = defaultValue(var0_6.otherSelectedIds, {})
	arg0_6.teamTypeFilter = var0_6.teamFilter
	arg0_6.selectedMin = var0_6.selectedMin or 1
	arg0_6.leastLimitMsg = var0_6.leastLimitMsg
	arg0_6.selectedMax = var0_6.selectedMax or 0
	var0_6.selectedIds = var0_6.selectedIds or {}

	if var0_6.infoShipId then
		table.insert(var0_6.selectedIds, var0_6.infoShipId)

		var0_6.infoShipId = nil
	end

	arg0_6.selectedIds = underscore(var0_6.selectedIds):chain():select(function(arg0_7)
		return getProxy(BayProxy):RawGetShipById(arg0_7) ~= nil
	end):first(arg0_6.selectedMax):value()
	var0_6.selectedIds = nil
	arg0_6.checkShip = var0_6.onShip or function(arg0_8, arg1_8, arg2_8)
		return true
	end
	arg0_6.onCancelShip = var0_6.onCancelShip or function(arg0_9, arg1_9, arg2_9)
		return true
	end
	arg0_6.onClick = var0_6.onClick or function(arg0_10, arg1_10, arg2_10)
		arg0_6:emit(DockyardMediator.ON_SHIP_DETAIL, arg0_10, arg1_10, arg2_10)
	end
	arg0_6.confirmSelect = var0_6.confirmSelect
	arg0_6.callbackQuit = var0_6.callbackQuit
	arg0_6.onSelected = var0_6.onSelected or function(arg0_11, arg1_11)
		warning("not implemented.")
	end
	arg0_6.blurPanel = arg0_6._tf:Find("blur_panel")
	arg0_6.settingBtn = arg0_6.blurPanel:Find("adapt/left_length/frame/setting")
	arg0_6.settingPanel = DockyardQuickSelectSettingPage.New(arg0_6._tf, arg0_6.event)

	arg0_6.settingPanel:OnSettingChanged(function()
		arg0_6:unselecteAllShips()
	end)

	arg0_6.topPanel = arg0_6.blurPanel:Find("adapt/top")
	arg0_6.sortBtn = arg0_6.topPanel:Find("sort_button")
	arg0_6.sortImgAsc = arg0_6.sortBtn:Find("asc")
	arg0_6.sortImgDesc = arg0_6.sortBtn:Find("desc")
	arg0_6.leftTipsText = arg0_6.topPanel:Find("capacity")

	onButton(arg0_6, arg0_6.leftTipsText:Find("switch"), function()
		arg0_6.isCapacityMeta = not arg0_6.isCapacityMeta

		arg0_6:updateCapacityDisplay()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.leftTipsText:Find("plus"), function()
		gotoChargeScene()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.leftTipsText:Find("tip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("specialshipyard_tip")
		})
	end, SFX_PANEL)
	setActive(arg0_6.leftTipsText, false)

	arg0_6.indexBtn = arg0_6.topPanel:Find("index_button")
	arg0_6.switchPanel = arg0_6.topPanel:Find("switch")
	arg0_6.preferenceAndAttrContainer = arg0_6.switchPanel:Find("toggles")
	arg0_6.preferenceBtn = arg0_6.switchPanel:Find("toggles/preference_toggle")
	arg0_6.attrBtn = arg0_6.switchPanel:Find("toggles/attr_toggle")
	arg0_6.modLockFilter = arg0_6.topPanel:Find("mod_flter_lock")
	arg0_6.modLeveFilter = arg0_6.topPanel:Find("mod_flter_level")
	arg0_6.energyDescTF = arg0_6._tf:Find("energy_desc")
	arg0_6.energyDescTextTF = arg0_6.energyDescTF:Find("Text")
	arg0_6.selectPanel = arg0_6.blurPanel:Find("select_panel")
	arg0_6.bottomTipsText = arg0_6.selectPanel:Find("tip")
	arg0_6.bottomTipsWithFrame = arg0_6.selectPanel:Find("tipwithframe")

	setText(arg0_6.selectPanel:Find("bottom_info/bg_input/selected"), i18n("disassemble_selected") .. ":")

	arg0_6.awardTF = arg0_6.selectPanel:Find("bottom_info/bg_award")

	setText(arg0_6.awardTF:Find("label"), i18n("disassemble_available") .. ":")

	arg0_6.modAttrsTF = arg0_6.selectPanel:Find("bottom_info/bg_mod")
	arg0_6.viewEquipmentBtn = arg0_6.selectPanel:Find("view_equipments")
	arg0_6.tipPanel = arg0_6.blurPanel:Find("TipPanel")

	setActive(arg0_6.tipPanel, false)

	arg0_6.worldPanel = arg0_6.blurPanel:Find("world_port_panel")

	setActive(arg0_6.worldPanel, arg0_6.contextData.mode == var0_0.MODE_WORLD)

	arg0_6.assultBtn = arg0_6.blurPanel:Find("adapt/top/assult_btn")
	arg0_6.stampBtn = arg0_6.topPanel:Find("stamp")
	arg0_6.isRemouldOrUpgradeMode = arg0_6.contextData.mode == var0_0.MODE_REMOULD or arg0_6.contextData.mode == var0_0.MODE_UPGRADE

	setActive(arg0_6.modLeveFilter, arg0_6.isRemouldOrUpgradeMode)
	setActive(arg0_6.modLockFilter, arg0_6.isRemouldOrUpgradeMode)
	setActive(arg0_6.assultBtn, arg0_6.contextData.mode == var0_0.MODE_GUILD_BOSS)
	switch(arg0_6.contextData.mode, {
		[var0_0.MODE_OVERVIEW] = function()
			arg0_6.selecteEnabled = false
		end,
		[var0_0.MODE_DESTROY] = function()
			arg0_6.selecteEnabled = true
			arg0_6.blacklist = {}
			arg0_6.destroyResList = UIItemList.New(arg0_6.awardTF:Find("res_list"), arg0_6.awardTF:Find("res_list/res"))
		end,
		[var0_0.MODE_MOD] = function()
			arg0_6.selecteEnabled = true

			setText(arg0_6.modAttrsTF:Find("title/Text"), i18n("word_mod_value"))

			arg0_6.modAttrContainer = arg0_6.modAttrsTF:Find("attrs")
		end,
		[var0_0.MODE_SHIP_PHANTOM] = function()
			arg0_6.selecteEnabled = false
		end
	}, function()
		arg0_6.selecteEnabled = true
	end)
	setActive(arg0_6.selectPanel, arg0_6.selecteEnabled and arg0_6.contextData.mode ~= var0_0.MODE_WORLD)
	setActive(arg0_6.worldPanel, arg0_6.contextData.mode == var0_0.MODE_WORLD)

	local var1_6 = arg0_6.contextData.mode == var0_0.MODE_DESTROY

	setActive(arg0_6.settingBtn, var1_6)
	setActive(arg0_6.selectPanel:Find("quick_select"), var1_6)

	if arg0_6.contextData.priorEquipUpShipIDList and arg0_6.contextData.priorMode then
		setActive(arg0_6.tipPanel, true)

		local var2_6 = arg0_6.tipPanel:Find("EquipUP")
		local var3_6 = arg0_6.tipPanel:Find("ShipUP")

		setText(var2_6, i18n("fightfail_choiceequip"))
		setText(var3_6, i18n("fightfail_choicestrengthen"))
		setActive(var2_6, arg0_6.contextData.priorMode == var0_0.PRIOR_MODE_EQUIP_UP)
		setActive(var3_6, arg0_6.contextData.priorMode == var0_0.PRIOR_MODE_SHIP_UP)
	end

	arg0_6.togglePhantom = arg0_6._tf:Find("blur_panel/adapt/left_length/frame/toggle_phantom")

	onToggle(arg0_6, arg0_6.togglePhantom, function(arg0_21)
		if arg0_6.inPhantom ~= arg0_21 then
			arg0_6.inPhantom = arg0_21

			arg0_6:SwitchContainerDisplay()
		end
	end, SFX_PANEL)
	setActive(arg0_6.togglePhantom, false)

	arg0_6.helpPhantom = arg0_6._tf:Find("blur_panel/adapt/left_length/frame/help_phantom")

	onButton(arg0_6, arg0_6.helpPhantom, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("projection_help")
		})
	end, SFX_PANEL)

	local var4_6 = arg0_6.contextData.mode == var0_0.MODE_SHIP_PHANTOM and "phantom" or "dockyard"

	eachChild(arg0_6.topPanel:Find("titles"), function(arg0_23, arg1_23)
		setActive(arg0_23, arg0_23.name == var4_6)
	end)

	arg0_6.listEmptyTF = arg0_6._tf:Find("empty")

	setActive(arg0_6.listEmptyTF, false)

	arg0_6.listEmptyTxt = arg0_6.listEmptyTF:Find("Text")

	setText(arg0_6.listEmptyTxt, i18n("list_empty_tip_dockyardui"))

	arg0_6.destroyPage = ShipDestroyPage.New(arg0_6._tf, arg0_6.event)

	arg0_6.destroyPage:SetCardClickCallBack(function(arg0_24)
		arg0_6.blacklist[arg0_24.shipVO:getGroupId()] = true

		local var0_24 = table.indexof(arg0_6.selectedIds, arg0_24.shipVO.id)

		if var0_24 and var0_24 > 0 then
			table.remove(arg0_6.selectedIds, var0_24)
		end

		arg0_6:updateDestroyRes()
		arg0_6:updateSelected()
	end)
	arg0_6.destroyPage:SetConfirmCallBack(function()
		local var0_25 = {}
		local var1_25, var2_25 = arg0_6:checkDestroyGold()

		if not var2_25 then
			table.insert(var0_25, function(arg0_26)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
					onYes = arg0_26
				})
			end)
		end

		local var3_25 = underscore.map(arg0_6.selectedIds, function(arg0_27)
			return arg0_6.shipVOsById[arg0_27]
		end)

		table.insert(var0_25, function(arg0_28)
			arg0_6:checkDestroyShips(var3_25, arg0_28)
		end)
		seriesAsync(var0_25, function()
			arg0_6:emit(DockyardMediator.ON_DESTROY_SHIPS, arg0_6.selectedIds)
		end)
	end)

	arg0_6.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_6._tf, arg0_6.event)
	arg0_6.searchBar = RecordableSearchBar.New(RecordableSearchBar.CreateData({
		refresh_pos_when_expand = true,
		holder = i18n("dockyard_search_holder"),
		onActive = function(arg0_30)
			setActive(arg0_6.preferenceAndAttrContainer, not arg0_30)
		end,
		onInputChanged = function()
			arg0_6:filter()
		end,
		key = arg0_6.__cname,
		parent = arg0_6.switchPanel,
		expand_parent = arg0_6.blurPanel:Find("adapt"),
		anchoredPosition = Vector3(-33, -33, 0)
	}))
end

function var0_0.SwitchContainerDisplay(arg0_32)
	arg0_32.isPhantomMode = arg0_32.contextData.mode == var0_0.MODE_SHIP_PHANTOM or arg0_32.inPhantom

	setActive(arg0_32.switchPanel, not arg0_32.isRemouldOrUpgradeMode and not arg0_32.isPhantomMode)
	setActive(arg0_32.indexBtn, not arg0_32.isRemouldOrUpgradeMode and not arg0_32.isPhantomMode)
	setActive(arg0_32.sortBtn, not arg0_32.isRemouldOrUpgradeMode and not arg0_32.isPhantomMode)
	setActive(arg0_32._tf:Find("main/ship_container"), not arg0_32.isPhantomMode)
	setActive(arg0_32._tf:Find("main/phantom_container"), arg0_32.isPhantomMode)
	setActive(arg0_32.preferenceBtn, not arg0_32.isPhantomMode)
	arg0_32:updateBarInfo()
	setActive(arg0_32.helpPhantom, arg0_32.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

	if pg.SeriesGuideMgr.GetInstance():isEnd() and PlayerPrefs.GetInt("PHANTOM_HELP_FIRST", 0) == 0 then
		PlayerPrefs.SetInt("PHANTOM_HELP_FIRST", 1)
		triggerButton(arg0_32.helpPhantom)
	end

	switch(tobool(arg0_32.isPhantomMode), {
		[true] = function()
			arg0_32.initDic = arg0_32.initDic or {}

			if arg0_32.initDic.phantom then
				return
			end

			arg0_32.initDic.phantom = true

			local var0_33 = getProxy(TechnologyProxy)
			local var1_33 = arg0_32._tf:Find("main/phantom_container/title/content")
			local var2_33 = var0_33:getConfigMaxVersion()

			UIItemList.StaticAlign(var1_33, var1_33:GetChild(0), var2_33 + 1, function(arg0_34, arg1_34, arg2_34)
				if arg0_34 == UIItemList.EventUpdate then
					arg2_34.name = "phase_" .. arg1_34

					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_34, arg2_34:Find("on"))
					GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", arg1_34, arg2_34:Find("off"))
					onToggle(arg0_32, arg2_34, function(arg0_35)
						if arg0_35 then
							arg0_32.selectVersion = arg1_34
							arg0_32.filterBluePrint = underscore.filter(arg0_32.shipBluePrints, function(arg0_36)
								return arg1_34 == 0 or arg0_36:getConfig("blueprint_version") == arg1_34
							end)

							arg0_32.phantomContainer:SetTotalCount(#arg0_32.filterBluePrint, 0)
						end
					end, SFX_PANEL)
				end
			end)
			setActive(arg0_32._tf:Find("main/phantom_container/view/tpl"), false)

			arg0_32.phantomContainer = arg0_32._tf:Find("main/phantom_container/view/groups"):GetComponent("LScrollRect")
			arg0_32.phantomContainer.enabled = true
			arg0_32.phantomContainer.decelerationRate = 0.07

			function arg0_32.phantomContainer.onInitItem(arg0_37)
				arg0_32:getOrInitPhantom(arg0_37)
				ClearTweenItemAlphaAndWhite(arg0_37)
			end

			function arg0_32.phantomContainer.onUpdateItem(arg0_38, arg1_38)
				arg0_32:updatePhantomGroup(arg0_32.filterBluePrint[arg0_38 + 1], arg1_38)
				TweenItemAlphaAndWhite(arg1_38)
			end

			function arg0_32.phantomContainer.onReturnItem(arg0_39, arg1_39)
				if arg0_32.exited then
					return
				end

				arg0_32:getOrInitPhantom(arg1_39):clear()
				ClearTweenItemAlphaAndWhite(arg1_39)
			end

			arg0_32.scrollPhantoms = {}
			arg0_32.phantomGroupDic = {}

			local var3_33 = 0

			if arg0_32.contextData.techVersion and #underscore.filter(arg0_32.shipBluePrints, function(arg0_40)
				return arg0_32.contextData.techVersion == 0 or arg0_40:getConfig("blueprint_version") == arg0_32.contextData.techVersion
			end) > 0 then
				var3_33 = arg0_32.contextData.techVersion
			end

			arg0_32.contextData.techVersion = nil

			triggerToggle(arg0_32._tf:Find("main/phantom_container/title/content"):GetChild(var3_33), true)
		end,
		[false] = function()
			arg0_32.initDic = arg0_32.initDic or {}

			if arg0_32.initDic.ship then
				return
			end

			arg0_32.initDic.ship = true
			arg0_32.shipContainer = arg0_32._tf:Find("main/ship_container/ships"):GetComponent("LScrollRect")
			arg0_32.shipContainer.enabled = true
			arg0_32.shipContainer.decelerationRate = 0.07

			function arg0_32.shipContainer.onInitItem(arg0_42)
				arg0_32:onInitItem(arg0_42)
			end

			function arg0_32.shipContainer.onUpdateItem(arg0_43, arg1_43)
				arg0_32:onUpdateItem(arg0_43, arg1_43)
			end

			function arg0_32.shipContainer.onReturnItem(arg0_44, arg1_44)
				arg0_32:onReturnItem(arg0_44, arg1_44)
			end

			function arg0_32.shipContainer.onStart()
				arg0_32:updateSelected()
			end

			arg0_32.shipLayout = arg0_32._tf:Find("main/ship_container/ships")
			arg0_32.scrollItems = {}
			arg0_32.cardItemDic = {}

			local var0_41 = _G[arg0_32.contextData.preView]

			if var0_41 then
				arg0_32.sortIndex = var0_41.sortIndex or ShipIndexConst.SortLevel
				arg0_32.selectAsc = var0_41.selectAsc or false
				arg0_32.typeIndex = var0_41.typeIndex or ShipIndexConst.TypeAll
				arg0_32.campIndex = var0_41.campIndex or ShipIndexConst.CampAll
				arg0_32.rarityIndex = var0_41.rarityIndex or ShipIndexConst.RarityAll
				arg0_32.extraIndex = var0_41.extraIndex or ShipIndexConst.ExtraAll
				arg0_32.commonTag = var0_41.commonTag or Ship.PREFERENCE_TAG_NONE
			elseif arg0_32.contextData.sortData then
				local var1_41 = arg0_32.contextData.sortData

				arg0_32.sortIndex = var1_41.sort or ShipIndexConst.SortLevel
				arg0_32.selectAsc = var1_41.Asc or false
				arg0_32.typeIndex = var1_41.typeIndex or ShipIndexConst.TypeAll
				arg0_32.campIndex = var1_41.campIndex or ShipIndexConst.CampAll
				arg0_32.rarityIndex = var1_41.rarityIndex or ShipIndexConst.RarityAll
				arg0_32.extraIndex = var1_41.extraIndex or ShipIndexConst.ExtraAll
				arg0_32.commonTag = var1_41.commonTag or Ship.PREFERENCE_TAG_NONE
			else
				arg0_32.selectAsc = DockyardScene.selectAsc or false
				arg0_32.sortIndex = DockyardScene.sortIndex or ShipIndexConst.SortLevel
				arg0_32.typeIndex = DockyardScene.typeIndex or ShipIndexConst.TypeAll
				arg0_32.campIndex = DockyardScene.campIndex or ShipIndexConst.CampAll
				arg0_32.rarityIndex = DockyardScene.rarityIndex or ShipIndexConst.RarityAll
				arg0_32.extraIndex = DockyardScene.extraIndex or ShipIndexConst.ExtraAll
				arg0_32.commonTag = DockyardScene.commonTag or Ship.PREFERENCE_TAG_NONE
			end

			arg0_32:updateIndexDatas()
			triggerToggle(arg0_32.preferenceBtn, arg0_32.commonTag == Ship.PREFERENCE_TAG_COMMON)
			arg0_32:initIndexPanel()

			arg0_32.itemDetailType = -1

			if arg0_32.contextData.mode == var0_0.MODE_DESTROY then
				arg0_32.blacklist = {}
				arg0_32.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 50

				setActive(arg0_32.selectPanel:Find("quick_select"), true)
				setActive(arg0_32.settingBtn, true)
			else
				arg0_32.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 250

				setActive(arg0_32.selectPanel:Find("quick_select"), false)
				setActive(arg0_32.settingBtn, false)
			end

			if arg0_32.contextData.mode == var0_0.MODE_GUILD_BOSS then
				arg0_32.isShowAssultShips = false

				triggerToggle(arg0_32.assultBtn, true)

				arg0_32.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_32._tf, arg0_32.event)

				arg0_32.guildShipEquipmentsPage:SetCallBack(function()
					arg0_32:TriggerCard(-1)
				end, function()
					arg0_32:TriggerCard(1)
				end)
			end

			eachChild(arg0_32.attrBtn, function(arg0_48)
				setActive(arg0_48, false)
			end)

			arg0_32.isFormTactics = arg0_32.contextData.prevPage == "NewNavalTacticsMediator"

			local var2_41 = arg0_32.attrBtn:Find("off"):GetComponent("Image")
			local var3_41 = arg0_32.attrBtn:Find("on"):GetComponent("Image")

			if arg0_32.isFormTactics then
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var2_41)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var3_41)
			else
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var2_41)
				GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var3_41)
			end

			triggerButton(arg0_32.attrBtn)

			if arg0_32.isRemouldOrUpgradeMode then
				local var4_41 = getProxy(SettingsProxy)

				arg0_32.isFilterLevelForMod = var4_41:GetDockYardLevelBtnFlag()

				arg0_32:OnSwitch(arg0_32.modLeveFilter, arg0_32.isFilterLevelForMod, function(arg0_49)
					arg0_32.isFilterLevelForMod = arg0_49

					arg0_32:filter()
				end)

				arg0_32.isFilterLockForMod = var4_41:GetDockYardLockBtnFlag()

				arg0_32:OnSwitch(arg0_32.modLockFilter, arg0_32.isFilterLockForMod, function(arg0_50)
					arg0_32.isFilterLockForMod = arg0_50

					arg0_32:filter()
				end)
			end

			arg0_32.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7

			arg0_32:filter()
		end
	})

	if arg0_32.isPhantomMode then
		setActive(arg0_32.listEmptyTF, #arg0_32.filterBluePrint == 0)
	else
		setActive(arg0_32.listEmptyTF, #arg0_32.shipVOs <= 0)
	end
end

function var0_0.isDefaultStatus(arg0_51)
	return arg0_51.sortIndex == ShipIndexConst.SortLevel and (not arg0_51.typeIndex or arg0_51.typeIndex == ShipIndexConst.TypeAll) and (not arg0_51.campIndex or arg0_51.campIndex == ShipIndexConst.CampAll) and (not arg0_51.rarityIndex or arg0_51.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_51.extraIndex or arg0_51.extraIndex == ShipIndexConst.ExtraAll)
end

function var0_0.setShipsCount(arg0_52, arg1_52, arg2_52)
	arg0_52.shipsCount = arg1_52
	arg0_52.specialShipCount = arg2_52
end

function var0_0.GetCard(arg0_53, arg1_53)
	return DockyardShipItem.New(arg1_53, arg0_53.contextData.hideTagFlags, arg0_53.contextData.blockTagFlags)
end

function var0_0.OnClickCard(arg0_54, arg1_54)
	if arg1_54.shipVO then
		if not arg0_54.selecteEnabled then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

			DockyardScene.value = arg0_54.shipContainer.value

			arg0_54.onClick(arg1_54.shipVO, arg0_54.shipVOs)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(table.contains(arg0_54.selectedIds, arg1_54.shipVO.id) and SFX_UI_CANCEL or SFX_UI_FORMATION_SELECT)
			arg0_54:selectShip(arg1_54.shipVO)
		end
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

		if arg0_54.callbackQuit then
			arg0_54.onSelected({}, function()
				arg0_54:back()
			end)
		elseif not arg1_54.isLoading then
			arg0_54.onSelected({})
			arg0_54:back()
		end
	end
end

function var0_0.OnClickPhantom(arg0_56, arg1_56)
	if arg1_56.phantomId == 0 then
		return
	else
		arg0_56:emit(DockyardMediator.CHANGE_SKIN, arg1_56)
	end
end

function var0_0.onInitItem(arg0_57, arg1_57)
	if arg0_57.scrollItems[arg1_57] then
		return arg0_57.scrollItems[arg1_57]
	end

	local var0_57 = arg0_57:GetCard(arg1_57)

	var0_57:updateDetail(arg0_57.itemDetailType)

	var0_57.isLoading = true

	onButton(arg0_57, var0_57.go, function()
		arg0_57:OnClickCard(var0_57)
	end)

	local var1_57 = GetOrAddComponent(var0_57.go, "UILongPressTrigger").onLongPressed

	if arg0_57.contextData.preView == NewBackYardShipInfoLayer.__cname then
		var1_57:RemoveAllListeners()
		var1_57:AddListener(function()
			if var0_57.shipVO then
				arg0_57.contextData.selectedIds = arg0_57.selectedIds

				arg0_57.onClick(var0_57.shipVO, underscore.select(arg0_57.shipVOs, function(arg0_60)
					return arg0_60
				end), arg0_57.contextData)
			end
		end)
	else
		var1_57:RemoveAllListeners()
	end

	arg0_57.scrollItems[arg1_57] = var0_57

	return var0_57
end

function var0_0.getOrInitPhantom(arg0_61, arg1_61)
	arg0_61.scrollPhantoms[arg1_61] = arg0_61.scrollPhantoms[arg1_61] or {
		isClear = true,
		go = arg1_61,
		tf = tf(arg1_61),
		updateSelected = function(arg0_62, arg1_62)
			arg0_62.shipCard:updateSelected(arg1_62[0])
			eachChild(arg0_62.tf:Find("phantoms"), function(arg0_63, arg1_63)
				arg1_63 = arg1_63 + 1

				local var0_63 = arg0_62.phantoms[arg1_63 + 1]

				setActive(arg0_63:Find("selected"), var0_63 and arg1_62[var0_63.phantomId])
			end)
		end,
		clear = function(arg0_64)
			if arg0_64.isClear then
				return
			end

			arg0_64.shipCard:clear()

			arg0_64.isClear = true
		end
	}

	return arg0_61.scrollPhantoms[arg1_61]
end

function var0_0.updatePhantomGroup(arg0_65, arg1_65, arg2_65)
	local var0_65 = arg0_65:getOrInitPhantom(arg2_65)

	var0_65.isClear = false
	arg0_65.phantomGroupDic[arg1_65.shipId] = arg2_65
	var0_65.shipCard = var0_65.shipCard or arg0_65:GetCard(var0_65.tf:Find("card"):GetChild(0).gameObject)

	local var1_65 = arg0_65.shipVOsById[arg1_65.shipId]:getAllShipPhantom()

	assert(var1_65[1].phantomId == 0)

	var0_65.phantoms = var1_65

	var0_65.shipCard:update(var1_65[1])
	var0_65.shipCard:updateSelected(underscore.any(arg0_65.selectedIds, function(arg0_66)
		return arg0_66 == var1_65[1].id
	end))
	arg0_65:updateItemBlackBlock(var0_65.shipCard)

	var0_65.shipCard.isLoading = false

	var0_65.shipCard:updateIntimacyEnergy(false)
	var0_65.shipCard:updateIntimacy(false)
	onButton(arg0_65, var0_65.shipCard.tr, function()
		arg0_65:OnClickPhantom(var1_65[1])
	end, SFX_UI_CLICK)

	local var2_65 = getGameset("technology_shadow_num")[1]
	local var3_65 = var0_65.tf:Find("phantoms")

	UIItemList.StaticAlign(var3_65, var3_65:GetChild(0), var2_65, function(arg0_68, arg1_68, arg2_68)
		arg1_68 = arg1_68 + 1

		if arg0_68 == UIItemList.EventUpdate then
			local var0_68 = var1_65[arg1_68 + 1]

			setActive(arg2_68:Find("skin"), tobool(var0_68))
			setActive(arg2_68:Find("lock"), not var0_68)

			if var0_68 then
				GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var0_68:getPainting(), "", arg2_68:Find("skin/Image"))

				local var1_68 = var0_68:getSkinId()

				changeToScrollText(arg2_68:Find("skin/name/Text"), pg.ship_skin_template[var1_68].name)
				setActive(arg2_68:Find("skin/status"), false)

				local var2_68 = var0_68:GetShipPhantomMark()

				setActive(arg2_68:Find("selected"), underscore.any(arg0_65.selectedMarks or {}, function(arg0_69)
					return var2_68 == arg0_69
				end))
				setActive(arg2_68:Find("skin/mark/base"), arg0_65.contextData.mode ~= var0_0.MODE_SHIP_PHANTOM)
				setActive(arg2_68:Find("skin/mark/toggle"), arg0_65.contextData.mode == var0_0.MODE_SHIP_PHANTOM)

				local var3_68 = var0_68:getRandomFlag()

				onToggle(arg0_65, arg2_68:Find("skin/mark/toggle"), function(arg0_70)
					if arg0_70 ~= var3_68 then
						var3_68 = arg0_70

						arg0_65:emit(DockyardMediator.CHANGE_RANDOM_FLAG, var0_68:GetShipPhantomMark(), var3_68)
					end
				end, SFX_UI_CLICK)
				triggerToggle(arg2_68:Find("skin/mark/toggle"), var3_68)
			else
				setActive(arg2_68:Find("selected"), false)
			end

			onButton(arg0_65, arg2_68, function()
				if var0_68 then
					arg0_65:OnClickPhantom(var0_68)
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("shadow_unlock_tip"))
				end
			end, SFX_UI_CLICK)
		end
	end)
end

function var0_0.showEnergyDesc(arg0_72, arg1_72, arg2_72)
	if LeanTween.isTweening(go(arg0_72.energyDescTF)) then
		LeanTween.cancel(go(arg0_72.energyDescTF))

		arg0_72.energyDescTF.localScale = Vector3.one
	end

	setText(arg0_72.energyDescTextTF, i18n(arg2_72))

	arg0_72.energyDescTF.position = arg1_72

	setActive(arg0_72.energyDescTF, true)
	LeanTween.scale(arg0_72.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0_72.energyDescTF.localScale = Vector3.one

		setActive(arg0_72.energyDescTF, false)
	end))
end

function var0_0.onUpdateItem(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg0_74.shipVOs[arg1_74 + 1]
	local var1_74 = var0_74 and var0_74.id or 0

	arg0_74.cardItemDic[var1_74] = arg2_74

	local var2_74 = arg0_74:onInitItem(arg2_74)

	var2_74:update(var0_74)

	if arg0_74.contextData.mode == DockyardScene.MODE_WORLD then
		var2_74:updateWorld()
	end

	var2_74:updateSelected(var2_74.shipVO and underscore.any(arg0_74.selectedIds, function(arg0_75)
		return var2_74.shipVO.id == arg0_75
	end))
	arg0_74:updateItemBlackBlock(var2_74)

	var2_74.isLoading = false

	var2_74:updateIntimacyEnergy(arg0_74.contextData.energyDisplay or arg0_74.sortIndex == ShipIndexConst.SortEnergy)

	local var3_74 = (arg0_74.sortIndex == ShipIndexConst.SortIntimacy or arg0_74.extraIndex == ShipIndexConst.ExtraMarry) and arg0_74.contextData.mode ~= DockyardScene.MODE_UPGRADE

	var2_74:updateIntimacy(var3_74)
end

function var0_0.onReturnItem(arg0_76, arg1_76, arg2_76)
	if arg0_76.exited then
		return
	end

	local var0_76 = arg0_76.scrollItems[arg2_76]

	if var0_76 then
		var0_76:clear()
	end
end

function var0_0.updateIndexDatas(arg0_77)
	arg0_77.contextData.indexDatas = arg0_77.contextData.indexDatas or {}
	arg0_77.contextData.indexDatas.sortIndex = arg0_77.sortIndex
	arg0_77.contextData.indexDatas.typeIndex = arg0_77.typeIndex
	arg0_77.contextData.indexDatas.campIndex = arg0_77.campIndex
	arg0_77.contextData.indexDatas.rarityIndex = arg0_77.rarityIndex
	arg0_77.contextData.indexDatas.extraIndex = arg0_77.extraIndex
end

function var0_0.initIndexPanel(arg0_78)
	onButton(arg0_78, arg0_78.indexBtn, function()
		local var0_79 = {
			indexDatas = Clone(arg0_78.contextData.indexDatas),
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
			callback = function(arg0_80)
				arg0_78.sortIndex = arg0_80.sortIndex
				arg0_78.typeIndex = arg0_80.typeIndex
				arg0_78.campIndex = arg0_80.campIndex
				arg0_78.rarityIndex = arg0_80.rarityIndex
				arg0_78.extraIndex = arg0_80.extraIndex

				arg0_78:updateIndexDatas()
				arg0_78:filter()
			end
		}

		arg0_78:emit(DockyardMediator.OPEN_DOCKYARD_INDEX, var0_79)
	end, SFX_PANEL)
	onToggle(arg0_78, arg0_78.preferenceBtn, function(arg0_81)
		if arg0_81 then
			arg0_78.commonTag = Ship.PREFERENCE_TAG_COMMON
		else
			arg0_78.commonTag = Ship.PREFERENCE_TAG_NONE
		end

		arg0_78:filter()
	end)
end

function var0_0.setShips(arg0_82, arg1_82)
	arg0_82.shipVOsById = arg1_82

	local var0_82 = getProxy(TechnologyProxy)

	arg0_82.shipBluePrints = {}

	for iter0_82, iter1_82 in ipairs(var0_82:getAllBluePrintShipIds()) do
		local var1_82 = getProxy(BayProxy):getShipById(iter1_82)

		if #var1_82:getAllShipPhantomMarks() > 1 then
			table.insert(arg0_82.shipBluePrints, var0_82:getBluePrintById(var1_82.groupId))
		end
	end

	table.sort(arg0_82.shipBluePrints, CompareFuncs({
		function(arg0_83)
			return arg0_83:getConfig("blueprint_version")
		end,
		function(arg0_84)
			return arg0_84.id
		end
	}))
end

function var0_0.setPlayer(arg0_85, arg1_85)
	arg0_85.player = arg1_85

	arg0_85:updateBarInfo()
end

function var0_0.updateBarInfo(arg0_86)
	setActive(arg0_86.bottomTipsText, arg0_86.contextData.leftTopInfo)
	setText(arg0_86.bottomTipsText, arg0_86.contextData.leftTopInfo and i18n("dock_yard_left_tips", arg0_86.contextData.leftTopInfo) or "")
	setActive(arg0_86.bottomTipsWithFrame, arg0_86.contextData.leftTopWithFrameInfo)
	setText(arg0_86.bottomTipsWithFrame:Find("Text"), arg0_86.contextData.leftTopWithFrameInfo or "")

	if arg0_86.contextData.mode == var0_0.MODE_WORLD or arg0_86.contextData.mode == var0_0.MODE_GUILD_BOSS or arg0_86.contextData.mode == var0_0.MODE_REMOULD or arg0_86.isPhantomMode then
		setActive(arg0_86.leftTipsText, false)
	else
		setActive(arg0_86.leftTipsText, true)
		arg0_86:updateCapacityDisplay()
	end
end

function var0_0.updateCapacityDisplay(arg0_87)
	setActive(arg0_87.leftTipsText:Find("plus"), not arg0_87.isCapacityMeta)
	setActive(arg0_87.leftTipsText:Find("tip"), arg0_87.isCapacityMeta)
	setActive(arg0_87.leftTipsText:Find("switch/off"), not arg0_87.isCapacityMeta)
	setActive(arg0_87.leftTipsText:Find("switch/on"), arg0_87.isCapacityMeta)

	if arg0_87.isCapacityMeta then
		setText(arg0_87.leftTipsText:Find("label"), i18n("specialshipyard_name"))
		setText(arg0_87.leftTipsText:Find("Text"), arg0_87.specialShipCount)
	else
		setText(arg0_87.leftTipsText:Find("label"), i18n("ship_dockyardScene_capacity"))
		setText(arg0_87.leftTipsText:Find("Text"), arg0_87.shipsCount .. "/" .. arg0_87.player:getMaxShipBag())
	end
end

function var0_0.initWorldPanel(arg0_88)
	onButton(arg0_88, arg0_88.worldPanel:Find("btn_repair"), function()
		if #arg0_88.selectedIds > 0 then
			arg0_88:repairWorldShip(arg0_88.shipVOsById[arg0_88.selectedIds[1]])
		end
	end, SFX_PANEL)
	onButton(arg0_88, arg0_88.worldPanel:Find("btn_repair_all"), function()
		local var0_90 = {}
		local var1_90 = 0

		for iter0_90, iter1_90 in pairs(arg0_88.shipVOsById) do
			local var2_90 = WorldConst.FetchWorldShip(iter1_90.id)

			if var2_90:IsBroken() or not var2_90:IsHpFull() then
				table.insert(var0_90, var2_90.id)

				var1_90 = var1_90 + nowWorld():CalcRepairCost(var2_90)
			end
		end

		if #var0_90 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_ship_repair_all", var1_90),
				onYes = function()
					arg0_88:emit(DockyardMediator.ON_SHIP_REPAIR, var0_90, var1_90)
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.repairWorldShip(arg0_92, arg1_92)
	local var0_92 = WorldConst.FetchWorldShip(arg1_92.id)
	local var1_92 = nowWorld():CalcRepairCost(var0_92)

	if var0_92:IsBroken() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_2", arg1_92:getName(), var1_92),
			onYes = function()
				arg0_92:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_92.id
				}, var1_92)
			end
		})
	elseif not var0_92:IsHpFull() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_1", arg1_92:getName(), var1_92),
			onYes = function()
				arg0_92:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_92.id
				}, var1_92)
			end
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
	end
end

function var0_0.filter(arg0_95)
	local var0_95 = arg0_95:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	LoadImageSpriteAtlasAsync("ui/dockyardui_atlas", var0_95, arg0_95.indexBtn, true)

	if arg0_95.isRemouldOrUpgradeMode then
		arg0_95:filterForRemouldAndUpgrade()
	else
		arg0_95:filterCommon()
	end

	local var1_95 = 0

	if arg0_95.contextData.quitTeam then
		var1_95 = var1_95 + 1

		table.insert(arg0_95.shipVOs, var1_95, false)
	end

	if arg0_95.contextData.priorEquipUpShipIDList then
		local var2_95 = {}

		for iter0_95, iter1_95 in ipairs(arg0_95.contextData.priorEquipUpShipIDList) do
			var2_95[iter1_95] = true
		end

		for iter2_95 = #arg0_95.shipVOs, 1, -1 do
			local var3_95 = type(arg0_95.shipVOs[iter2_95]) == "table" and arg0_95.shipVOs[iter2_95].id

			if var2_95[var3_95] then
				var2_95[var3_95] = table.remove(arg0_95.shipVOs, iter2_95)
			end
		end

		for iter3_95, iter4_95 in ipairs(arg0_95.contextData.priorEquipUpShipIDList) do
			local var4_95 = var2_95[iter4_95]

			if type(var4_95) == "table" then
				var1_95 = var1_95 + 1

				table.insert(arg0_95.shipVOs, var1_95, var4_95)
			end
		end
	end

	if var0_0.MODE_OVERVIEW == arg0_95.contextData.mode and DockyardScene.value then
		arg0_95:updateShipCount(DockyardScene.value or 0)

		DockyardScene.value = nil
	else
		arg0_95:updateShipCount(0)
	end
end

function var0_0.filterForRemouldAndUpgrade(arg0_96)
	arg0_96.shipVOs = {}

	local var0_96 = arg0_96.isFilterLockForMod
	local var1_96 = arg0_96.isFilterLevelForMod

	local function var2_96(arg0_97)
		local var0_97 = true

		if not var0_96 and arg0_97.lockState == Ship.LOCK_STATE_LOCK then
			var0_97 = false
		end

		if not var1_96 and arg0_97.level > 1 then
			var0_97 = false
		end

		return var0_97
	end

	for iter0_96, iter1_96 in pairs(arg0_96.shipVOsById) do
		if var2_96(iter1_96) then
			table.insert(arg0_96.shipVOs, iter1_96)
		end
	end

	table.sort(arg0_96.shipVOs, CompareFuncs({
		function(arg0_98)
			return arg0_98.level
		end,
		function(arg0_99)
			return arg0_99:isTestShip() and 1 or 0
		end
	}))
end

function var0_0.filterCommon(arg0_100)
	arg0_100.shipVOs = {}

	local var0_100 = arg0_100.sortIndex

	local function var1_100(arg0_101)
		if arg0_100.contextData.mode ~= var0_0.MODE_GUILD_BOSS then
			return true
		end

		if arg0_100.isShowAssultShips then
			return true
		end

		if not arg0_101.user then
			return true
		end

		if arg0_101.user.id == arg0_100.player.id then
			return true
		end

		return false
	end

	for iter0_100, iter1_100 in pairs(arg0_100.shipVOsById) do
		if arg0_100.contextData.blockLock and iter1_100:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0_100.teamTypeFilter and iter1_100:getTeamType() ~= arg0_100.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1_100, arg0_100.typeIndex) and ShipIndexConst.filterByCamp(iter1_100, arg0_100.campIndex) and ShipIndexConst.filterByRarity(iter1_100, arg0_100.rarityIndex) and ShipIndexConst.filterByExtra(iter1_100, arg0_100.extraIndex) and (arg0_100.commonTag == Ship.PREFERENCE_TAG_NONE or arg0_100.commonTag == iter1_100:GetPreferenceTag()) and var1_100(iter1_100) then
			table.insert(arg0_100.shipVOs, iter1_100)
		end
	end

	local var2_100 = arg0_100.searchBar:GetInputText()

	if var2_100 and var2_100 ~= "" then
		arg0_100.shipVOs = underscore.filter(arg0_100.shipVOs, function(arg0_102)
			return arg0_102:IsMatchKey(var2_100)
		end)
	end

	local var3_100, var4_100 = ShipIndexConst.getSortFuncAndName(var0_100, arg0_100.selectAsc)

	if (var0_100 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0_100.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3_100, 1, function(arg0_103)
			return arg0_103:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3_100 then
		arg0_100:SortShips(var3_100)
	end

	arg0_100:updateSelected()
	setActive(arg0_100.sortImgAsc, arg0_100.selectAsc)
	setActive(arg0_100.sortImgDesc, not arg0_100.selectAsc)
	setText(arg0_100.sortBtn:Find("Image"), i18n(var4_100))
end

function var0_0.SortShips(arg0_104, arg1_104)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0_104 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1_104 = {
			function(arg0_105)
				return table.contains(var0_104, arg0_105.configId) and 0 or 1
			end
		}
	elseif arg0_104.isFormTactics then
		table.insert(arg1_104, 1, function(arg0_106)
			return arg0_106:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1_104, 1, function(arg0_107)
			return arg0_107:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0_104.contextData.mode == var0_0.MODE_OVERVIEW or arg0_104.contextData.mode == var0_0.MODE_SELECT then
		table.insert(arg1_104, 1, function(arg0_108)
			return -arg0_108.activityNpc
		end)
	elseif arg0_104.contextData.mode == var0_0.MODE_GUILD_BOSS then
		table.insert(arg1_104, 1, function(arg0_109)
			return arg0_109.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0_104.shipVOs, CompareFuncs(arg1_104))
end

function var0_0.UpdateGuildViewEquipmentsBtn(arg0_110)
	setActive(arg0_110.viewEquipmentBtn, arg0_110.contextData.mode == var0_0.MODE_GUILD_BOSS and #arg0_110.selectedIds > 0)
end

function var0_0.GetSelectCount(arg0_111)
	return #arg0_111.selectedIds
end

function var0_0.GetConfirmSelect(arg0_112)
	return arg0_112.selectedIds
end

function var0_0.didEnter(arg0_113)
	if arg0_113:isLayer() then
		arg0_113:OverlayPanel(arg0_113._tf, {
			groupDelta = -1
		})
	end

	arg0_113:OverlayPanel(arg0_113.blurPanel)
	arg0_113:PlayUIAnimation(arg0_113.blurPanel, "enter")
	setActive(arg0_113.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0_113.contextData.mode ~= var0_0.MODE_GUILD_BOSS)
	arg0_113:UpdateGuildViewEquipmentsBtn()
	onButton(arg0_113, arg0_113.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0_113, arg0_113.topPanel:Find("back"), function()
		arg0_113:back()
	end, SFX_CANCEL)
	onButton(arg0_113, arg0_113.sortBtn, function()
		arg0_113.selectAsc = not arg0_113.selectAsc

		arg0_113:filter()
	end, SFX_UI_CLICK)
	onToggle(arg0_113, arg0_113.assultBtn, function(arg0_117)
		arg0_113.isShowAssultShips = arg0_117

		arg0_113:filter()
	end, SFX_PANEL)
	onButton(arg0_113, arg0_113.viewEquipmentBtn, function()
		local var0_118 = arg0_113.selectedIds[#arg0_113.selectedIds]

		if not var0_118 then
			return
		end

		local var1_118 = arg0_113.shipVOsById[var0_118]
		local var2_118 = var1_118.user

		arg0_113.guildShipEquipmentsPage:ExecuteAction("Show", var1_118, var2_118)
	end, SFX_PANEL)
	onButton(arg0_113, arg0_113.attrBtn, function()
		if not arg0_113.isFormTactics then
			arg0_113.itemDetailType = (arg0_113.itemDetailType + 1) % 4
		else
			arg0_113.itemDetailType = arg0_113.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(arg0_113.attrBtn:Find("off"), arg0_113.itemDetailType == DockyardShipItem.DetailType0)
		setActive(arg0_113.attrBtn:Find("on"), arg0_113.itemDetailType ~= DockyardShipItem.DetailType0)

		arg0_113.attrBtn:GetComponent("Button").targetGraphic = arg0_113.itemDetailType == DockyardShipItem.DetailType0 and imageOff or imageOn

		arg0_113:updateItemDetailType()
	end, SFX_PANEL)
	onButton(arg0_113, arg0_113.selectPanel:Find("cancel_button"), function()
		if arg0_113.animating then
			return
		end

		if arg0_113.contextData.mode == var0_0.MODE_DESTROY then
			if #arg0_113.selectedIds > 0 then
				arg0_113:unselecteAllShips()
				arg0_113:back()
			else
				arg0_113:back()
			end
		else
			arg0_113:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0_113, arg0_113.selectPanel:Find("confirm_button"), function()
		if arg0_113.animating then
			return
		end

		if arg0_113.contextData.mode == var0_0.MODE_DESTROY then
			local var0_121, var1_121 = arg0_113:checkDestroyGold()

			if not var0_121 or not var1_121 then
				if not var0_121 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0_121 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if arg0_113:GetSelectCount() < arg0_113.selectedMin then
			if arg0_113.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0_113.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0_113.selectedMin))
			end

			return
		end

		if arg0_113.contextData.mode == var0_0.MODE_DESTROY then
			arg0_113:displayDestroyPanel()
		else
			local var2_121 = {}

			if arg0_113.contextData.destroyCheck then
				local var3_121 = underscore.map(arg0_113.selectedIds, function(arg0_122)
					return arg0_113.shipVOsById[arg0_122]
				end)

				table.insert(var2_121, function(arg0_123)
					arg0_113:checkDestroyShips(var3_121, arg0_123)
				end)
			end

			local var4_121 = arg0_113:GetConfirmSelect()

			if arg0_113.confirmSelect then
				table.insert(var2_121, function(arg0_124)
					arg0_113.confirmSelect(var4_121, function()
						arg0_124(true)
					end, arg0_124)
				end)
				seriesAsync(var2_121, function(arg0_126)
					if arg0_126 then
						arg0_113.onSelected(var4_121)
					end

					arg0_113:back()
				end)
			else
				table.insert(var2_121, function(arg0_127)
					if arg0_113.callbackQuit then
						arg0_113.onSelected(var4_121, arg0_127)
					else
						arg0_113.onSelected(var4_121)
						arg0_127()
					end
				end)
				seriesAsync(var2_121, function()
					arg0_113:back()
				end)
			end
		end
	end, SFX_CONFIRM)
	onButton(arg0_113, arg0_113.selectPanel:Find("quick_select"), function()
		if arg0_113.animating then
			return
		end

		local var0_129 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1_129 = 3
		local var2_129 = {}

		for iter0_129, iter1_129 in pairs(var0_129) do
			if iter1_129 ~= 0 then
				var2_129[iter1_129] = var2_129[iter1_129] or var1_129
				var1_129 = var1_129 - 1
			end
		end

		local var3_129 = getProxy(BayProxy):getShips()
		local var4_129 = {}
		local var5_129 = {}

		for iter2_129, iter3_129 in pairs(var3_129) do
			if iter3_129:isMaxStar() then
				var4_129[iter3_129:getGroupId()] = true
			else
				local var6_129 = iter3_129:getMaxStar() - iter3_129:getStar() + 1

				if iter3_129:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6_129 = var6_129 + 1
				end

				local var7_129 = var5_129[iter3_129:getGroupId()]

				var5_129[iter3_129:getGroupId()] = var7_129 and var7_129 < var6_129 and var7_129 or var6_129
			end
		end

		local var8_129 = _.select(arg0_113.shipVOs, function(arg0_130)
			return arg0_130.configId ~= 100001 and arg0_130.configId ~= 100011 and arg0_130:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0_129, arg0_130:getRarity()) and arg0_130.level == 1 and not arg0_113.blacklist[arg0_130:getGroupId()] and not table.contains(arg0_113.selectedIds, arg0_130.id) and not arg0_130:hasAnyFlag({
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

		if not _.all(var8_129, function(arg0_131)
			return arg0_113.blacklist[arg0_131:getGroupId()]
		end) then
			var8_129 = _.select(var8_129, function(arg0_132)
				return not arg0_113.blacklist[arg0_132:getGroupId()]
			end)
		elseif #arg0_113.selectedIds > 0 then
			var8_129 = {}
		end

		table.sort(var8_129, function(arg0_133, arg1_133)
			local var0_133 = var2_129[arg0_133:getRarity()] or 0
			local var1_133 = var2_129[arg1_133:getRarity()] or 0

			if var0_133 == var1_133 then
				if arg0_133:getGroupId() == arg1_133:getGroupId() then
					return arg0_133.createTime > arg1_133.createTime
				end

				return arg0_133.configId > arg1_133.configId
			else
				return var1_133 < var0_133
			end
		end)

		local var9_129 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10_129 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11_129 = {}
		local var12_129 = _.select(var8_129, function(arg0_134)
			if var4_129[arg0_134:getGroupId()] then
				if var9_129 == "KeepNone" then
					return true
				elseif var9_129 == "KeepOne" then
					if not var11_129[arg0_134:getGroupId()] then
						var11_129[arg0_134:getGroupId()] = true

						return false
					end

					return true
				elseif var9_129 == "KeepAll" then
					return false
				end
			elseif var10_129 == "KeepNone" then
				return true
			elseif var10_129 == "KeepNeeded" then
				if var5_129[arg0_134:getGroupId()] > 0 then
					var5_129[arg0_134:getGroupId()] = var5_129[arg0_134:getGroupId()] - 1

					return false
				end

				return true
			elseif var10_129 == "KeepAll" then
				return false
			end
		end)
		local var13_129 = 0
		local var14_129 = false
		local var15_129 = false
		local var16_129 = 0
		local var17_129 = 0

		for iter4_129, iter5_129 in ipairs(arg0_113.selectedIds) do
			local var18_129, var19_129 = arg0_113.shipVOsById[iter5_129]:calReturnRes()

			var16_129 = var16_129 + var18_129
			var17_129 = var17_129 + var19_129
		end

		for iter6_129, iter7_129 in ipairs(var12_129) do
			if arg0_113.selectedMax > 0 and arg0_113.selectedMax <= arg0_113:GetSelectCount() then
				break
			end

			local var20_129, var21_129 = iter7_129:calReturnRes()

			var16_129 = var16_129 + var20_129
			var17_129 = var17_129 + var21_129
			var14_129 = arg0_113.player:OilMax(var17_129)
			var15_129 = arg0_113.player:GoldMax(var16_129)

			if var15_129 then
				break
			end

			var13_129 = var13_129 + 1

			arg0_113:selectShip(iter7_129)
		end

		if var13_129 == 0 then
			if var15_129 then
				if #arg0_113.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0_113.selectedIds > 0 then
				arg0_113:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14_129 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0_113:displayDestroyPanel()
				end
			})
		else
			arg0_113:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if isActive(arg0_113.togglePhantom) then
		triggerToggle(arg0_113.togglePhantom, tobool(arg0_113.inPhantom))
	else
		arg0_113:SwitchContainerDisplay()
	end

	arg0_113:updateBarInfo()

	if arg0_113.contextData.mode == var0_0.MODE_WORLD then
		arg0_113:initWorldPanel()
	elseif arg0_113.contextData.mode == var0_0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_113)
	end

	setAnchoredPosition(arg0_113.topPanel, {
		y = arg0_113.topPanel.rect.height
	})
	setAnchoredPosition(arg0_113.selectPanel, {
		y = -1 * arg0_113.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0_113.exited then
			return
		end

		arg0_113:uiStartAnimating()
	end)

	arg0_113.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_113)

	onButton(arg0_113, arg0_113.settingBtn, function()
		arg0_113.settingPanel:Load()
		arg0_113.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0_113)
end

function var0_0.TriggerCard(arg0_138, arg1_138)
	local var0_138 = arg0_138.selectedIds[1]

	if not var0_138 then
		return
	end

	local var1_138

	for iter0_138, iter1_138 in ipairs(arg0_138.shipVOs) do
		if iter1_138 and iter1_138.id == var0_138 then
			var1_138 = iter0_138

			break
		end
	end

	if not var1_138 then
		return
	end

	local var2_138 = var1_138
	local var3_138

	local function var4_138()
		var2_138 = var2_138 + arg1_138

		local var0_139 = arg0_138.shipVOs[var2_138]

		if not var0_139 or arg0_138.checkShip(var0_139) then
			return var0_139
		else
			return var4_138()
		end
	end

	local var5_138 = var4_138()

	if not var5_138 then
		return
	end

	local function var6_138()
		local var0_140

		for iter0_140, iter1_140 in pairs(arg0_138.scrollItems) do
			if iter1_140.shipVO and iter1_140.go.name ~= "-1" and iter1_140.shipVO.id == var5_138.id then
				var0_140 = iter1_140

				break
			end
		end

		return var0_140
	end

	local var7_138 = arg0_138.cardItemDic[var0_138]
	local var8_138 = var7_138 and arg0_138.scrollItems[var7_138]
	local var9_138 = var8_138 and var8_138.shipVO.id == var5_138.id and var8_138 or nil

	if var9_138 then
		local var10_138 = getBounds(arg0_138._tf:Find("main/ship_container"))
		local var11_138 = getBounds(var9_138.tr)

		if not var10_138:Intersects(var11_138) then
			local var12_138 = arg1_138 * (arg0_138.shipContainer:HeadIndexToValue(7) - arg0_138.shipContainer:HeadIndexToValue(1))
			local var13_138 = arg0_138.shipContainer.value + var12_138

			arg0_138.shipContainer:SetNormalizedPosition(var13_138, 1)
		end
	end

	if not var9_138 then
		local var14_138 = (math.ceil(var2_138 / 7) - math.ceil(var1_138 / 7)) * (arg0_138.shipContainer:HeadIndexToValue(21) - arg0_138.shipContainer:HeadIndexToValue(1))
		local var15_138 = arg0_138.shipContainer.value + var14_138

		arg0_138.shipContainer:SetNormalizedPosition(var15_138, 1)

		var9_138 = var6_138()
	end

	if var9_138 then
		triggerButton(var9_138.tr)

		local var16_138 = arg0_138.shipVOsById[var9_138.shipVO.id]

		arg0_138.guildShipEquipmentsPage:Refresh(var16_138, var16_138.user)
	end
end

function var0_0.OnSwitch(arg0_141, arg1_141, arg2_141, arg3_141)
	local function var0_141()
		setActive(arg1_141:Find("off"), not arg2_141)
		setActive(arg1_141:Find("on"), arg2_141)
	end

	onButton(arg0_141, arg1_141, function()
		arg2_141 = not arg2_141

		if arg3_141 then
			arg3_141(arg2_141)
		end

		var0_141()
	end, SFX_PANEL)
	var0_141()
end

function var0_0.OnShipSkinChanged(arg0_144, arg1_144)
	local var0_144, var1_144 = ShipPhantom.UnpackMark(arg1_144)
	local var2_144 = arg0_144.phantomGroupDic[var0_144]
	local var3_144 = var2_144 and arg0_144.scrollPhantoms[var2_144]

	if var3_144 and var3_144.shipCard.shipVO.id == var0_144 then
		arg0_144:updatePhantomGroup(underscore.detect(arg0_144.filterBluePrint, function(arg0_145)
			return arg0_145.shipId == var0_144
		end), var2_144)
	end
end

function var0_0.onBackPressed(arg0_146)
	if arg0_146.destroyConfirmWindow:isShowing() then
		arg0_146.destroyConfirmWindow:Hide()

		return
	end

	if arg0_146.destroyPage:isShowing() then
		arg0_146.destroyPage:Hide()

		return
	end

	if arg0_146.settingPanel:isShowing() then
		arg0_146.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_146:back()
end

function var0_0.updateShipStatusById(arg0_147, arg1_147)
	local var0_147 = arg0_147.cardItemDic[arg1_147]
	local var1_147 = var0_147 and arg0_147.scrollItems[var0_147]

	if var1_147 and var1_147.shipVO.id == arg1_147 then
		var1_147:flush(arg0_147.selectedIds)

		if arg0_147.contextData.mode == DockyardScene.MODE_WORLD then
			var1_147:updateWorld()
		end
	end
end

function var0_0.checkDestroyGold(arg0_148, arg1_148)
	local var0_148 = 0
	local var1_148 = 0

	for iter0_148, iter1_148 in ipairs(arg0_148.selectedIds) do
		local var2_148, var3_148 = arg0_148.shipVOsById[iter1_148]:calReturnRes()

		var0_148 = var0_148 + var2_148
		var1_148 = var1_148 + var3_148
	end

	if arg1_148 then
		local var4_148, var5_148 = arg1_148:calReturnRes()

		var0_148 = var0_148 + var4_148
		var1_148 = var1_148 + var5_148
	end

	local var6_148 = arg0_148.player:OilMax(var1_148)

	if arg0_148.player:GoldMax(var0_148) then
		return false, not var6_148
	end

	return true, not var6_148
end

function var0_0.selectShip(arg0_149, arg1_149)
	local var0_149 = false
	local var1_149

	for iter0_149, iter1_149 in ipairs(arg0_149.selectedIds) do
		if iter1_149 == arg1_149.id then
			var0_149 = true
			var1_149 = iter0_149

			break
		end
	end

	if var0_149 or arg0_149.selectedMax == 1 and arg0_149:GetSelectCount() > 0 then
		local var2_149 = defaultValue(var1_149, 1)
		local var3_149 = arg0_149.shipVOsById[arg0_149.selectedIds[var2_149]]
		local var4_149, var5_149 = arg0_149.onCancelShip(var3_149, function()
			if not arg0_149.exited then
				return
			end

			arg0_149:selectShip(arg1_149)
		end, arg0_149.selectedIds)

		if not var4_149 then
			if var5_149 then
				pg.TipsMgr.GetInstance():ShowTips(var5_149)
			end

			return
		end

		table.remove(arg0_149.selectedIds, var2_149)

		if arg0_149.selectedMax ~= 1 then
			arg0_149:updateBlackBlocks(var3_149)
		end
	end

	if not var0_149 then
		local var6_149, var7_149 = arg0_149.checkShip(arg1_149, function()
			if arg0_149.exited then
				return
			end

			arg0_149:selectShip(arg1_149)
		end, arg0_149.selectedIds)

		if not var6_149 then
			if var7_149 then
				pg.TipsMgr.GetInstance():ShowTips(var7_149)
			end

			return
		end

		if arg0_149.selectedMax == 0 or arg0_149:GetSelectCount() < arg0_149.selectedMax then
			table.insert(arg0_149.selectedIds, arg1_149.id)

			if arg0_149.selectedMax ~= 1 then
				arg0_149:updateBlackBlocks(removeShip)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_149.selectedMax))

			return
		end
	end

	arg0_149:updateSelected()

	if arg0_149.contextData.mode == var0_0.MODE_DESTROY then
		arg0_149:updateDestroyRes()
	elseif arg0_149.contextData.mode == var0_0.MODE_MOD then
		arg0_149:updateModAttr()
	end

	arg0_149:UpdateGuildViewEquipmentsBtn()
end

function var0_0.updateBlackBlocks(arg0_152, arg1_152)
	if not arg0_152.contextData.useBlackBlock or not arg1_152 then
		return
	end

	for iter0_152, iter1_152 in pairs(arg0_152.scrollItems) do
		arg0_152:updateItemBlackBlock(iter1_152)
	end
end

function var0_0.updateItemBlackBlock(arg0_153, arg1_153)
	if arg0_153.contextData.useBlackBlock then
		if arg0_153.selectedMax == 1 then
			arg1_153:updateBlackBlock(arg0_153.contextData.otherSelectedIds)
		else
			arg1_153:updateBlackBlock(arg0_153.selectedIds)
		end
	else
		arg1_153:updateBlackBlock()
	end
end

function var0_0.unselecteAllShips(arg0_154)
	arg0_154.selectedIds = {}

	arg0_154:updateSelected()
	arg0_154:updateDestroyRes()
end

function var0_0.updateSelected(arg0_155)
	if arg0_155.shipContainer then
		for iter0_155, iter1_155 in pairs(arg0_155.scrollItems) do
			if not iter1_155.isClear then
				local var0_155 = iter1_155.shipVO and iter1_155.shipVO.id or nil

				iter1_155:updateSelected(iter1_155.shipVO and underscore.any(arg0_155.selectedIds, function(arg0_156)
					return var0_155 == arg0_156
				end))
			end
		end
	end

	if arg0_155.phantomContainer then
		for iter2_155, iter3_155 in pairs(arg0_155.scrollPhantoms) do
			if not iter3_155.isClear then
				local var1_155 = iter3_155.shipCard.shipVO.id
				local var2_155 = {}
				local var3_155 = getGameset("technology_shadow_num")[1]

				for iter4_155 = 0, var3_155 do
					if iter4_155 == 0 then
						var2_155[iter4_155] = underscore.any(arg0_155.selectedIds, function(arg0_157)
							return var1_155 == arg0_157
						end)
					else
						var2_155[iter4_155] = underscore.any(arg0_155.selectedMarks, function(arg0_158)
							return arg0_158 == ShipPhantom.PackMark(var1_155, iter4_155)
						end)
					end
				end

				iter3_155:updateSelected(var2_155)
			end
		end
	end

	if arg0_155.selectedMax == 0 then
		setText(arg0_155.selectPanel:Find("bottom_info/bg_input/count"), arg0_155:GetSelectCount())
	else
		local var4_155 = arg0_155:GetSelectCount()

		if arg0_155.contextData.mode ~= var0_0.MODE_DESTROY or arg0_155:GetSelectCount() == 0 then
			var4_155 = setColorStr(var4_155, COLOR_WHITE)
		elseif arg0_155.contextData.mode == var0_0.MODE_DESTROY then
			var4_155 = setColorStr(var4_155, #arg0_155.selectedIds == 10 and COLOR_RED or COLOR_GREEN)
		end

		setText(arg0_155.selectPanel:Find("bottom_info/bg_input/count"), var4_155 .. "/" .. arg0_155.selectedMax)
	end

	if arg0_155:GetSelectCount() < arg0_155.selectedMin then
		setActive(arg0_155.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0_155.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0_155.contextData.mode == var0_0.MODE_MOD then
		arg0_155:updateModAttr()
	end
end

function var0_0.updateItemDetailType(arg0_159)
	for iter0_159, iter1_159 in pairs(arg0_159.scrollItems) do
		iter1_159:updateDetail(arg0_159.itemDetailType)
	end

	arg0_159.shipLayout.anchoredPosition = arg0_159.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0_0.closeDestroyMode(arg0_160)
	setActive(arg0_160.awardTF, false)
	setActive(arg0_160.bottomTipsText, true)
end

function var0_0.updateDestroyRes(arg0_161)
	if table.getCount(arg0_161.selectedIds) == 0 then
		arg0_161:closeDestroyMode()
	else
		setActive(arg0_161.awardTF, true)
		setActive(arg0_161.bottomTipsText, false)
	end

	local var0_161 = _.map(arg0_161.selectedIds, function(arg0_162)
		return arg0_161.shipVOsById[arg0_162]
	end)
	local var1_161, var2_161, var3_161 = ShipCalcHelper.CalcDestoryRes(var0_161)
	local var4_161 = var2_161 == 0

	if arg0_161.destroyResList then
		local var5_161 = (var4_161 and 1 or 2) + #var3_161

		arg0_161.destroyResList:make(function(arg0_163, arg1_163, arg2_163)
			if arg0_163 == UIItemList.EventUpdate then
				local var0_163 = ""
				local var1_163 = 0

				if arg1_163 == 0 then
					var0_163, var1_163 = "Props/gold", var1_161
				elseif arg1_163 == 1 then
					if not var4_161 then
						var0_163, var1_163 = "Props/oil", var2_161
					else
						local var2_163 = var3_161[1]

						var0_163, var1_163 = Item.getConfigData(var2_163.id).icon, var2_163.count
					end
				elseif arg1_163 > 1 then
					local var3_163 = var4_161 and var3_161[arg1_163] or var3_161[arg1_163 - 1]

					var0_163, var1_163 = Item.getConfigData(var3_163.id).icon, var3_163.count
				end

				GetImageSpriteFromAtlasAsync(var0_163, "", arg2_163:Find("icon"))
				setText(arg2_163:Find("Text"), "X" .. var1_163)
			end
		end)
		arg0_161.destroyResList:align(var5_161)
	end

	if arg0_161.destroyPage and arg0_161.destroyPage:GetLoaded() and arg0_161.destroyPage:isShowing() then
		arg0_161.destroyPage:RefreshRes()
	end
end

function var0_0.setModShip(arg0_164, arg1_164)
	arg0_164.modShip = arg1_164
end

function var0_0.updateModAttr(arg0_165)
	if table.getCount(arg0_165.selectedIds) == 0 then
		arg0_165:closeModAttr()
	else
		setActive(arg0_165.modAttrsTF, true)
		setActive(arg0_165.bottomTipsText, false)
	end

	local var0_165 = arg0_165.contextData.ignoredIds[1]
	local var1_165 = {}

	for iter0_165, iter1_165 in ipairs(arg0_165.selectedIds) do
		table.insert(var1_165, arg0_165.shipVOsById[iter1_165])
	end

	local var2_165 = ShipModLayer.getModExpAdditions(arg0_165.modShip, var1_165)

	for iter2_165, iter3_165 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2_165 ~= ShipModLayer.IGNORE_ID then
			local var3_165 = arg0_165.modAttrContainer:Find("attr_" .. iter2_165)

			setText(var3_165:Find("value"), var2_165[iter3_165])
			setText(var3_165:Find("name"), ShipModAttr.id2Name(iter2_165))
		end
	end
end

function var0_0.closeModAttr(arg0_166)
	setActive(arg0_166.modAttrsTF, false)
	setActive(arg0_166.bottomTipsText, true)
end

function var0_0.removeShip(arg0_167, arg1_167)
	for iter0_167, iter1_167 in ipairs(arg0_167.selectedIds) do
		if iter1_167 == arg1_167 then
			table.remove(arg0_167.selectedIds, iter0_167)

			break
		end
	end

	for iter2_167 = #arg0_167.shipVOs, 1, -1 do
		if arg0_167.shipVOs[iter2_167].id == arg1_167 then
			table.remove(arg0_167.shipVOs, iter2_167)

			break
		end
	end

	arg0_167.shipVOsById[arg1_167] = nil
end

function var0_0.updateShipCount(arg0_168, arg1_168)
	arg0_168.shipContainer:SetTotalCount(#arg0_168.shipVOs, defaultValue(arg1_168, -1))
	setActive(arg0_168.listEmptyTF, #arg0_168.shipVOs <= 0)
end

function var0_0.ClearShipsBlackBlock(arg0_169)
	if not arg0_169.shipVOsById then
		return
	end

	for iter0_169, iter1_169 in pairs(arg0_169.shipVOsById) do
		iter1_169.blackBlock = false
	end
end

function var0_0.willExit(arg0_170)
	arg0_170:closeDestroyMode()
	arg0_170:closeModAttr()
	arg0_170:ClearShipsBlackBlock()

	if arg0_170.guildShipEquipmentsPage then
		arg0_170.guildShipEquipmentsPage:Destroy()
	end

	if arg0_170.settingPanel then
		arg0_170.settingPanel:Destroy()
	end

	if arg0_170.destroyPage then
		arg0_170.destroyPage:Destroy()
	end

	if arg0_170.destroyConfirmWindow then
		arg0_170.destroyConfirmWindow:Destroy()
	end

	if arg0_170.contextData.mode == var0_0.MODE_MOD then
		-- block empty
	elseif not arg0_170.contextData.sortData then
		if _G[arg0_170.contextData.preView] then
			_G[arg0_170.contextData.preView].sortIndex = arg0_170.sortIndex
			_G[arg0_170.contextData.preView].selectAsc = arg0_170.selectAsc
			_G[arg0_170.contextData.preView].typeIndex = arg0_170.typeIndex
			_G[arg0_170.contextData.preView].campIndex = arg0_170.campIndex
			_G[arg0_170.contextData.preView].rarityIndex = arg0_170.rarityIndex
			_G[arg0_170.contextData.preView].extraIndex = arg0_170.extraIndex
			_G[arg0_170.contextData.preView].commonTag = arg0_170.commonTag
		else
			DockyardScene.sortIndex = arg0_170.sortIndex
			DockyardScene.selectAsc = arg0_170.selectAsc
			DockyardScene.typeIndex = arg0_170.typeIndex
			DockyardScene.campIndex = arg0_170.campIndex
			DockyardScene.rarityIndex = arg0_170.rarityIndex
			DockyardScene.extraIndex = arg0_170.extraIndex
			DockyardScene.commonTag = arg0_170.commonTag
		end
	end

	if arg0_170.shipContainer then
		arg0_170.shipContainer.enabled = false

		for iter0_170, iter1_170 in pairs(arg0_170.scrollItems) do
			iter1_170:clear()
			GetOrAddComponent(iter1_170.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
		end
	end

	if arg0_170.phantomContainer then
		arg0_170.phantomContainer.enabled = false

		for iter2_170, iter3_170 in pairs(arg0_170.scrollPhantoms) do
			iter3_170:clear()
		end
	end

	if LeanTween.isTweening(go(arg0_170.energyDescTF)) then
		setActive(arg0_170.energyDescTF, false)
		LeanTween.cancel(go(arg0_170.energyDescTF))
	end

	arg0_170:cancelAnimating()

	if arg0_170.isRemouldOrUpgradeMode then
		local var0_170 = getProxy(SettingsProxy)

		var0_170:SetDockYardLockBtnFlag(arg0_170.isFilterLockForMod)
		var0_170:SetDockYardLevelBtnFlag(arg0_170.isFilterLevelForMod)
	end

	if arg0_170.bulinTip then
		arg0_170.bulinTip:Destroy()

		arg0_170.bulinTip = nil
	end

	if arg0_170.searchBar then
		arg0_170.searchBar:Dispose()

		arg0_170.searchBar = nil
	end

	arg0_170:UnOverlayPanel(arg0_170.blurPanel, arg0_170._tf)

	if arg0_170:isLayer() then
		arg0_170:UnOverlayPanel(arg0_170._tf)
	end
end

function var0_0.uiStartAnimating(arg0_171)
	local var0_171 = arg0_171.topPanel:Find("back")
	local var1_171 = 0
	local var2_171 = 0.3

	if isActive(arg0_171.selectPanel) then
		shiftPanel(arg0_171.selectPanel, nil, 0, var2_171, var1_171, true, true)
	end
end

function var0_0.uiExitAnimating(arg0_172)
	if arg0_172.contextData.mode == var0_0.MODE_OVERVIEW then
		-- block empty
	else
		local var0_172 = 0
		local var1_172 = 0.3

		shiftPanel(arg0_172.selectPanel, nil, -1 * arg0_172.selectPanel.rect.height, var1_172, var0_172, true, true)
	end
end

function var0_0.back(arg0_173)
	if arg0_173.exited then
		return
	end

	arg0_173:closeView()
end

function var0_0.cancelAnimating(arg0_174)
	if LeanTween.isTweening(go(arg0_174.topPanel)) then
		LeanTween.cancel(go(arg0_174.topPanel))
	end

	if LeanTween.isTweening(go(arg0_174.selectPanel)) then
		LeanTween.cancel(go(arg0_174.selectPanel))
	end

	if arg0_174.tweens then
		cancelTweens(arg0_174.tweens)
	end
end

function var0_0.quickExitFunc(arg0_175)
	seriesAsync({
		function(arg0_176)
			if arg0_175.contextData.onQuickHome then
				arg0_175.contextData.onQuickHome(arg0_176)
			else
				arg0_176()
			end
		end,
		function(arg0_177)
			arg0_175:emit(var0_0.ON_HOME)
		end
	})
end

function var0_0.displayDestroyPanel(arg0_178)
	arg0_178.destroyPage:ExecuteAction("Show")
	arg0_178.destroyPage:ActionInvoke("Refresh", arg0_178.selectedIds, arg0_178.shipVOsById)
end

function var0_0.closeDestroyPanel(arg0_179)
	if arg0_179.destroyPage:isShowing() then
		arg0_179.destroyPage:Hide()
	end
end

function var0_0.checkDestroyShips(arg0_180, arg1_180, arg2_180)
	local var0_180 = {}

	if PlayerPrefs.GetInt("RetireProtect", 1) == 0 then
		local var1_180 = {}

		for iter0_180, iter1_180 in pairs(arg1_180) do
			local var2_180 = 0

			for iter2_180, iter3_180 in pairs(arg1_180) do
				if iter3_180:getGroupId() == iter1_180:getGroupId() then
					var2_180 = var2_180 + 1
				end
			end

			if #getProxy(BayProxy):findShipsByGroup(iter1_180:getGroupId()) == var2_180 then
				local var3_180 = false

				for iter4_180, iter5_180 in pairs(var1_180) do
					if iter5_180:getGroupId() == iter1_180:getGroupId() then
						var3_180 = true

						break
					end
				end

				if not var3_180 then
					table.insert(var1_180, iter1_180)
				end
			end
		end

		if #var1_180 > 0 then
			table.insert(var0_180, function(arg0_181)
				arg0_180.destroyConfirmWindow:ExecuteAction("ShowOneShipProtect", var1_180, arg0_181)
			end)
		end
	end

	local var4_180, var5_180 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1_180)

	if #var4_180 > 0 or #var5_180 > 0 then
		table.insert(var0_180, function(arg0_182)
			local var0_182 = false

			if arg0_180.contextData.mode == var0_0.MODE_DESTROY then
				var0_182 = ({
					ShipCalcHelper.CalcDestoryRes(arg1_180)
				})[4]
			end

			arg0_180.destroyConfirmWindow:ExecuteAction("Show", var4_180, var5_180, var0_182, arg0_182)
		end)
	end

	local var6_180 = underscore.filter(arg1_180, function(arg0_183)
		return arg0_183:getFlag("inElite")
	end)

	if #var6_180 > 0 then
		table.insert(var0_180, function(arg0_184)
			arg0_180.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var6_180, arg0_184)
		end)
	end

	seriesAsync(var0_180, arg2_180)
end

return var0_0
