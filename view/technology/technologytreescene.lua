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

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:initNationToggleUIList()
	arg0_2:initTecClassUIList()
end

function var0_0.didEnter(arg0_3)
	arg0_3:initTypeToggleUIList()
	arg0_3:updateTecItemList()
	arg0_3:addBtnListener()
	setText(arg0_3.pointNumText, arg0_3.point)
	arg0_3:updateRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())

	if not PlayerPrefs.HasKey("first_comein_technologytree") then
		triggerButton(arg0_3.helpBtn)
		PlayerPrefs.SetInt("first_comein_technologytree", 1)
		PlayerPrefs.Save()
	end
end

function var0_0.updateRedPoint(arg0_4, arg1_4)
	setActive(arg0_4.redPointImg, arg1_4)
end

function var0_0.willExit(arg0_5)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_5.blurPanel, arg0_5._tf)

	arg0_5.rightLSC.onReturnItem = nil

	if arg0_5.emptyPage then
		arg0_5.emptyPage:Destroy()

		arg0_5.emptyPage = nil
	end
end

function var0_0.initData(arg0_6)
	TechnologyConst.CreateMetaClassConfig()

	arg0_6.nationToggleList = {}
	arg0_6.typeToggleList = {}
	arg0_6.nationSelectedList = {}
	arg0_6.typeSelectedList = {}
	arg0_6.nationSelectedCount = 0
	arg0_6.typeSelectedCount = 0
	arg0_6.lastNationTrige = nil
	arg0_6.lastTypeTrige = nil
	arg0_6.countInEveryRow = 5
	arg0_6.collectionProxy = getProxy(CollectionProxy)
	arg0_6.nationProxy = getProxy(TechnologyNationProxy)
	arg0_6.curClassIDList = nil
	arg0_6.groupIDGotList = {}

	local var0_6 = arg0_6.collectionProxy.shipGroups

	for iter0_6, iter1_6 in pairs(var0_6) do
		arg0_6.groupIDGotList[#arg0_6.groupIDGotList + 1] = iter1_6.id
	end

	arg0_6.point = arg0_6.nationProxy:getPoint()
	arg0_6.expanded = {}
end

function var0_0.findUI(arg0_7)
	arg0_7.nationAllToggle = nil
	arg0_7.nationAllToggleCom = nil
	arg0_7.nationMetaToggle = arg0_7:findTF("Adapt/Left/MetaToggle")
	arg0_7.nationMetaToggleCom = GetComponent(arg0_7.nationMetaToggle, "Toggle")
	arg0_7.nationMotToggle = arg0_7:findTF("Adapt/Left/MotToggle")
	arg0_7.nationMotToggleCom = GetComponent(arg0_7.nationMotToggle, "Toggle")
	arg0_7.typeAllToggle = nil
	arg0_7.typeAllToggleCom = nil
	arg0_7.blurPanel = arg0_7:findTF("blur_panel")
	arg0_7.adapt = arg0_7:findTF("adapt", arg0_7.blurPanel)
	arg0_7.backBtn = arg0_7:findTF("top/back", arg0_7.adapt)
	arg0_7.homeBtn = arg0_7:findTF("top/option", arg0_7.adapt)
	arg0_7.additionDetailBtn = arg0_7:findTF("AdditionDetailBtn", arg0_7.adapt)
	arg0_7.switchBtn = arg0_7:findTF("SwitchToggle", arg0_7.adapt)
	arg0_7.pointTF = arg0_7:findTF("PointCount", arg0_7.adapt)
	arg0_7.pointNumText = arg0_7:findTF("PointCount/PointNumText", arg0_7.adapt)
	arg0_7.redPointImg = arg0_7:findTF("RedPoint", arg0_7.switchBtn)
	arg0_7.helpBtn = arg0_7:findTF("help_btn", arg0_7.adapt)
	arg0_7.leftContainer = arg0_7:findTF("Adapt/Left/Scroll View/Content")
	arg0_7.selectNationItem = arg0_7:findTF("SelectCampItem")
	arg0_7.bottomContainer = arg0_7:findTF("Adapt/Bottom/Content")
	arg0_7.selectTypeItem = arg0_7:findTF("SelectTypeItem")
	arg0_7.rightContainer = arg0_7:findTF("Adapt/Right/Container")
	arg0_7.rightLSC = arg0_7.rightContainer:GetComponent("LScrollRect")
	arg0_7.rightLayoutGroup = arg0_7.rightContainer:GetComponent("VerticalLayoutGroup")
	arg0_7.headItem = arg0_7:findTF("HeadItem")
	arg0_7.rowHeight = arg0_7.headItem.rect.height
	arg0_7.maxRowHeight = 853.5
	arg0_7.emptyPage = BaseEmptyListPage.New(arg0_7:findTF("Adapt/Right/ViewPort"), arg0_7.event)
end

function var0_0.onBackPressed(arg0_8)
	triggerButton(arg0_8.backBtn)
end

function var0_0.addBtnListener(arg0_9)
	onButton(arg0_9, arg0_9.backBtn, function()
		arg0_9:closeView()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.additionDetailBtn, function()
		arg0_9:emit(TechnologyConst.OPEN_ALL_BUFF_DETAIL)
	end)
	onToggle(arg0_9, arg0_9.switchBtn, function(arg0_12)
		if arg0_12 then
			setActive(arg0_9.pointTF, false)
			pg.UIMgr.GetInstance():OverlayPanel(arg0_9.blurPanel, {
				weight = LayerWeightConst.SECOND_LAYER
			})
			arg0_9:emit(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER)
		else
			setActive(arg0_9.pointTF, true)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0_9.blurPanel, arg0_9._tf)
			arg0_9:emit(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.helpBtn, function()
		if pg.gametip.help_technologytree then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_technologytree.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0_0.initNationToggleUIList(arg0_14)
	arg0_14.nationAllToggle = nil
	arg0_14.nationAllToggleCom = nil
	arg0_14.nationMetaToggle = arg0_14:findTF("Adapt/Left/MetaToggle")
	arg0_14.nationMetaToggleCom = GetComponent(arg0_14.nationMetaToggle, "Toggle")
	arg0_14.nationMotToggle = arg0_14:findTF("Adapt/Left/MotToggle")
	arg0_14.nationMotToggleCom = GetComponent(arg0_14.nationMotToggle, "Toggle")

	setActive(arg0_14.nationMetaToggle, not LOCK_TEC_META)

	if LOCK_TEC_META then
		local var0_14 = arg0_14:findTF("Adapt/Left/Scroll View")

		var0_14.offsetMin = Vector2.New(var0_14.offsetMin.x, 0)
	end

	local var1_14 = UIItemList.New(arg0_14.leftContainer, arg0_14.selectNationItem)

	var1_14:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventUpdate then
			arg0_14:findTF("UnSelectedImg", arg2_15):GetComponent("Image").sprite, arg0_14:findTF("SelectedImg", arg2_15):GetComponent("Image").sprite = TechnologyConst.GetNationSpriteByIndex(arg1_15 + 1)

			if arg1_15 == 0 then
				arg0_14.nationAllToggle = arg2_15
				arg0_14.nationAllToggleCom = GetComponent(arg2_15, "Toggle")
				arg0_14.nationAllToggleCom.interactable = false

				triggerToggle(arg2_15, true)
			else
				arg0_14.nationToggleList[arg1_15] = arg2_15

				triggerToggle(arg2_15, false)
			end

			setActive(arg2_15, true)
		end
	end)
	var1_14:align(#TechnologyConst.NationResName)
	setActive(arg0_14.nationMotToggle, not LOCK_TEC_MOT)

	if not LOCK_TEC_MOT then
		setParent(arg0_14.nationMotToggle, arg0_14.leftContainer)
	end

	onToggle(arg0_14, arg0_14.nationAllToggle, function(arg0_16)
		if arg0_16 == true then
			arg0_14.lastNationTrige = var0_0.NationTrige.All
			arg0_14.nationAllToggleCom.interactable = false
			arg0_14.nationSelectedCount = 0
			arg0_14.nationSelectedList = {}

			arg0_14:updateTecItemList()
			arg0_14:updateNationToggleUIList()
		else
			arg0_14.nationAllToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0_14, arg0_14.nationMetaToggle, function(arg0_17)
		if arg0_17 == true then
			arg0_14.lastNationTrige = var0_0.NationTrige.Meta
			arg0_14.nationMetaToggleCom.interactable = false
			arg0_14.nationSelectedCount = 0
			arg0_14.nationSelectedList = {}

			arg0_14:updateTecItemList()
			arg0_14:updateNationToggleUIList()
		else
			arg0_14.nationMetaToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0_14, arg0_14.nationMotToggle, function(arg0_18)
		if arg0_18 == true then
			arg0_14.lastNationTrige = var0_0.NationTrige.Mot
			arg0_14.nationMotToggleCom.interactable = false
			arg0_14.nationSelectedCount = 0
			arg0_14.nationSelectedList = {}

			arg0_14:updateTecItemList()
			arg0_14:updateNationToggleUIList()
		else
			arg0_14.nationMotToggleCom.interactable = true
		end
	end, SFX_PANEL)

	for iter0_14, iter1_14 in ipairs(arg0_14.nationToggleList) do
		onToggle(arg0_14, iter1_14, function(arg0_19)
			if arg0_19 == true then
				arg0_14.lastNationTrige = var0_0.NationTrige.Other
				arg0_14.nationSelectedCount = arg0_14.nationSelectedCount + 1

				table.insert(arg0_14.nationSelectedList, TechnologyConst.NationOrder[iter0_14])

				if arg0_14.nationSelectedCount < #arg0_14.nationToggleList then
					arg0_14:updateNationToggleUIList()
					arg0_14:updateTecItemList()
				elseif arg0_14.nationSelectedCount == #arg0_14.nationToggleList then
					arg0_14:updateNationToggleUIList()
				end
			elseif arg0_14.nationSelectedCount > 0 then
				arg0_14.nationSelectedCount = arg0_14.nationSelectedCount - 1

				local var0_19 = table.indexof(arg0_14.nationSelectedList, TechnologyConst.NationOrder[iter0_14], 1)

				if var0_19 then
					table.remove(arg0_14.nationSelectedList, var0_19)
				end

				if arg0_14.nationSelectedCount > 0 then
					arg0_14:updateNationToggleUIList()
					arg0_14:updateTecItemList()
				elseif arg0_14.nationSelectedCount == 0 then
					arg0_14:updateNationToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateNationToggleUIList(arg0_20)
	if arg0_20.lastNationTrige == var0_0.NationTrige.All then
		_.each(arg0_20.nationToggleList, function(arg0_21)
			triggerToggle(arg0_21, false)
			onNextTick(function()
				local var0_22 = arg0_20:findTF("UnSelectedImg", arg0_21)

				setActive(var0_22, true)
			end)
		end)
		triggerToggle(arg0_20.nationMetaToggle, false)
		triggerToggle(arg0_20.nationMotToggle, false)
	elseif arg0_20.lastNationTrige == var0_0.NationTrige.Meta then
		triggerToggle(arg0_20.nationAllToggle, false)
		_.each(arg0_20.nationToggleList, function(arg0_23)
			triggerToggle(arg0_23, false)
		end)
		triggerToggle(arg0_20.nationMotToggle, false)
	elseif arg0_20.lastNationTrige == var0_0.NationTrige.Mot then
		triggerToggle(arg0_20.nationAllToggle, false)
		_.each(arg0_20.nationToggleList, function(arg0_24)
			triggerToggle(arg0_24, false)
		end)
		triggerToggle(arg0_20.nationMetaToggle, false)
	elseif arg0_20.lastNationTrige == var0_0.NationTrige.Other then
		if arg0_20.nationSelectedCount <= 0 or arg0_20.nationSelectedCount >= #arg0_20.nationToggleList then
			triggerToggle(arg0_20.nationAllToggle, true)
		else
			triggerToggle(arg0_20.nationAllToggle, false)
			triggerToggle(arg0_20.nationMetaToggle, false)
			triggerToggle(arg0_20.nationMotToggle, false)
		end
	end
end

function var0_0.initTypeToggleUIList(arg0_25)
	arg0_25.typeAllToggle = nil
	arg0_25.typeAllToggleCom = nil

	local var0_25 = UIItemList.New(arg0_25.bottomContainer, arg0_25.selectTypeItem)

	var0_25:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			arg0_25:findTF("UnSelectedImg", arg2_26):GetComponent("Image").sprite, arg0_25:findTF("SelectedImg", arg2_26):GetComponent("Image").sprite = TechnologyConst.GetTypeSpriteByIndex(arg1_26 + 1)
			arg1_26 = arg1_26 + 1

			if arg1_26 == #TechnologyConst.TypeResName then
				arg0_25.typeAllToggle = arg2_26
				arg0_25.typeAllToggleCom = GetComponent(arg2_26, "Toggle")
				arg0_25.typeAllToggleCom.interactable = false

				triggerToggle(arg2_26, true)
			else
				arg0_25.typeToggleList[arg1_26] = arg2_26

				triggerToggle(arg2_26, false)
			end

			setActive(arg2_26, true)
		end
	end)
	var0_25:align(#TechnologyConst.TypeResName)
	onToggle(arg0_25, arg0_25.typeAllToggle, function(arg0_27)
		arg0_25.lastTypeTrige = var0_0.TypeTrige.All

		if arg0_27 == true then
			arg0_25.typeAllToggleCom.interactable = false
			arg0_25.typeSelectedCount = 0
			arg0_25.typeSelectedList = {}

			arg0_25:updateTecItemList()
			arg0_25:updateTypeToggleUIList()
		else
			arg0_25.typeAllToggleCom.interactable = true
		end
	end)

	for iter0_25, iter1_25 in ipairs(arg0_25.typeToggleList) do
		onToggle(arg0_25, iter1_25, function(arg0_28)
			arg0_25.lastTypeTrige = var0_0.TypeTrige.Other

			if arg0_28 == true then
				arg0_25.typeSelectedCount = arg0_25.typeSelectedCount + 1

				for iter0_28, iter1_28 in ipairs(TechnologyConst.TypeOrder[iter0_25]) do
					table.insert(arg0_25.typeSelectedList, iter1_28)
				end

				if arg0_25.typeSelectedCount < #arg0_25.typeToggleList then
					arg0_25:updateTypeToggleUIList()
					arg0_25:updateTecItemList()
				elseif arg0_25.typeSelectedCount == #arg0_25.typeToggleList then
					arg0_25:updateTypeToggleUIList()
				end
			elseif arg0_25.typeSelectedCount > 0 then
				arg0_25.typeSelectedCount = arg0_25.typeSelectedCount - 1

				for iter2_28, iter3_28 in ipairs(TechnologyConst.TypeOrder[iter0_25]) do
					local var0_28 = table.indexof(arg0_25.typeSelectedList, iter3_28, 1)

					if var0_28 then
						table.remove(arg0_25.typeSelectedList, var0_28)
					end
				end

				if arg0_25.typeSelectedCount > 0 then
					arg0_25:updateTypeToggleUIList()
					arg0_25:updateTecItemList()
				elseif arg0_25.typeSelectedCount == 0 then
					arg0_25:updateTypeToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.updateTypeToggleUIList(arg0_29)
	if arg0_29.lastTypeTrige == var0_0.TypeTrige.All then
		_.each(arg0_29.typeToggleList, function(arg0_30)
			triggerToggle(arg0_30, false)
			onNextTick(function()
				local var0_31 = arg0_29:findTF("UnSelectedImg", arg0_30)

				setActive(var0_31, true)
			end)
		end)
	elseif arg0_29.lastTypeTrige == var0_0.TypeTrige.Other then
		if arg0_29.typeSelectedCount <= 0 or arg0_29.typeSelectedCount >= #arg0_29.typeToggleList then
			triggerToggle(arg0_29.typeAllToggle, true)
		else
			triggerToggle(arg0_29.typeAllToggle, false)
		end
	end
end

function var0_0.updatePreferredHeight(arg0_32, arg1_32, arg2_32)
	local var0_32 = tf(arg1_32):Find("ShipScrollView/ShipContainer")
	local var1_32 = arg2_32 + arg0_32.rowHeight

	arg0_32.rightLayoutGroup.padding.bottom = arg0_32.rightLayoutGroup.padding.bottom + var1_32 - GetComponent(arg1_32, "LayoutElement").preferredHeight
	GetComponent(arg1_32, "LayoutElement").preferredHeight = var1_32

	local var2_32 = tf(arg1_32):Find("ClickBtn/ArrowBtn")

	setLocalRotation(var2_32, {
		z = arg2_32 > 0 and 0 or 180
	})
end

function var0_0.onClassItemUpdate(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33:findTF("Name/NameText", arg2_33)
	local var1_33 = arg0_33:findTF("CampBG", arg2_33)
	local var2_33 = arg0_33:findTF("Level/LevelImg", arg2_33)
	local var3_33 = arg0_33:findTF("Level/TypeTextImg", arg2_33)
	local var4_33 = arg0_33:findTF("ClickBtn", arg2_33)
	local var5_33 = arg0_33:findTF("ArrowBtn", var4_33)
	local var6_33 = arg0_33:getClassConfigForShow(arg1_33 + 1)
	local var7_33 = var6_33.name
	local var8_33 = var6_33.nation
	local var9_33 = var6_33.shiptype
	local var10_33 = var6_33.t_level
	local var11_33 = var6_33.ships
	local var12_33 = arg0_33:isMetaOn()
	local var13_33 = arg0_33:isMotOn()

	setText(var0_33, var7_33)

	local var14_33

	if var12_33 or var13_33 then
		setActive(var2_33, false)
		setActive(var3_33, false)

		if var12_33 then
			var14_33 = GetSpriteFromAtlas("TecNation", "bg_nation_meta")
		elseif var13_33 then
			var14_33 = GetSpriteFromAtlas("TecNation", "bg_nation_mot")
		end
	else
		setImageSprite(var2_33, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. var10_33), true)
		setImageSprite(var3_33, GetSpriteFromAtlas("ShipType", "ch_title_" .. var9_33), true)
		setActive(var2_33, true)
		setActive(var3_33, true)

		var14_33 = GetSpriteFromAtlas("TecNation", "bg_nation_" .. var8_33)
	end

	setImageSprite(var1_33, var14_33)

	local var15_33 = arg0_33:findTF("ClickBtn/ArrowBtn", arg2_33)

	setLocalRotation(var15_33, {
		z = 180
	})

	local var16_33 = arg0_33:findTF("ShipScrollView/ShipContainer", arg2_33)

	arg0_33:updateShipItemList(var11_33, var16_33)

	arg0_33.expanded[arg1_33] = 0

	arg0_33:updatePreferredHeight(arg2_33, arg0_33.expanded[arg1_33])
	setActive(var4_33, #var11_33 > 5)
	onButton(arg0_33, var4_33, function()
		if defaultValue(arg0_33.expanded[arg1_33], 0) > 0 then
			arg0_33.expanded[arg1_33] = 0
		else
			arg0_33.expanded[arg1_33] = var16_33.rect.height - arg0_33.rowHeight
		end

		arg0_33:updatePreferredHeight(arg2_33, arg0_33.expanded[arg1_33])
	end, SFX_PANEL)
end

function var0_0.onClassItemReturn(arg0_35, arg1_35, arg2_35)
	if defaultValue(arg0_35.expanded[arg1_35], 0) > 0 then
		arg0_35.expanded[arg1_35] = 0

		arg0_35:updatePreferredHeight(arg2_35, arg0_35.expanded[arg1_35])
	end
end

function var0_0.initTecClassUIList(arg0_36)
	function arg0_36.rightLSC.onUpdateItem(arg0_37, arg1_37)
		arg0_36:onClassItemUpdate(arg0_37, arg1_37)
	end

	function arg0_36.rightLSC.onReturnItem(arg0_38, arg1_38)
		arg0_36:onClassItemReturn(arg0_38, arg1_38)
	end
end

function var0_0.updateTecItemList(arg0_39)
	arg0_39.expanded = {}

	local var0_39 = arg0_39:getClassIDListForShow()

	if arg0_39.rightLSC.totalCount ~= 0 then
		arg0_39.rightLSC:SetTotalCount(0)
	end

	arg0_39.rightLSC:SetTotalCount(#var0_39)
	arg0_39.rightLSC:BeginLayout()
	arg0_39.rightLSC:EndLayout()

	local var1_39 = #var0_39

	if var1_39 <= 0 then
		arg0_39.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0_39.emptyPage:ExecuteAction("SetEmptyText", i18n("technology_filter_placeholder"))
	elseif var1_39 > 0 and arg0_39.emptyPage:GetLoaded() then
		arg0_39.emptyPage:ExecuteAction("ShowOrHide", false)
	end
end

function var0_0.updateShipItemList(arg0_40, arg1_40, arg2_40)
	local var0_40 = UIItemList.New(arg2_40, arg0_40.headItem)

	var0_40:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = arg0_40:findTF("BaseImg", arg2_41)
			local var1_41 = arg0_40:findTF("BaseImg/CharImg", arg2_41)
			local var2_41 = arg0_40:findTF("NameBG", arg2_41)
			local var3_41 = arg0_40:findTF("NameText", var2_41)
			local var4_41 = arg0_40:findTF("Frame", arg2_41)
			local var5_41 = arg0_40:findTF("Star", arg2_41)
			local var6_41 = arg0_40:findTF("Star/StarImg", arg2_41)
			local var7_41 = arg0_40:findTF("Info", arg2_41)
			local var8_41 = arg0_40:findTF("PointText", var7_41)
			local var9_41 = arg0_40:findTF("BuffGet", var7_41)
			local var10_41 = arg0_40:findTF("TypeIcon", var9_41)
			local var11_41 = arg0_40:findTF("AttrIcon", var10_41)
			local var12_41 = arg0_40:findTF("NumText", var10_41)
			local var13_41 = arg0_40:findTF("Lock", var7_41)
			local var14_41 = arg0_40:findTF("BuffComplete", var7_41)
			local var15_41 = arg0_40:findTF("TypeIcon", var14_41)
			local var16_41 = arg0_40:findTF("AttrIcon", var15_41)
			local var17_41 = arg0_40:findTF("NumText", var15_41)
			local var18_41 = arg0_40:findTF("BottomBG", arg2_41)
			local var19_41 = arg0_40:findTF("BottomBG/StatusUnknow", arg2_41)
			local var20_41 = arg0_40:findTF("BottomBG/StatusResearching", arg2_41)
			local var21_41 = arg0_40:findTF("ViewIcon", arg2_41)
			local var22_41 = arg0_40:findTF("keyansaohguang", arg2_41)
			local var23_41 = arg1_40[arg1_41 + 1]

			setText(var3_41, shortenString(ShipGroup.getDefaultShipNameByGroupID(var23_41), 6))

			local var24_41 = var23_41 * 10 + 1

			setImageSprite(var0_41, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. pg.ship_data_statistics[var24_41].rarity))
			LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(var24_41), function(arg0_42)
				if arg0_42 and not arg0_40.exited then
					setImageSprite(var1_41, arg0_42, true)

					rtf(var1_41).pivot = getSpritePivot(arg0_42)
				end
			end)

			if table.indexof(arg0_40.groupIDGotList, var23_41, 1) then
				local var25_41 = pg.fleet_tech_ship_template[var23_41].add_get_shiptype[1]
				local var26_41 = pg.fleet_tech_ship_template[var23_41].add_get_attr
				local var27_41 = pg.fleet_tech_ship_template[var23_41].add_get_value

				setImageSprite(var10_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var25_41))
				setImageSprite(var11_41, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var26_41].name))
				setText(var12_41, "+" .. var27_41)
				setActive(var9_41, true)

				local var28_41 = arg0_40.collectionProxy:getShipGroup(var23_41)

				if var28_41.maxLV < TechnologyConst.SHIP_LEVEL_FOR_BUFF then
					setActive(var20_41, true)
					setActive(var19_41, false)
					setActive(var14_41, false)
					setImageSprite(var4_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
					setActive(var18_41, true)
					setActive(var21_41, true)
					setActive(var13_41, true)
					setActive(var22_41, false)

					if var28_41.star == pg.fleet_tech_ship_template[var23_41].max_star then
						setText(var8_41, "+" .. pg.fleet_tech_ship_template[var23_41].pt_get + pg.fleet_tech_ship_template[var23_41].pt_upgrage)
					else
						setText(var8_41, "+" .. pg.fleet_tech_ship_template[var23_41].pt_get)
					end
				else
					local var29_41 = pg.fleet_tech_ship_template[var23_41].add_level_shiptype[1]
					local var30_41 = pg.fleet_tech_ship_template[var23_41].add_level_attr
					local var31_41 = pg.fleet_tech_ship_template[var23_41].add_level_value

					setImageSprite(var15_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var29_41))
					setImageSprite(var16_41, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var30_41].name))
					setText(var17_41, "+" .. var31_41)
					setActive(var14_41, true)

					if var28_41.star == pg.fleet_tech_ship_template[var23_41].max_star then
						setText(var8_41, "+" .. pg.fleet_tech_ship_template[var23_41].pt_get + pg.fleet_tech_ship_template[var23_41].pt_level + pg.fleet_tech_ship_template[var23_41].pt_upgrage)
						setImageSprite(var4_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_finished"))
						setActive(var18_41, false)
						setActive(var21_41, false)
						setActive(var20_41, false)
						setActive(var19_41, false)
						setActive(var22_41, true)
					else
						setText(var8_41, "+" .. pg.fleet_tech_ship_template[var23_41].pt_get + pg.fleet_tech_ship_template[var23_41].pt_level)
						setImageSprite(var4_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
						setActive(var18_41, true)
						setActive(var21_41, true)
						setActive(var20_41, true)
						setActive(var19_41, false)
						setActive(var22_41, false)
					end

					setActive(var13_41, false)
				end

				setImageColor(var1_41, Color.New(1, 1, 1, 1))
				setActive(var2_41, true)
				setActive(var7_41, true)
				setActive(var5_41, true)

				if var28_41.star == pg.fleet_tech_ship_template[var23_41].max_star then
					setActive(var6_41, true)
				else
					setActive(var6_41, false)
				end

				onButton(arg0_40, arg2_41, function()
					arg0_40:emit(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, var23_41, var28_41.maxLV, var28_41.star)
				end)
			else
				setImageSprite(var4_41, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
				setImageColor(var1_41, Color.New(0, 0, 0, 0.4))
				setActive(var21_41, false)
				setActive(var2_41, false)
				setActive(var7_41, false)
				setActive(var20_41, false)
				setActive(var19_41, true)
				setActive(var5_41, false)
				setActive(var13_41, false)
				setActive(var22_41, false)
				removeOnButton(arg2_41)
			end

			setActive(arg2_41, true)
		end
	end)
	var0_40:align(#arg1_40)
end

function var0_0.getClassIDListForShow(arg0_44, arg1_44, arg2_44)
	arg1_44 = arg1_44 or arg0_44.nationSelectedList
	arg2_44 = arg2_44 or arg0_44.typeSelectedList

	local var0_44 = arg0_44:isMetaOn()
	local var1_44 = arg0_44:isMotOn()

	if not var0_44 and not var1_44 then
		local var2_44 = TechnologyConst.GetOrderClassList()
		local var3_44

		if #arg1_44 == 0 and #arg2_44 == 0 then
			var3_44 = var2_44
		else
			local var4_44 = #arg1_44 == 0 and TechnologyConst.NationOrder or arg1_44

			var3_44 = _.select(var2_44, function(arg0_45)
				local var0_45 = pg.fleet_tech_ship_class[arg0_45].nation

				if table.contains(var4_44, var0_45) then
					if #arg0_44.typeSelectedList == 0 then
						return true
					else
						local var1_45 = pg.fleet_tech_ship_class[arg0_45].shiptype

						return table.contains(arg0_44.typeSelectedList, var1_45)
					end
				else
					return false
				end
			end)
		end

		arg0_44.curClassIDList = var3_44

		return var3_44
	elseif var0_44 then
		arg0_44.curMetaClassIDList = TechnologyConst.GetOrderMetaClassList(arg2_44)

		return arg0_44.curMetaClassIDList
	elseif var1_44 then
		arg0_44.curMotClassIDList = TechnologyConst.GetOrderMotClassList(arg2_44)

		return arg0_44.curMotClassIDList
	end
end

function var0_0.getClassConfigForShow(arg0_46, arg1_46)
	local var0_46 = arg0_46:isMetaOn()
	local var1_46 = arg0_46:isMotOn()

	if not var0_46 and not var1_46 then
		local var2_46 = arg0_46.curClassIDList[arg1_46]

		return pg.fleet_tech_ship_class[var2_46]
	elseif var0_46 then
		local var3_46 = arg0_46.curMetaClassIDList[arg1_46]

		return TechnologyConst.GetMetaClassConfig(var3_46, arg0_46.typeSelectedList)
	elseif var1_46 then
		local var4_46 = arg0_46.curMotClassIDList[arg1_46]

		return TechnologyConst.GetMotClassConfig(var4_46, arg0_46.typeSelectedList)
	end
end

function var0_0.isMetaOn(arg0_47)
	if arg0_47.lastNationTrige == var0_0.NationTrige.All then
		return false
	elseif arg0_47.lastNationTrige == var0_0.NationTrige.Mot then
		return false
	end

	return arg0_47.nationMetaToggleCom.isOn
end

function var0_0.isMotOn(arg0_48)
	if arg0_48.lastNationTrige == var0_0.NationTrige.All then
		return false
	elseif arg0_48.lastNationTrige == var0_0.NationTrige.Meta then
		return false
	end

	return arg0_48.nationMotToggleCom.isOn
end

return var0_0
