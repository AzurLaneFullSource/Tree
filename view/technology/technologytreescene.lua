local var0_0 = class("TechnologyTreeScene", import("..base.BaseUI"))

var0_0.NationTrige = {
	All = 0,
	Mot = 3,
	Meta = 2,
	Other = 1
}
var0_0.TypeTrige = {
	All = 0,
	Other = 1
}

function var0_0.getUIName(arg0_1)
	return "TechnologyTreeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/Technologytreeui",
		"ui/technologytreeui_atlas",
		"tecclasslevelicon",
		"tecnation",
		"shipraritybaseicon",
		"tecnation"
	}
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(pg.fleet_tech_ship_class.all) do
		local var2_2 = pg.fleet_tech_ship_class[iter1_2]

		for iter2_2, iter3_2 in ipairs(var2_2.ships) do
			local var3_2 = ShipGroup.getDefaultSkin(iter3_2)

			if var3_2 then
				table.insertto(var1_2, ResPathSupport.GetShipSkinSpineShipModelList(var3_2.id))
			end
		end
	end

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2)
end

function var0_0.init(arg0_3)
	arg0_3:initData()
	arg0_3:findUI()
	arg0_3:initNationToggleUIList()
	arg0_3:initTecClassUIList()
end

function var0_0.didEnter(arg0_4)
	arg0_4:initTypeToggleUIList()
	arg0_4:updateTecItemList()
	arg0_4:addBtnListener()
	setText(arg0_4.pointNumText, arg0_4.point)
	arg0_4:updateRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())

	if not PlayerPrefs.HasKey("first_comein_technologytree") then
		triggerButton(arg0_4.helpBtn)
		PlayerPrefs.SetInt("first_comein_technologytree", 1)
		PlayerPrefs.Save()
	end
end

function var0_0.updateRedPoint(arg0_5, arg1_5)
	setActive(arg0_5.redPointImg, arg1_5)
end

function var0_0.willExit(arg0_6)
	arg0_6:UnOverlayPanel(arg0_6.blurPanel, arg0_6._tf)

	arg0_6.rightLSC.onReturnItem = nil

	if arg0_6.emptyPage then
		arg0_6.emptyPage:Destroy()

		arg0_6.emptyPage = nil
	end
end

