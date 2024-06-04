local var0 = class("TechnologyTreeScene", import("..base.BaseUI"))

var0.NationTrige = {
	All = 0,
	Mot = 3,
	Meta = 2,
	Other = 1
}
var0.TypeTrige = {
	All = 0,
	Other = 1
}

function var0.getUIName(arg0)
	return "TechnologyTreeUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:initNationToggleUIList()
	arg0:initTecClassUIList()
end

function var0.didEnter(arg0)
	arg0:initTypeToggleUIList()
	arg0:updateTecItemList()
	arg0:addBtnListener()
	setText(arg0.pointNumText, arg0.point)
	arg0:updateRedPoint(getProxy(TechnologyNationProxy):getShowRedPointTag())

	if not PlayerPrefs.HasKey("first_comein_technologytree") then
		triggerButton(arg0.helpBtn)
		PlayerPrefs.SetInt("first_comein_technologytree", 1)
		PlayerPrefs.Save()
	end
end

function var0.updateRedPoint(arg0, arg1)
	setActive(arg0.redPointImg, arg1)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)

	arg0.rightLSC.onReturnItem = nil

	if arg0.emptyPage then
		arg0.emptyPage:Destroy()

		arg0.emptyPage = nil
	end
end

function var0.initData(arg0)
	TechnologyConst.CreateMetaClassConfig()

	arg0.nationToggleList = {}
	arg0.typeToggleList = {}
	arg0.nationSelectedList = {}
	arg0.typeSelectedList = {}
	arg0.nationSelectedCount = 0
	arg0.typeSelectedCount = 0
	arg0.lastNationTrige = nil
	arg0.lastTypeTrige = nil
	arg0.countInEveryRow = 5
	arg0.collectionProxy = getProxy(CollectionProxy)
	arg0.nationProxy = getProxy(TechnologyNationProxy)
	arg0.curClassIDList = nil
	arg0.groupIDGotList = {}

	local var0 = arg0.collectionProxy.shipGroups

	for iter0, iter1 in pairs(var0) do
		arg0.groupIDGotList[#arg0.groupIDGotList + 1] = iter1.id
	end

	arg0.point = arg0.nationProxy:getPoint()
	arg0.expanded = {}
end

function var0.findUI(arg0)
	arg0.nationAllToggle = nil
	arg0.nationAllToggleCom = nil
	arg0.nationMetaToggle = arg0:findTF("Adapt/Left/MetaToggle")
	arg0.nationMetaToggleCom = GetComponent(arg0.nationMetaToggle, "Toggle")
	arg0.nationMotToggle = arg0:findTF("Adapt/Left/MotToggle")
	arg0.nationMotToggleCom = GetComponent(arg0.nationMotToggle, "Toggle")
	arg0.typeAllToggle = nil
	arg0.typeAllToggleCom = nil
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.adapt = arg0:findTF("adapt", arg0.blurPanel)
	arg0.backBtn = arg0:findTF("top/back", arg0.adapt)
	arg0.homeBtn = arg0:findTF("top/option", arg0.adapt)
	arg0.additionDetailBtn = arg0:findTF("AdditionDetailBtn", arg0.adapt)
	arg0.switchBtn = arg0:findTF("SwitchToggle", arg0.adapt)
	arg0.pointTF = arg0:findTF("PointCount", arg0.adapt)
	arg0.pointNumText = arg0:findTF("PointCount/PointNumText", arg0.adapt)
	arg0.redPointImg = arg0:findTF("RedPoint", arg0.switchBtn)
	arg0.helpBtn = arg0:findTF("help_btn", arg0.adapt)
	arg0.leftContainer = arg0:findTF("Adapt/Left/Scroll View/Content")
	arg0.selectNationItem = arg0:findTF("SelectCampItem")
	arg0.bottomContainer = arg0:findTF("Adapt/Bottom/Content")
	arg0.selectTypeItem = arg0:findTF("SelectTypeItem")
	arg0.rightContainer = arg0:findTF("Adapt/Right/Container")
	arg0.rightLSC = arg0.rightContainer:GetComponent("LScrollRect")
	arg0.rightLayoutGroup = arg0.rightContainer:GetComponent("VerticalLayoutGroup")
	arg0.headItem = arg0:findTF("HeadItem")
	arg0.rowHeight = arg0.headItem.rect.height
	arg0.maxRowHeight = 853.5
	arg0.emptyPage = BaseEmptyListPage.New(arg0:findTF("Adapt/Right/ViewPort"), arg0.event)
end

function var0.onBackPressed(arg0)
	triggerButton(arg0.backBtn)
end

function var0.addBtnListener(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.additionDetailBtn, function()
		arg0:emit(TechnologyConst.OPEN_ALL_BUFF_DETAIL)
	end)
	onToggle(arg0, arg0.switchBtn, function(arg0)
		if arg0 then
			setActive(arg0.pointTF, false)
			pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel, {
				weight = LayerWeightConst.SECOND_LAYER
			})
			arg0:emit(TechnologyConst.OPEN_TECHNOLOGY_NATION_LAYER)
		else
			setActive(arg0.pointTF, true)
			pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
			arg0:emit(TechnologyConst.CLOSE_TECHNOLOGY_NATION_LAYER)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		if pg.gametip.help_technologytree then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.help_technologytree.tip,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end, SFX_PANEL)