function var0_0.initData(arg0_7)
	TechnologyConst.CreateMetaClassConfig()

	arg0_7.nationToggleList = {}
	arg0_7.typeToggleList = {}
	arg0_7.nationSelectedList = {}
	arg0_7.typeSelectedList = {}
	arg0_7.nationSelectedCount = 0
	arg0_7.typeSelectedCount = 0
	arg0_7.lastNationTrige = nil
	arg0_7.lastTypeTrige = nil
	arg0_7.countInEveryRow = 5
	arg0_7.collectionProxy = getProxy(CollectionProxy)
	arg0_7.nationProxy = getProxy(TechnologyNationProxy)
	arg0_7.curClassIDList = nil
	arg0_7.groupIDGotList = {}

	local var0_7 = arg0_7.collectionProxy.shipGroups

	for iter0_7, iter1_7 in pairs(var0_7) do
		arg0_7.groupIDGotList[#arg0_7.groupIDGotList + 1] = iter1_7.id
	end

	arg0_7.point = arg0_7.nationProxy:getPoint()
	arg0_7.expanded = {}
end

function var0_0.findUI(arg0_8)
	arg0_8.nationAllToggle = nil
	arg0_8.nationAllToggleCom = nil
	arg0_8.nationMetaToggle = arg0_8._tf:Find("Adapt/Left/MetaToggle")
	arg0_8.nationMetaToggleCom = GetComponent(arg0_8.nationMetaToggle, "Toggle")
	arg0_8.nationMotToggle = arg0_8._tf:Find("Adapt/Left/MotToggle")
	arg0_8.nationMotToggleCom = GetComponent(arg0_8.nationMotToggle, "Toggle")
	arg0_8.typeAllToggle = nil
	arg0_8.typeAllToggleCom = nil
	arg0_8.blurPanel = arg0_8._tf:Find("blur_panel")
	arg0_8.adapt = arg0_8.blurPanel:Find("adapt")
	arg0_8.backBtn = arg0_8.adapt:Find("top/back")
	arg0_8.homeBtn = arg0_8.adapt:Find("top/option")
	arg0_8.additionDetailBtn = arg0_8.adapt:Find("AdditionDetailBtn")
	arg0_8.switchBtn = arg0_8.adapt:Find("SwitchToggle")
	arg0_8.pointTF = arg0_8.adapt:Find("PointCount")
	arg0_8.pointNumText = arg0_8.adapt:Find("PointCount/PointNumText")
	arg0_8.redPointImg = arg0_8.switchBtn:Find("RedPoint")
	arg0_8.helpBtn = arg0_8.adapt:Find("help_btn")
	arg0_8.leftContainer = arg0_8._tf:Find("Adapt/Left/Scroll View/Content")
	arg0_8.selectNationItem = arg0_8._tf:Find("SelectCampItem")
	arg0_8.bottomContainer = arg0_8._tf:Find("Adapt/Bottom/Content")
	arg0_8.selectTypeItem = arg0_8._tf:Find("SelectTypeItem")
	arg0_8.rightContainer = arg0_8._tf:Find("Adapt/Right/Container")
	arg0_8.rightLSC = arg0_8.rightContainer:GetComponent("LScrollRect")
	arg0_8.rightLayoutGroup = arg0_8.rightContainer:GetComponent("VerticalLayoutGroup")
	arg0_8.headItem = arg0_8._tf:Find("HeadItem")
	arg0_8.rowHeight = arg0_8.headItem.rect.height
	arg0_8.maxRowHeight = 853.5
	arg0_8.emptyPage = BaseEmptyListPage.New(arg0_8._tf:Find("Adapt/Right/ViewPort"), arg0_8.event)
end

function var0_0.onBackPressed(arg0_9)
	triggerButton(arg0_9.backBtn)
end

function var0_0.addBtnListener(arg0_10)
	onButton(arg0_10, arg0_10.backBtn, function()
		arg0_10:closeView()
	end, SFX_CANCEL)
	onButton(arg0_10, arg0_10.additionDetailBtn, function()
		arg0_10:emit(TechnologyConst.OPEN_ALL_BUFF_DETAIL)
	end)
	onToggle(arg0_10, arg0_10.switchBtn, function(arg0_13)
		if arg0_13 then
			setActive(arg0_10.pointTF, false)
			arg0_10:OverlayPanel(arg0_10.blurPanel)
			arg0_10:emit(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER)
		else
			setActive(arg0_10.pointTF, true)
			arg0_10:UnOverlayPanel(arg0_10.blurPanel, arg0_10._tf)
			arg0_10:emit(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.helpBtn, function()
		if pg.gametip.help_technologytree then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_technologytree.tip
			})
		end
	end, SFX_PANEL)
end