end

function var0.initNationToggleUIList(arg0)
	arg0.nationAllToggle = nil
	arg0.nationAllToggleCom = nil
	arg0.nationMetaToggle = arg0:findTF("Adapt/Left/MetaToggle")
	arg0.nationMetaToggleCom = GetComponent(arg0.nationMetaToggle, "Toggle")
	arg0.nationMotToggle = arg0:findTF("Adapt/Left/MotToggle")
	arg0.nationMotToggleCom = GetComponent(arg0.nationMotToggle, "Toggle")

	setActive(arg0.nationMetaToggle, not LOCK_TEC_META)

	if LOCK_TEC_META then
		local var0 = arg0:findTF("Adapt/Left/Scroll View")

		var0.offsetMin = Vector2.New(var0.offsetMin.x, 0)
	end

	local var1 = UIItemList.New(arg0.leftContainer, arg0.selectNationItem)

	var1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:findTF("UnSelectedImg", arg2):GetComponent("Image").sprite, arg0:findTF("SelectedImg", arg2):GetComponent("Image").sprite = TechnologyConst.GetNationSpriteByIndex(arg1 + 1)

			if arg1 == 0 then
				arg0.nationAllToggle = arg2
				arg0.nationAllToggleCom = GetComponent(arg2, "Toggle")
				arg0.nationAllToggleCom.interactable = false

				triggerToggle(arg2, true)
			else
				arg0.nationToggleList[arg1] = arg2

				triggerToggle(arg2, false)
			end

			setActive(arg2, true)
		end
	end)
	var1:align(#TechnologyConst.NationResName)
	setActive(arg0.nationMotToggle, not LOCK_TEC_MOT)

	if not LOCK_TEC_MOT then
		setParent(arg0.nationMotToggle, arg0.leftContainer)
	end

	onToggle(arg0, arg0.nationAllToggle, function(arg0)
		if arg0 == true then
			arg0.lastNationTrige = var0.NationTrige.All
			arg0.nationAllToggleCom.interactable = false
			arg0.nationSelectedCount = 0
			arg0.nationSelectedList = {}

			arg0:updateTecItemList()
			arg0:updateNationToggleUIList()
		else
			arg0.nationAllToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.nationMetaToggle, function(arg0)
		if arg0 == true then
			arg0.lastNationTrige = var0.NationTrige.Meta
			arg0.nationMetaToggleCom.interactable = false
			arg0.nationSelectedCount = 0
			arg0.nationSelectedList = {}

			arg0:updateTecItemList()
			arg0:updateNationToggleUIList()
		else
			arg0.nationMetaToggleCom.interactable = true
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.nationMotToggle, function(arg0)
		if arg0 == true then
			arg0.lastNationTrige = var0.NationTrige.Mot
			arg0.nationMotToggleCom.interactable = false
			arg0.nationSelectedCount = 0
			arg0.nationSelectedList = {}

			arg0:updateTecItemList()
			arg0:updateNationToggleUIList()
		else
			arg0.nationMotToggleCom.interactable = true
		end
	end, SFX_PANEL)

	for iter0, iter1 in ipairs(arg0.nationToggleList) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 == true then
				arg0.lastNationTrige = var0.NationTrige.Other
				arg0.nationSelectedCount = arg0.nationSelectedCount + 1

				table.insert(arg0.nationSelectedList, TechnologyConst.NationOrder[iter0])

				if arg0.nationSelectedCount < #arg0.nationToggleList then
					arg0:updateNationToggleUIList()
					arg0:updateTecItemList()
				elseif arg0.nationSelectedCount == #arg0.nationToggleList then
					arg0:updateNationToggleUIList()
				end
			elseif arg0.nationSelectedCount > 0 then
				arg0.nationSelectedCount = arg0.nationSelectedCount - 1

				local var0 = table.indexof(arg0.nationSelectedList, TechnologyConst.NationOrder[iter0], 1)

				if var0 then
					table.remove(arg0.nationSelectedList, var0)
				end

				if arg0.nationSelectedCount > 0 then
					arg0:updateNationToggleUIList()
					arg0:updateTecItemList()
				elseif arg0.nationSelectedCount == 0 then
					arg0:updateNationToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0.updateNationToggleUIList(arg0)
	if arg0.lastNationTrige == var0.NationTrige.All then
		_.each(arg0.nationToggleList, function(arg0)
			triggerToggle(arg0, false)
			onNextTick(function()
				local var0 = arg0:findTF("UnSelectedImg", arg0)

				setActive(var0, true)
			end)
		end)
		triggerToggle(arg0.nationMetaToggle, false)
		triggerToggle(arg0.nationMotToggle, false)
	elseif arg0.lastNationTrige == var0.NationTrige.Meta then
		triggerToggle(arg0.nationAllToggle, false)
		_.each(arg0.nationToggleList, function(arg0)
			triggerToggle(arg0, false)
		end)
		triggerToggle(arg0.nationMotToggle, false)
	elseif arg0.lastNationTrige == var0.NationTrige.Mot then
		triggerToggle(arg0.nationAllToggle, false)
		_.each(arg0.nationToggleList, function(arg0)
			triggerToggle(arg0, false)
		end)
		triggerToggle(arg0.nationMetaToggle, false)
	elseif arg0.lastNationTrige == var0.NationTrige.Other then
		if arg0.nationSelectedCount <= 0 or arg0.nationSelectedCount >= #arg0.nationToggleList then
			triggerToggle(arg0.nationAllToggle, true)
		else
			triggerToggle(arg0.nationAllToggle, false)
			triggerToggle(arg0.nationMetaToggle, false)
			triggerToggle(arg0.nationMotToggle, false)
		end
	end
end

function var0.initTypeToggleUIList(arg0)
	arg0.typeAllToggle = nil
	arg0.typeAllToggleCom = nil

	local var0 = UIItemList.New(arg0.bottomContainer, arg0.selectTypeItem)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:findTF("UnSelectedImg", arg2):GetComponent("Image").sprite, arg0:findTF("SelectedImg", arg2):GetComponent("Image").sprite = TechnologyConst.GetTypeSpriteByIndex(arg1 + 1)
			arg1 = arg1 + 1

			if arg1 == #TechnologyConst.TypeResName then
				arg0.typeAllToggle = arg2
				arg0.typeAllToggleCom = GetComponent(arg2, "Toggle")
				arg0.typeAllToggleCom.interactable = false

				triggerToggle(arg2, true)
			else
				arg0.typeToggleList[arg1] = arg2

				triggerToggle(arg2, false)
			end

			setActive(arg2, true)
		end
	end)
	var0:align(#TechnologyConst.TypeResName)
	onToggle(arg0, arg0.typeAllToggle, function(arg0)
		arg0.lastTypeTrige = var0.TypeTrige.All

		if arg0 == true then
			arg0.typeAllToggleCom.interactable = false
			arg0.typeSelectedCount = 0
			arg0.typeSelectedList = {}

			arg0:updateTecItemList()
			arg0:updateTypeToggleUIList()
		else
			arg0.typeAllToggleCom.interactable = true
		end
	end)

	for iter0, iter1 in ipairs(arg0.typeToggleList) do
		onToggle(arg0, iter1, function(arg0)
			arg0.lastTypeTrige = var0.TypeTrige.Other

			if arg0 == true then
				arg0.typeSelectedCount = arg0.typeSelectedCount + 1

				for iter0, iter1 in ipairs(TechnologyConst.TypeOrder[iter0]) do
					table.insert(arg0.typeSelectedList, iter1)
				end

				if arg0.typeSelectedCount < #arg0.typeToggleList then
					arg0:updateTypeToggleUIList()
					arg0:updateTecItemList()
				elseif arg0.typeSelectedCount == #arg0.typeToggleList then
					arg0:updateTypeToggleUIList()
				end
			elseif arg0.typeSelectedCount > 0 then
				arg0.typeSelectedCount = arg0.typeSelectedCount - 1

				for iter2, iter3 in ipairs(TechnologyConst.TypeOrder[iter0]) do
					local var0 = table.indexof(arg0.typeSelectedList, iter3, 1)

					if var0 then
						table.remove(arg0.typeSelectedList, var0)
					end
				end

				if arg0.typeSelectedCount > 0 then
					arg0:updateTypeToggleUIList()
					arg0:updateTecItemList()
				elseif arg0.typeSelectedCount == 0 then
					arg0:updateTypeToggleUIList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0.updateTypeToggleUIList(arg0)
	if arg0.lastTypeTrige == var0.TypeTrige.All then
		_.each(arg0.typeToggleList, function(arg0)
			triggerToggle(arg0, false)
			onNextTick(function()
				local var0 = arg0:findTF("UnSelectedImg", arg0)

				setActive(var0, true)
			end)
		end)
	elseif arg0.lastTypeTrige == var0.TypeTrige.Other then
		if arg0.typeSelectedCount <= 0 or arg0.typeSelectedCount >= #arg0.typeToggleList then
			triggerToggle(arg0.typeAllToggle, true)
		else
			triggerToggle(arg0.typeAllToggle, false)
		end
	end
end

function var0.updatePreferredHeight(arg0, arg1, arg2)
	local var0 = tf(arg1):Find("ShipScrollView/ShipContainer")
	local var1 = arg2 + arg0.rowHeight

	arg0.rightLayoutGroup.padding.bottom = arg0.rightLayoutGroup.padding.bottom + var1 - GetComponent(arg1, "LayoutElement").preferredHeight
	GetComponent(arg1, "LayoutElement").preferredHeight = var1

	local var2 = tf(arg1):Find("ClickBtn/ArrowBtn")

	setLocalRotation(var2, {
		z = arg2 > 0 and 0 or 180
	})
end

function var0.onClassItemUpdate(arg0, arg1, arg2)
	local var0 = arg0:findTF("Name/NameText", arg2)
	local var1 = arg0:findTF("CampBG", arg2)
	local var2 = arg0:findTF("Level/LevelImg", arg2)
	local var3 = arg0:findTF("Level/TypeTextImg", arg2)
	local var4 = arg0:findTF("ClickBtn", arg2)
	local var5 = arg0:findTF("ArrowBtn", var4)
	local var6 = arg0:getClassConfigForShow(arg1 + 1)
	local var7 = var6.name
	local var8 = var6.nation
	local var9 = var6.shiptype
	local var10 = var6.t_level
	local var11 = var6.ships
	local var12 = arg0:isMetaOn()
	local var13 = arg0:isMotOn()

	setText(var0, var7)

	local var14

	if var12 or var13 then
		setActive(var2, false)
		setActive(var3, false)

		if var12 then
			var14 = GetSpriteFromAtlas("TecNation", "bg_nation_meta")
		elseif var13 then
			var14 = GetSpriteFromAtlas("TecNation", "bg_nation_mot")
		end
	else
		setImageSprite(var2, GetSpriteFromAtlas("TecClassLevelIcon", "T" .. var10), true)
		setImageSprite(var3, GetSpriteFromAtlas("ShipType", "ch_title_" .. var9), true)
		setActive(var2, true)
		setActive(var3, true)

		var14 = GetSpriteFromAtlas("TecNation", "bg_nation_" .. var8)
	end

	setImageSprite(var1, var14)

	local var15 = arg0:findTF("ClickBtn/ArrowBtn", arg2)

	setLocalRotation(var15, {
		z = 180
	})

	local var16 = arg0:findTF("ShipScrollView/ShipContainer", arg2)

	arg0:updateShipItemList(var11, var16)

	arg0.expanded[arg1] = 0

	arg0:updatePreferredHeight(arg2, arg0.expanded[arg1])
	setActive(var4, #var11 > 5)
	onButton(arg0, var4, function()
		if defaultValue(arg0.expanded[arg1], 0) > 0 then
			arg0.expanded[arg1] = 0
		else
			arg0.expanded[arg1] = var16.rect.height - arg0.rowHeight
		end

		arg0:updatePreferredHeight(arg2, arg0.expanded[arg1])
	end, SFX_PANEL)
end

function var0.onClassItemReturn(arg0, arg1, arg2)
	if defaultValue(arg0.expanded[arg1], 0) > 0 then
		arg0.expanded[arg1] = 0

		arg0:updatePreferredHeight(arg2, arg0.expanded[arg1])
	end
end

function var0.initTecClassUIList(arg0)
	function arg0.rightLSC.onUpdateItem(arg0, arg1)
		arg0:onClassItemUpdate(arg0, arg1)
	end

	function arg0.rightLSC.onReturnItem(arg0, arg1)
		arg0:onClassItemReturn(arg0, arg1)
	end
end

function var0.updateTecItemList(arg0)
	arg0.expanded = {}

	local var0 = arg0:getClassIDListForShow()

	if arg0.rightLSC.totalCount ~= 0 then
		arg0.rightLSC:SetTotalCount(0)
	end

	arg0.rightLSC:SetTotalCount(#var0)
	arg0.rightLSC:BeginLayout()
	arg0.rightLSC:EndLayout()

	local var1 = #var0

	if var1 <= 0 then
		arg0.emptyPage:ExecuteAction("ShowOrHide", true)
		arg0.emptyPage:ExecuteAction("SetEmptyText", i18n("technology_filter_placeholder"))
	elseif var1 > 0 and arg0.emptyPage:GetLoaded() then
		arg0.emptyPage:ExecuteAction("ShowOrHide", false)
	end
end

function var0.updateShipItemList(arg0, arg1, arg2)
	local var0 = UIItemList.New(arg2, arg0.headItem)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("BaseImg", arg2)
			local var1 = arg0:findTF("BaseImg/CharImg", arg2)
			local var2 = arg0:findTF("NameBG", arg2)
			local var3 = arg0:findTF("NameText", var2)
			local var4 = arg0:findTF("Frame", arg2)
			local var5 = arg0:findTF("Star", arg2)
			local var6 = arg0:findTF("Star/StarImg", arg2)
			local var7 = arg0:findTF("Info", arg2)
			local var8 = arg0:findTF("PointText", var7)
			local var9 = arg0:findTF("BuffGet", var7)
			local var10 = arg0:findTF("TypeIcon", var9)
			local var11 = arg0:findTF("AttrIcon", var10)
			local var12 = arg0:findTF("NumText", var10)
			local var13 = arg0:findTF("Lock", var7)
			local var14 = arg0:findTF("BuffComplete", var7)
			local var15 = arg0:findTF("TypeIcon", var14)
			local var16 = arg0:findTF("AttrIcon", var15)
			local var17 = arg0:findTF("NumText", var15)
			local var18 = arg0:findTF("BottomBG", arg2)
			local var19 = arg0:findTF("BottomBG/StatusUnknow", arg2)
			local var20 = arg0:findTF("BottomBG/StatusResearching", arg2)
			local var21 = arg0:findTF("ViewIcon", arg2)
			local var22 = arg0:findTF("keyansaohguang", arg2)
			local var23 = arg1[arg1 + 1]

			setText(var3, shortenString(ShipGroup.getDefaultShipNameByGroupID(var23), 6))

			local var24 = var23 * 10 + 1

			setImageSprite(var0, GetSpriteFromAtlas("shipraritybaseicon", "base_" .. pg.ship_data_statistics[var24].rarity))
			LoadSpriteAsync("shipmodels/" .. Ship.getPaintingName(var24), function(arg0)
				if arg0 and not arg0.exited then
					setImageSprite(var1, arg0, true)

					rtf(var1).pivot = getSpritePivot(arg0)
				end
			end)

			if table.indexof(arg0.groupIDGotList, var23, 1) then
				local var25 = pg.fleet_tech_ship_template[var23].add_get_shiptype[1]
				local var26 = pg.fleet_tech_ship_template[var23].add_get_attr
				local var27 = pg.fleet_tech_ship_template[var23].add_get_value

				setImageSprite(var10, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var25))
				setImageSprite(var11, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var26].name))
				setText(var12, "+" .. var27)
				setActive(var9, true)

				local var28 = arg0.collectionProxy:getShipGroup(var23)

				if var28.maxLV < TechnologyConst.SHIP_LEVEL_FOR_BUFF then
					setActive(var20, true)
					setActive(var19, false)
					setActive(var14, false)
					setImageSprite(var4, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
					setActive(var18, true)
					setActive(var21, true)
					setActive(var13, true)
					setActive(var22, false)

					if var28.star == pg.fleet_tech_ship_template[var23].max_star then
						setText(var8, "+" .. pg.fleet_tech_ship_template[var23].pt_get + pg.fleet_tech_ship_template[var23].pt_upgrage)
					else
						setText(var8, "+" .. pg.fleet_tech_ship_template[var23].pt_get)
					end
				else
					local var29 = pg.fleet_tech_ship_template[var23].add_level_shiptype[1]
					local var30 = pg.fleet_tech_ship_template[var23].add_level_attr
					local var31 = pg.fleet_tech_ship_template[var23].add_level_value

					setImageSprite(var15, GetSpriteFromAtlas("ui/technologytreeui_atlas", "label_" .. var29))
					setImageSprite(var16, GetSpriteFromAtlas("attricon", pg.attribute_info_by_type[var30].name))
					setText(var17, "+" .. var31)
					setActive(var14, true)

					if var28.star == pg.fleet_tech_ship_template[var23].max_star then
						setText(var8, "+" .. pg.fleet_tech_ship_template[var23].pt_get + pg.fleet_tech_ship_template[var23].pt_level + pg.fleet_tech_ship_template[var23].pt_upgrage)
						setImageSprite(var4, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_finished"))
						setActive(var18, false)
						setActive(var21, false)
						setActive(var20, false)
						setActive(var19, false)
						setActive(var22, true)
					else
						setText(var8, "+" .. pg.fleet_tech_ship_template[var23].pt_get + pg.fleet_tech_ship_template[var23].pt_level)
						setImageSprite(var4, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
						setActive(var18, true)
						setActive(var21, true)
						setActive(var20, true)
						setActive(var19, false)
						setActive(var22, false)
					end

					setActive(var13, false)
				end

				setImageColor(var1, Color.New(1, 1, 1, 1))
				setActive(var2, true)
				setActive(var7, true)
				setActive(var5, true)

				if var28.star == pg.fleet_tech_ship_template[var23].max_star then
					setActive(var6, true)
				else
					setActive(var6, false)
				end

				onButton(arg0, arg2, function()
					arg0:emit(TechnologyConst.OPEN_SHIP_BUFF_DETAIL, var23, var28.maxLV, var28.star)
				end)
			else
				setImageSprite(var4, GetSpriteFromAtlas("ui/technologytreeui_atlas", "card_bg_normal"))
				setImageColor(var1, Color.New(0, 0, 0, 0.4))
				setActive(var21, false)
				setActive(var2, false)
				setActive(var7, false)
				setActive(var20, false)
				setActive(var19, true)
				setActive(var5, false)
				setActive(var13, false)
				setActive(var22, false)
				removeOnButton(arg2)
			end

			setActive(arg2, true)
		end
	end)
	var0:align(#arg1)
end

function var0.getClassIDListForShow(arg0, arg1, arg2)
	arg1 = arg1 or arg0.nationSelectedList
	arg2 = arg2 or arg0.typeSelectedList

	local var0 = arg0:isMetaOn()
	local var1 = arg0:isMotOn()

	if not var0 and not var1 then
		local var2 = TechnologyConst.GetOrderClassList()
		local var3

		if #arg1 == 0 and #arg2 == 0 then
			var3 = var2
		else
			local var4 = #arg1 == 0 and TechnologyConst.NationOrder or arg1

			var3 = _.select(var2, function(arg0)
				local var0 = pg.fleet_tech_ship_class[arg0].nation

				if table.contains(var4, var0) then
					if #arg0.typeSelectedList == 0 then
						return true
					else
						local var1 = pg.fleet_tech_ship_class[arg0].shiptype

						return table.contains(arg0.typeSelectedList, var1)
					end
				else
					return false
				end
			end)
		end

		arg0.curClassIDList = var3

		return var3
	elseif var0 then
		arg0.curMetaClassIDList = TechnologyConst.GetOrderMetaClassList(arg2)

		return arg0.curMetaClassIDList
	elseif var1 then
		arg0.curMotClassIDList = TechnologyConst.GetOrderMotClassList(arg2)

		return arg0.curMotClassIDList
	end
end

function var0.getClassConfigForShow(arg0, arg1)
	local var0 = arg0:isMetaOn()
	local var1 = arg0:isMotOn()

	if not var0 and not var1 then
		local var2 = arg0.curClassIDList[arg1]

		return pg.fleet_tech_ship_class[var2]
	elseif var0 then
		local var3 = arg0.curMetaClassIDList[arg1]

		return TechnologyConst.GetMetaClassConfig(var3, arg0.typeSelectedList)
	elseif var1 then
		local var4 = arg0.curMotClassIDList[arg1]

		return TechnologyConst.GetMotClassConfig(var4, arg0.typeSelectedList)
	end
end

function var0.isMetaOn(arg0)
	if arg0.lastNationTrige == var0.NationTrige.All then
		return false
	elseif arg0.lastNationTrige == var0.NationTrige.Mot then
		return false
	end

	return arg0.nationMetaToggleCom.isOn
end

function var0.isMotOn(arg0)
	if arg0.lastNationTrige == var0.NationTrige.All then
		return false
	elseif arg0.lastNationTrige == var0.NationTrige.Meta then
		return false
	end

	return arg0.nationMotToggleCom.isOn
end

return var0