function var0_0.initNationToggleUIList(arg0_15)
	arg0_15.nationAllToggle = nil
	arg0_15.nationAllToggleCom = nil
	arg0_15.nationMetaToggle = arg0_15._tf:Find("Adapt/Left/MetaToggle")
	arg0_15.nationMetaToggleCom = GetComponent(arg0_15.nationMetaToggle, "Toggle")
	arg0_15.nationMotToggle = arg0_15._tf:Find("Adapt/Left/MotToggle")
	arg0_15.nationMotToggleCom = GetComponent(arg0_15.nationMotToggle, "Toggle")

	setActive(arg0_15.nationMetaToggle, not LOCK_TEC_META)

	if LOCK_TEC_META then
		local var0_15 = arg0_15._tf:Find("Adapt/Left/Scroll View")

		var0_15.offsetMin = Vector2.New(var0_15.offsetMin.x, 0)
	end

	local var1_15 = UIItemList.New(arg0_15.leftContainer, arg0_15.selectNationItem)

	var1_15:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			arg2_16:Find("UnSelectedImg"):GetComponent("Image").sprite, arg2_16:Find("SelectedImg"):GetComponent("Image").sprite = TechnologyConst.GetNationSpriteByIndex(arg1_16 + 1)

			if arg1_16 == 0 then
				arg0_15.nationAllToggle = arg2_16
				arg0_15.nationAllToggleCom = GetComponent(arg2_16, "Toggle")
				arg0_15.nationAllToggleCom.interactable = false

				triggerToggle(arg2_16, true)
			else
				arg0_15.nationToggleList[arg1_16] = arg2_16

				triggerToggle(arg2_16, false)
			end

			setActive(arg2_16, true)
		end
	end)
	var1_15:align(#TechnologyConst.NationResName)
	setActive(arg0_15.nationMotToggle, not LOCK_TEC_MOT)

	if not LOCK_TEC_MOT then
		setParent(arg0_15.nationMotToggle, arg0_15.leftContainer)
	end

	onToggle(arg0_15, arg0_15.nationAllToggle, function(arg0_17)
		if arg0_17 == true then
			arg0_15.lastNationTrige = var0_0.NationTrige.All
			arg0_15.nationAllToggleCom.interactable = false
			arg0_15.nationSelectedCount = 0
			arg0_15.nationSelectedList = {}

			arg0_15:updateTecItemList()
			arg0_15:updateNationToggleUIList()
		else
			arg0_15.nationAllToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.nationMetaToggle, function(arg0_18)
		if arg0_18 == true then
			arg0_15.lastNationTrige = var0_0.NationTrige.Meta
			arg0_15.nationMetaToggleCom.interactable = false
			arg0_15.nationSelectedCount = 0
			arg0_15.nationSelectedList = {}

			arg0_15:updateTecItemList()
			arg0_15:updateNationToggleUIList()
		else
			arg0_15.nationMetaToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0_15, arg0_15.nationMotToggle, function(arg0_19)
		if arg0_19 == true then
			arg0_15.lastNationTrige = var0_0.NationTrige.Mot
			arg0_15.nationMotToggleCom.interactable = false
			arg0_15.nationSelectedCount = 0
			arg0_15.nationSelectedList = {}

			arg0_15:updateTecItemList()
			arg0_15:updateNationToggleUIList()
		else
			arg0_15.nationMotToggleCom.interactable = true
		end
	end, SFX_PANEL)

	for iter0_15, iter1_15 in ipairs(arg0_15.nationToggleList) do
		onToggle(arg0_15, iter1_15, function(arg0_20)
			if arg0_20 == true then
				arg0_15.lastNationTrige = var0_0.NationTrige.Other
				arg0_15.nationSelectedCount = arg0_15.nationSelectedCount + 1

				table.insert(arg0_15.nationSelectedList, TechnologyConst.NationOrder[iter0_15])

				if arg0_15.nationSelectedCount < #arg0_15.nationToggleList then
					arg0_15:updateNationToggleUIList()
					arg0_15:updateTecItemList()
				elseif arg0_15.nationSelectedCount == #arg0_15.nationToggleList then
					arg0_15:updateNationToggleUIList()
				end
			elseif arg0_15.nationSelectedCount > 0 then
				arg0_15.nationSelectedCount = arg0_15.nationSelectedCount - 1

				local var0_20 = table.indexof(arg0_15.nationSelectedList, TechnologyConst.NationOrder[iter0_15], 1)

				if var0_20 then
					table.remove(arg0_15.nationSelectedList, var0_20)
				end

				if arg0_15.nationSelectedCount > 0 then
					arg0_15:updateNationToggleUIList()
					arg0_15:updateTecItemList()
				elseif arg0_15.nationSelectedCount == 0 then
					arg0_15:updateNationToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateNationToggleUIList(arg0_21)
	if arg0_21.lastNationTrige == var0_0.NationTrige.All then
		_.each(arg0_21.nationToggleList, function(arg0_22)
			triggerToggle(arg0_22, false)
			onNextTick(function()
				local var0_23 = arg0_22:Find("UnSelectedImg")

				setActive(var0_23, true)
			end)
		end)
		triggerToggle(arg0_21.nationMetaToggle, false)
		triggerToggle(arg0_21.nationMotToggle, false)
	elseif arg0_21.lastNationTrige == var0_0.NationTrige.Meta then
		triggerToggle(arg0_21.nationAllToggle, false)
		_.each(arg0_21.nationToggleList, function(arg0_24)
			triggerToggle(arg0_24, false)
		end)
		triggerToggle(arg0_21.nationMotToggle, false)
	elseif arg0_21.lastNationTrige == var0_0.NationTrige.Mot then
		triggerToggle(arg0_21.nationAllToggle, false)
		_.each(arg0_21.nationToggleList, function(arg0_25)
			triggerToggle(arg0_25, false)
		end)
		triggerToggle(arg0_21.nationMetaToggle, false)
	elseif arg0_21.lastNationTrige == var0_0.NationTrige.Other then
		if arg0_21.nationSelectedCount <= 0 or arg0_21.nationSelectedCount >= #arg0_21.nationToggleList then
			triggerToggle(arg0_21.nationAllToggle, true)
		else
			triggerToggle(arg0_21.nationAllToggle, false)
			triggerToggle(arg0_21.nationMetaToggle, false)
			triggerToggle(arg0_21.nationMotToggle, false)
		end
	end
end

function var0_0.initTypeToggleUIList(arg0_26)
	arg0_26.typeAllToggle = nil
	arg0_26.typeAllToggleCom = nil

	local var0_26 = UIItemList.New(arg0_26.bottomContainer, arg0_26.selectTypeItem)

	var0_26:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			arg2_27:Find("UnSelectedImg"):GetComponent("Image").sprite, arg2_27:Find("SelectedImg"):GetComponent("Image").sprite = TechnologyConst.GetTypeSpriteByIndex(arg1_27 + 1)
			arg1_27 = arg1_27 + 1

			if arg1_27 == #TechnologyConst.TypeResName then
				arg0_26.typeAllToggle = arg2_27
				arg0_26.typeAllToggleCom = GetComponent(arg2_27, "Toggle")
				arg0_26.typeAllToggleCom.interactable = false

				triggerToggle(arg2_27, true)
			else
				arg0_26.typeToggleList[arg1_27] = arg2_27

				triggerToggle(arg2_27, false)
			end

			setActive(arg2_27, true)
		end
	end)
	var0_26:align(#TechnologyConst.TypeResName)
	onToggle(arg0_26, arg0_26.typeAllToggle, function(arg0_28)
		arg0_26.lastTypeTrige = var0_0.TypeTrige.All

		if arg0_28 == true then
			arg0_26.typeAllToggleCom.interactable = false
			arg0_26.typeSelectedCount = 0
			arg0_26.typeSelectedList = {}

			arg0_26:updateTecItemList()
			arg0_26:updateTypeToggleUIList()
		else
			arg0_26.typeAllToggleCom.interactable = true
		end
	end)

	for iter0_26, iter1_26 in ipairs(arg0_26.typeToggleList) do
		onToggle(arg0_26, iter1_26, function(arg0_29)
			arg0_26.lastTypeTrige = var0_0.TypeTrige.Other

			if arg0_29 == true then
				arg0_26.typeSelectedCount = arg0_26.typeSelectedCount + 1

				for iter0_29, iter1_29 in ipairs(TechnologyConst.TypeOrder[iter0_26]) do
					table.insert(arg0_26.typeSelectedList, iter1_29)
				end

				if arg0_26.typeSelectedCount < #arg0_26.typeToggleList then
					arg0_26:updateTypeToggleUIList()
					arg0_26:updateTecItemList()
				elseif arg0_26.typeSelectedCount == #arg0_26.typeToggleList then
					arg0_26:updateTypeToggleUIList()
				end
			elseif arg0_26.typeSelectedCount > 0 then
				arg0_26.typeSelectedCount = arg0_26.typeSelectedCount - 1

				for iter2_29, iter3_29 in ipairs(TechnologyConst.TypeOrder[iter0_26]) do
					local var0_29 = table.indexof(arg0_26.typeSelectedList, iter3_29, 1)

					if var0_29 then
						table.remove(arg0_26.typeSelectedList, var0_29)
					end
				end

				if arg0_26.typeSelectedCount > 0 then
					arg0_26:updateTypeToggleUIList()
					arg0_26:updateTecItemList()
				elseif arg0_26.typeSelectedCount == 0 then
					arg0_26:updateTypeToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateTypeToggleUIList(arg0_30)
	if arg0_30.lastTypeTrige == var0_0.TypeTrige.All then
		_.each(arg0_30.typeToggleList, function(arg0_31)
			triggerToggle(arg0_31, false)
			onNextTick(function()
				local var0_32 = arg0_31:Find("UnSelectedImg")

				setActive(var0_32, true)
			end)
		end)
	elseif arg0_30.lastTypeTrige == var0_0.TypeTrige.Other then
		if arg0_30.typeSelectedCount <= 0 or arg0_30.typeSelectedCount >= #arg0_30.typeToggleList then
			triggerToggle(arg0_30.typeAllToggle, true)
		else
			triggerToggle(arg0_30.typeAllToggle, false)
		end
	end
end

function var0_0.updatePreferredHeight(arg0_33, arg1_33, arg2_33)
	local var0_33 = tf(arg1_33):Find("ShipScrollView/ShipContainer")
	local var1_33 = arg2_33 + arg0_33.rowHeight

	arg0_33.rightLayoutGroup.padding.bottom = arg0_33.rightLayoutGroup.padding.bottom + var1_33 - GetComponent(arg1_33, "LayoutElement").preferredHeight
	GetComponent(arg1_33, "LayoutElement").preferredHeight = var1_33

	local var2_33 = tf(arg1_33):Find("ClickBtn/ArrowBtn")

	setLocalRotation(var2_33, {
		z = arg2_33 > 0 and 0 or 180
	})
end

function var0_0.onClassItemUpdate(arg0_34, arg1_34, arg2_34)
	local var0_34 = tf(arg2_34):Find("Name/NameText")
	local var1_34 = tf(arg2_34):Find("CampBG")
	local var2_34 = tf(arg2_34):Find("Level/LevelImg")
	local var3_34 = tf(arg2_34):Find("Level/TypeTextImg")
	local var4_34 = tf(arg2_34):Find("ClickBtn")
	local var5_34 = var4_34:Find("ArrowBtn")
	local var6_34 = arg0_34:getClassConfigForShow(arg1_34 + 1)
	local var7_34 = var6_34.name
	local var8_34 = var6_34.nation
	local var9_34 = var6_34.shiptype
	local var10_34 = var6_34.t_level
	local var11_34 = var6_34.ships
	local var12_34 = arg0_34:isMetaOn()
	local var13_34 = arg0_34:isMotOn()

	setText(var0_34, var7_34)

	local var14_34

	if var12_34 or var13_34 then
		setActive(var2_34, false)
		setActive(var3_34, false)

		if var12_34 then
			var14_34 = GetSpriteFromAtlas("TecNation", "bg_nation_meta")
		elseif var13_34 then
			var14_34 = GetSpriteFromAtlas("TecNation", "bg_nation_mot")
		end
	else
		setImageSprite(var2_34, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. var10_34), true)
		setImageSprite(var3_34, GetSpriteFromAtlas("ShipType", "ch_title_" .. var9_34), true)
		setActive(var2_34, true)
		setActive(var3_34, true)

		var14_34 = GetSpriteFromAtlas("TecNation", "bg_nation_" .. var8_34)
	end

	setImageSprite(var1_34, var14_34)

	local var15_34 = tf(arg2_34):Find("ClickBtn/ArrowBtn")

	setLocalRotation(var15_34, {
		z = 180
	})

	local var16_34 = tf(arg2_34):Find("ShipScrollView/ShipContainer")

	arg0_34:updateShipItemList(var11_34, var16_34)

	arg0_34.expanded[arg1_34] = 0

	arg0_34:updatePreferredHeight(arg2_34, arg0_34.expanded[arg1_34])
	setActive(var4_34, #var11_34 > 5)
	onButton(arg0_34, var4_34, function()
		if defaultValue(arg0_34.expanded[arg1_34], 0) > 0 then
			arg0_34.expanded[arg1_34] = 0
		else
			arg0_34.expanded[arg1_34] = var16_34.rect.height - arg0_34.rowHeight
		end

		arg0_34:updatePreferredHeight(arg2_34, arg0_34.expanded[arg1_34])
	end, SFX_PANEL)
end

function var0_0.onClassItemReturn(arg0_36, arg1_36, arg2_36)
	if defaultValue(arg0_36.expanded[arg1_36], 0) > 0 then
		arg0_36.expanded[arg1_36] = 0

		arg0_36:updatePreferredHeight(arg2_36, arg0_36.expanded[arg1_36])
	end
end

function var0_0.initTecClassUIList(arg0_37)
	function arg0_37.rightLSC.onUpdateItem(arg0_38, arg1_38)
		arg0_37:onClassItemUpdate(arg0_38, arg1_38)
	end

	function arg0_37.rightLSC.onReturnItem(arg0_39, arg1_39)
		arg0_37:onClassItemReturn(arg0_39, arg1_39)
	end
end

function var0_0.updateTecItemList(arg0_40)
	arg0_40.expanded = {}

	local var0_40 = arg0_40:getClassIDListForShow()

	if arg0_40.rightLSC.totalCount ~= 0 then
		arg0_40.rightLSC:SetTotalCount(0)
	end

	arg0_40.rightLSC:SetTotalCount(#var0_40)
	arg0_40.rightLSC:BeginLayout()
	arg0_40.rightLSC:EndLayout()

	local var1_40 = #var0_40

	if var1_40 <= 0 then
		arg0_40.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0_40.emptyPage:ExecuteAction("SetEmptyText", i18n("technology_filter_placeholder"))
	elseif var1_40 > 0 and arg0_40.emptyPage:GetLoaded() then
		arg0_40.emptyPage:ExecuteAction("ShowOrHide", false)
	end
end

function var0_0.updateShipItemList(arg0_41, arg1_41, arg2_41)
	local var0_41 = UIItemList.New(arg2_41, arg0_41.headItem)

	var0_41:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = arg2_42:Find("BaseImg")
			local var1_42 = arg2_42:Find("BaseImg/CharImg")
			local var2_42 = arg2_42:Find("NameBG")
			local var3_42 = var2_42:Find("NameText")
			local var4_42 = arg2_42:Find("Frame")
			local var5_42 = arg2_42:Find("Star")
			local var6_42 = arg2_42:Find("Star/StarImg")
			local var7_42 = arg2_42:Find("Info")
			local var8_42 = var7_42:Find("PointText")
			local var9_42 = var7_42:Find("BuffGet")
			local var10_42 = var9_42:Find("TypeIcon")
			local var11_42 = var10_42:Find("AttrIcon")
			local var12_42 = var10_42:Find("NumText")
			local var13_42 = var7_42:Find("Lock")
			local var14_42 = var7_42:Find("BuffComplete")
			local var15_42 = var14_42:Find("TypeIcon")
			local var16_42 = var15_42:Find("AttrIcon")
			local var17_42 = var15_42:Find("NumText")
			local var18_42 = arg2_42:Find("BottomBG")
			local var19_42 = arg2_42:Find("BottomBG/StatusUnknow")
			local var20_42 = arg2_42:Find("BottomBG/StatusResearching")
			local var21_42 = arg2_42:Find("ViewIcon")
			local var22_42 = arg2_42:Find("keyansaohguang")
			local var23_42 = arg1_41[arg1_42 + 1]

			setText(var3_42, shortenString(ShipGroup.getDefaultShipNameByGroupID(var23_42), 6))

			local var24_42 = var23_42 * 10 + 1

			setImageSprite(var0_42, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. pg.ship_data_statistics[var24_42].rarity))
			LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(var24_42), function(arg0_43)
				if arg0_43 and not arg0_41.exited then
					setImageSprite(var1_42, arg0_43, true)

					rtf(var1_42).pivot = getSpritePivot(arg0_43)
				end
			end)

			if table.indexof(arg0_41.groupIDGotList, var23_42, 1) then
				local var25_42 = pg.fleet_tech_ship_template[var23_42].add_get_shiptype[1]
				local var26_42 = pg.fleet_tech_ship_template[var23_42].add_get_attr
				local var27_42 = pg.fleet_tech_ship_template[var23_42].add_get_value

				setImageSprite(var10_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var25_42))
				setImageSprite(var11_42, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var26_42].name))
				setText(var12_42, "+" .. var27_42)
				setActive(var9_42, true)

				local var28_42 = arg0_41.collectionProxy:getShipGroup(var23_42)

				if var28_42.maxLV < TechnologyConst.SHIP_LEVEL_FOR_BUFF then
					setActive(var20_42, true)
					setActive(var19_42, false)
					setActive(var14_42, false)
					setImageSprite(var4_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
					setActive(var18_42, true)
					setActive(var21_42, true)
					setActive(var13_42, true)
					setActive(var22_42, false)

					if var28_42.star == pg.fleet_tech_ship_template[var23_42].max_star then
						setText(var8_42, "+" .. pg.fleet_tech_ship_template[var23_42].pt_get + pg.fleet_tech_ship_template[var23_42].pt_upgrage)
					else
						setText(var8_42, "+" .. pg.fleet_tech_ship_template[var23_42].pt_get)
					end
				else
					local var29_42 = pg.fleet_tech_ship_template[var23_42].add_level_shiptype[1]
					local var30_42 = pg.fleet_tech_ship_template[var23_42].add_level_attr
					local var31_42 = pg.fleet_tech_ship_template[var23_42].add_level_value

					setImageSprite(var15_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var29_42))
					setImageSprite(var16_42, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var30_42].name))
					setText(var17_42, "+" .. var31_42)
					setActive(var14_42, true)

					if var28_42.star == pg.fleet_tech_ship_template[var23_42].max_star then
						setText(var8_42, "+" .. pg.fleet_tech_ship_template[var23_42].pt_get + pg.fleet_tech_ship_template[var23_42].pt_level + pg.fleet_tech_ship_template[var23_42].pt_upgrage)
						setImageSprite(var4_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_finished"))
						setActive(var18_42, false)
						setActive(var21_42, false)
						setActive(var20_42, false)
						setActive(var19_42, false)
						setActive(var22_42, true)
					else
						setText(var8_42, "+" .. pg.fleet_tech_ship_template[var23_42].pt_get + pg.fleet_tech_ship_template[var23_42].pt_level)
						setImageSprite(var4_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
						setActive(var18_42, true)
						setActive(var21_42, true)
						setActive(var20_42, true)
						setActive(var19_42, false)
						setActive(var22_42, false)
					end

					setActive(var13_42, false)
				end

				setImageColor(var1_42, Color.New(1, 1, 1, 1))
				setActive(var2_42, true)
				setActive(var7_42, true)
				setActive(var5_42, true)

				if var28_42.star == pg.fleet_tech_ship_template[var23_42].max_star then
					setActive(var6_42, true)
				else
					setActive(var6_42, false)
				end

				onButton(arg0_41, arg2_42, function()
					arg0_41:emit(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, var23_42, var28_42.maxLV, var28_42.star)
				end)
			else
				setImageSprite(var4_42, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
				setImageColor(var1_42, Color.New(0, 0, 0, 0.4))
				setActive(var21_42, false)
				setActive(var2_42, false)
				setActive(var7_42, false)
				setActive(var20_42, false)
				setActive(var19_42, true)
				setActive(var5_42, false)
				setActive(var13_42, false)
				setActive(var22_42, false)
				removeOnButton(arg2_42)
			end

			setActive(arg2_42, true)
		end
	end)
	var0_41:align(#arg1_41)
end

function var0_0.getClassIDListForShow(arg0_45, arg1_45, arg2_45)
	arg1_45 = arg1_45 or arg0_45.nationSelectedList
	arg2_45 = arg2_45 or arg0_45.typeSelectedList

	local var0_45 = arg0_45:isMetaOn()
	local var1_45 = arg0_45:isMotOn()

	if not var0_45 and not var1_45 then
		local var2_45 = TechnologyConst.GetOrderClassList()
		local var3_45

		if #arg1_45 == 0 and #arg2_45 == 0 then
			var3_45 = var2_45
		else
			local var4_45 = #arg1_45 == 0 and TechnologyConst.NationOrder or arg1_45

			var3_45 = _.select(var2_45, function(arg0_46)
				local var0_46 = pg.fleet_tech_ship_class[arg0_46].nation

				if table.contains(var4_45, var0_46) then
					if #arg0_45.typeSelectedList == 0 then
						return true
					else
						local var1_46 = pg.fleet_tech_ship_class[arg0_46].shiptype

						return table.contains(arg0_45.typeSelectedList, var1_46)
					end
				else
					return false
				end
			end)
		end

		arg0_45.curClassIDList = var3_45

		return var3_45
	elseif var0_45 then
		arg0_45.curMetaClassIDList = TechnologyConst.GetOrderMetaClassList(arg2_45)

		return arg0_45.curMetaClassIDList
	elseif var1_45 then
		arg0_45.curMotClassIDList = TechnologyConst.GetOrderMotClassList(arg2_45)

		return arg0_45.curMotClassIDList
	end
end

function var0_0.getClassConfigForShow(arg0_47, arg1_47)
	local var0_47 = arg0_47:isMetaOn()
	local var1_47 = arg0_47:isMotOn()

	if not var0_47 and not var1_47 then
		local var2_47 = arg0_47.curClassIDList[arg1_47]

		return pg.fleet_tech_ship_class[var2_47]
	elseif var0_47 then
		local var3_47 = arg0_47.curMetaClassIDList[arg1_47]

		return TechnologyConst.GetMetaClassConfig(var3_47, arg0_47.typeSelectedList)
	elseif var1_47 then
		local var4_47 = arg0_47.curMotClassIDList[arg1_47]

		return TechnologyConst.GetMotClassConfig(var4_47, arg0_47.typeSelectedList)
	end
end

function var0_0.isMetaOn(arg0_48)
	if arg0_48.lastNationTrige == var0_0.NationTrige.All then
		return false
	elseif arg0_48.lastNationTrige == var0_0.NationTrige.Mot then
		return false
	end

	return arg0_48.nationMetaToggleCom.isOn
end

function var0_0.isMotOn(arg0_49)
	if arg0_49.lastNationTrige == var0_0.NationTrige.All then
		return false
	elseif arg0_49.lastNationTrige == var0_0.NationTrige.Meta then
		return false
	end

	return arg0_49.nationMotToggleCom.isOn
end

return var0_0
