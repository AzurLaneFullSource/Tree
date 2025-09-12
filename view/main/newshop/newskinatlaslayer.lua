local var0_0 = class("NewSkinAtlasLayer", import("...base.BaseUI"))
local var1_0 = -1
local var2_0 = 9999

function var0_0.getUIName(arg0_1)
	return "NewSkinAtlasUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.empty = arg0_2._tf:Find("empty")
	arg0_2.backBtn = arg0_2._tf:Find("adapt/top/closeBtn")
	arg0_2.homeBtn = arg0_2._tf:Find("adapt/top/homeBtn")
	arg0_2.resources = arg0_2._tf:Find("adapt/top/resources")
	arg0_2.filterBtn = arg0_2._tf:Find("adapt/top/filterBtn")
	arg0_2.search = arg0_2._tf:Find("adapt/top/search")
	arg0_2.scrollrect = arg0_2._tf:Find("scroll"):GetComponent("LScrollRect")
	arg0_2.filterUI = arg0_2._tf:Find("subPage/filterUI")
	arg0_2.filterContent = arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content")

	setActive(arg0_2.filterUI, false)
	setText(arg0_2.empty:Find("Text"), i18n("shop_new_unfound"))
	setText(arg0_2._tf:Find("adapt/top/title/Text"), i18n("shop_new_shop"))
	setText(arg0_2._tf:Find("adapt/top/have/Text"), i18n("shop_new_owned_skin"))
	setText(arg0_2.filterBtn:Find("Text"), i18n("shop_new_sort"))
	setText(arg0_2.search:Find("holder"), i18n("shop_new_search"))
	setText(arg0_2.filterUI:Find("panelMask/panel/title"), i18n("shop_new_sort"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/subTitleFrame/subTitle"), i18n("shop_new_review"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/0/Text"), i18n("shop_new_all"))
	setScrollText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/own/options/1/mask/Text"), i18n("shop_new_unused"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/subTitleFrame/subTitle"), i18n("shop_new_type"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/2/Text"), i18n("shop_new_static"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/3/Text"), i18n("shop_new_dynamic"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/4/Text"), i18n("shop_new_static_bg"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/5/Text"), i18n("shop_new_dynamic_bg"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/type/options/6/Text"), i18n("shop_new_bgm"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/subTitleFrame/subTitle"), i18n("shop_new_index"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/0/Text"), i18n("shop_new_all"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/1/Text"), i18n("shop_new_ship_owned"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipHave/options/2/Text"), i18n("shop_new_ship_havent_owned"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/camp/subTitleFrame/subTitle"), i18n("shop_new_nation"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/rarity/subTitleFrame/subTitle"), i18n("shop_new_rarity"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/shipType/subTitleFrame/subTitle"), i18n("shop_new_category"))
	setText(arg0_2.filterUI:Find("panelMask/panel/filterScroll/Viewport/Content/themeType/subTitleFrame/subTitle"), i18n("shop_new_skin_theme"))
	setText(arg0_2.filterUI:Find("panelMask/panel/bottom/ok/Text"), i18n("shop_new_confirm"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2.bg,
			arg0_2.filterUI:Find("panelMask/panel")
		}
	})
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	arg0_3:SetFilterPanel()
	arg0_3:SetResource()
	arg0_3:SetSkinScroll()
	arg0_3:Refresh()
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.filterBtn, function()
		arg0_3:OpenFilterPanel()
	end, SFX_PANEL)
	onInputChanged(arg0_3, arg0_3.search, function()
		arg0_3:Refresh()

		local var0_7 = getInputText(arg0_3.search)

		setActive(arg0_3.search:Find("holder"), var0_7 == "")
	end)
end

function var0_0.InitData(arg0_8)
	arg0_8.skins = getProxy(ShipSkinProxy):GetOwnSkins()

	for iter0_8 = #arg0_8.skins, 1, -1 do
		local var0_8 = arg0_8.skins[iter0_8]
		local var1_8 = ShipSkin.GetChangeSkinIndex(var0_8.id)

		if var1_8 and var1_8 ~= 1 then
			table.remove(arg0_8.skins, iter0_8)
		end
	end

	arg0_8:GetSkinClassify()

	arg0_8.filterValues = {
		ownType = 0,
		shipHaveType = 0,
		typeType = {
			0
		},
		campType = {
			0
		},
		rarityType = {
			0
		},
		shipType = {
			0
		},
		themeType = {
			0
		}
	}
	arg0_8.filterValuesTemp = Clone(arg0_8.filterValues)
end

function var0_0.SetResource(arg0_9)
	local var0_9 = getProxy(PlayerProxy):getRawData()

	setText(arg0_9.resources:Find("gem/Text"), var0_9:getTotalGem())
	onButton(arg0_9, arg0_9.resources:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.SetSkinScroll(arg0_11)
	arg0_11.scrollrect.isNewLoadingMethod = true

	function arg0_11.scrollrect.onInitItem(arg0_12)
		arg0_11:OnInitItem(arg0_12)
	end

	function arg0_11.scrollrect.onUpdateItem(arg0_13, arg1_13)
		arg0_11:OnUpdateItem(arg0_13, arg1_13)
	end

	function arg0_11.scrollrect.onReturnItem(arg0_14, arg1_14)
		arg0_11:OnReturnItem(arg0_14, arg1_14)
	end
end

function var0_0.OnInitItem(arg0_15, arg1_15)
	ClearTweenItemAlphaAndWhite(arg1_15)
end

function var0_0.ReturnIndex(arg0_16, arg1_16)
	local var0_16 = arg0_16.scrollShowClassifyIds[arg1_16]

	if arg0_16.indexDic[arg1_16] then
		for iter0_16 = #arg0_16.groupDic[var0_16], 1, -1 do
			if arg0_16.groupDic[var0_16][iter0_16] == arg1_16 then
				table.remove(arg0_16.groupDic[var0_16], iter0_16)
			end
		end
	end

	arg0_16.indexDic[arg1_16] = false
end

function var0_0.RegisterIndex(arg0_17, arg1_17)
	arg0_17.indexDic[arg1_17] = true

	local var0_17 = arg0_17.scrollShowClassifyIds[arg1_17]

	if var0_17 then
		arg0_17.groupDic[var0_17] = arg0_17.groupDic[var0_17] or {}

		table.insert(arg0_17.groupDic[var0_17], arg1_17)
	end
end

function var0_0.ChangeClassifyName(arg0_18, arg1_18)
	for iter0_18, iter1_18 in ipairs(arg1_18) do
		local var0_18

		for iter2_18, iter3_18 in pairs(arg0_18.goDic) do
			if iter1_18 == iter3_18 then
				var0_18 = iter2_18

				break
			end
		end

		if var0_18 then
			local var1_18 = arg0_18.scrollShowClassifyIds[iter1_18]
			local var2_18 = arg0_18.classifyNames[table.indexof(arg0_18.classifyIds, var1_18)]
			local var3_18 = (arg0_18.groupDic[var1_18] or {})[1] == iter1_18

			setActive(tf(var0_18):Find("titleBar"), var3_18)

			if var3_18 then
				setText(tf(var0_18):Find("titleBar/title"), var2_18)

				local var4_18 = arg0_18._tf:Find("scroll/content"):GetComponent(typeof(VerticalLayoutGroup)).spacing
				local var5_18 = arg0_18.scrollClassifyNum[var1_18]
				local var6_18 = tf(var0_18):GetComponent(typeof(LayoutElement)).preferredHeight
				local var7_18 = var6_18 * var5_18 + var4_18 * (var5_18 - 1)
				local var8_18 = (arg0_18.scrollShouldShowName[iter1_18] - 1) * (var6_18 + var4_18)

				setSizeDelta(tf(var0_18):Find("titleBar"), {
					x = tf(var0_18):Find("titleBar").rect.width,
					y = var7_18
				})
				setAnchoredPosition(tf(var0_18):Find("titleBar"), {
					y = var8_18
				})
			end
		end
	end
end

function var0_0.GetDisplayIndex(arg0_19, arg1_19)
	return (arg0_19.groupDic[arg1_19] or {})[1]
end

function var0_0.ClickTrigger(arg0_20, arg1_20, arg2_20)
	arg0_20:emit(NewSkinAtlasMediator.OPEN_SHOW_LAYER, arg2_20)
end

function var0_0.OnUpdateItem(arg0_21, arg1_21, arg2_21)
	TweenItemAlphaAndWhite(arg2_21)

	arg1_21 = arg1_21 + 1

	local var0_21 = arg0_21.scrollDisplays[arg1_21]

	if arg0_21.goDic[arg2_21] and arg0_21.goDic[arg2_21] ~= arg1_21 then
		local var1_21 = arg0_21.scrollShowClassifyIds[arg0_21.goDic[arg2_21]]
		local var2_21 = arg0_21:GetDisplayIndex(var1_21)

		arg0_21:ReturnIndex(arg0_21.goDic[arg2_21])

		if var2_21 ~= arg0_21:GetDisplayIndex(var1_21) then
			local var3_21 = {}

			table.insert(var3_21, var2_21)
			table.insert(var3_21, arg0_21:GetDisplayIndex(var1_21))
			arg0_21:ChangeClassifyName(var3_21)
		end
	end

	arg0_21.goDic[arg2_21] = arg1_21

	local var4_21 = arg0_21.scrollShowClassifyIds[arg1_21]
	local var5_21 = arg0_21:GetDisplayIndex(var4_21)

	arg0_21:RegisterIndex(arg1_21)

	local var6_21 = {}

	if var5_21 ~= arg0_21:GetDisplayIndex(var4_21) then
		table.insert(var6_21, var5_21)
	end

	table.insert(var6_21, arg1_21)
	arg0_21:ChangeClassifyName(var6_21)

	if var0_21 then
		local var7_21 = UIItemList.New(tf(arg2_21):Find("skins"), tf(arg2_21):Find("skins/SkinAtlasCard"))

		var7_21:make(function(arg0_22, arg1_22, arg2_22)
			if arg0_22 == UIItemList.EventUpdate then
				local var0_22 = var0_21[arg1_22 + 1]
				local var1_22 = SkinAtlasCard.New(arg2_22)

				table.insert(arg0_21.cards, var1_22)
				var1_22:Update(var0_22, arg1_22 + 1)
				onButton(arg0_21, arg2_22, function()
					arg0_21:ClickTrigger(var1_22, var0_22)
				end, SFX_PANEL)
				onButton(arg0_21, var1_22.changeSkinUI, function()
					var1_22:changeSkinNext()
				end, SFX_PANEL)
			end
		end)
		var7_21:align(#var0_21)
	end
end

function var0_0.OnReturnItem(arg0_25, arg1_25, arg2_25)
	ClearTweenItemAlphaAndWhite(arg2_25)

	if arg0_25.exited then
		return
	end

	if arg0_25.goDic[arg2_25] then
		local var0_25 = arg0_25.scrollShowClassifyIds[arg0_25.goDic[arg2_25]]
		local var1_25 = arg0_25:GetDisplayIndex(var0_25)

		arg0_25:ReturnIndex(arg0_25.goDic[arg2_25])

		if var1_25 ~= arg0_25:GetDisplayIndex(var0_25) then
			local var2_25 = {}

			table.insert(var2_25, var1_25)
			table.insert(var2_25, arg0_25:GetDisplayIndex(var0_25))
			arg0_25:ChangeClassifyName(var2_25)
		end
	end
end

function var0_0.Refresh(arg0_26)
	arg0_26.showClassifyIds = {}
	arg0_26.displays = {}

	local var0_26 = getInputText(arg0_26.search)
	local var1_26 = Clone(arg0_26.classifyIds)
	local var2_26 = Clone(arg0_26.classifyNames)

	table.remove(var1_26, 1)
	table.remove(var2_26, 1)

	for iter0_26, iter1_26 in pairs(arg0_26.skins) do
		if arg0_26:filterOk(iter1_26) and arg0_26:IsSearchType(var0_26, iter1_26) then
			local var3_26 = arg0_26:GetShopTypeIdBySkinId(iter1_26.id)
			local var4_26 = var3_26 == 0 and var2_0 or var3_26

			if not arg0_26.displays[var4_26] then
				arg0_26.displays[var4_26] = {}
			end

			table.insert(arg0_26.displays[var4_26], iter1_26)
		end
	end

	for iter2_26, iter3_26 in ipairs(var1_26) do
		if arg0_26.displays[iter3_26] then
			table.insert(arg0_26.showClassifyIds, iter3_26)
		end
	end

	setActive(arg0_26.empty, #arg0_26.showClassifyIds == 0)

	arg0_26.scrollShowClassifyIds = {}
	arg0_26.scrollDisplays = {}
	arg0_26.scrollShouldShowName = {}
	arg0_26.scrollClassifyNum = {}

	for iter4_26, iter5_26 in ipairs(arg0_26.showClassifyIds) do
		local var5_26 = Clone(arg0_26.displays[iter5_26])
		local var6_26 = false

		arg0_26.scrollClassifyNum[iter5_26] = math.ceil(#var5_26 / 8)

		local var7_26 = 1

		while #var5_26 > 8 do
			table.insert(arg0_26.scrollShowClassifyIds, iter5_26)
			table.insert(arg0_26.scrollShouldShowName, var7_26)

			var7_26 = var7_26 + 1
			var6_26 = var6_26 or true

			local var8_26 = {}

			for iter6_26 = 1, 8 do
				table.insert(var8_26, table.remove(var5_26, 1))
			end

			table.insert(arg0_26.scrollDisplays, var8_26)
		end

		if #var5_26 > 0 then
			table.insert(arg0_26.scrollShowClassifyIds, iter5_26)
			table.insert(arg0_26.scrollShouldShowName, var7_26)

			local var9_26

			var9_26 = var6_26 or true

			table.insert(arg0_26.scrollDisplays, var5_26)
		end
	end

	arg0_26.indexDic = {}
	arg0_26.groupDic = {}
	arg0_26.goDic = {}

	if arg0_26.cards then
		for iter7_26, iter8_26 in ipairs(arg0_26.cards) do
			iter8_26:Dispose()
		end
	end

	arg0_26.cards = {}

	arg0_26.scrollrect:SetTotalCount(#arg0_26.scrollShowClassifyIds, 0)
end

function var0_0.IsSearchType(arg0_27, arg1_27, arg2_27)
	if not arg1_27 or arg1_27 == "" then
		return true
	end

	local var0_27 = arg2_27.id

	return ShipSkin.New({
		id = var0_27
	}):IsMatchKey(arg1_27)
end

function var0_0.SetFilterPanel(arg0_28)
	local var0_28 = arg0_28.filterContent:Find("own/options")
	local var1_28 = arg0_28.filterContent:Find("type/options")
	local var2_28 = arg0_28.filterContent:Find("shipHave/options")
	local var3_28 = arg0_28.filterContent:Find("camp/options")
	local var4_28 = arg0_28.filterContent:Find("rarity/options")
	local var5_28 = arg0_28.filterContent:Find("shipType/options")
	local var6_28 = arg0_28.filterContent:Find("themeType/options")

	arg0_28:SetOptionList(var3_28, ShipIndexConst.CampNames, true)
	arg0_28:SetOptionList(var4_28, ShipIndexConst.RarityNames, true)
	arg0_28:SetOptionList(var5_28, ShipIndexConst.TypeNames, true)
	arg0_28:SetOptionList(var6_28, arg0_28.classifyNames)
	arg0_28:SetSingleOptions(var0_28, "ownType")
	arg0_28:SetMultiOptions(var1_28, "typeType")
	arg0_28:SetSingleOptions(var2_28, "shipHaveType")
	arg0_28:SetMultiOptions(var3_28, "campType")
	arg0_28:SetMultiOptions(var4_28, "rarityType")
	arg0_28:SetMultiOptions(var5_28, "shipType")
	arg0_28:SetMultiOptions(var6_28, "themeType")
	onButton(arg0_28, arg0_28.filterUI:Find("bg"), function()
		for iter0_29, iter1_29 in pairs(arg0_28.filterValues) do
			arg0_28.filterValuesTemp[iter0_29] = Clone(arg0_28.filterValues[iter0_29])
		end

		setActive(arg0_28.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.filterUI:Find("panelMask/panel/closeBtn"), function()
		for iter0_30, iter1_30 in pairs(arg0_28.filterValues) do
			arg0_28.filterValuesTemp[iter0_30] = Clone(arg0_28.filterValues[iter0_30])
		end

		setActive(arg0_28.filterUI, false)
	end, SFX_PANEL)
	onButton(arg0_28, arg0_28.filterUI:Find("panelMask/panel/bottom/ok"), function()
		for iter0_31, iter1_31 in pairs(arg0_28.filterValues) do
			arg0_28.filterValues[iter0_31] = Clone(arg0_28.filterValuesTemp[iter0_31])
		end

		setActive(arg0_28.filterUI, false)
		arg0_28:Refresh()
	end, SFX_PANEL)
end

function var0_0.OpenFilterPanel(arg0_32)
	setActive(arg0_32.filterUI, true)

	local var0_32 = arg0_32.filterContent:Find("own/options")
	local var1_32 = arg0_32.filterContent:Find("type/options")
	local var2_32 = arg0_32.filterContent:Find("shipHave/options")
	local var3_32 = arg0_32.filterContent:Find("camp/options")
	local var4_32 = arg0_32.filterContent:Find("rarity/options")
	local var5_32 = arg0_32.filterContent:Find("shipType/options")
	local var6_32 = arg0_32.filterContent:Find("themeType/options")

	arg0_32:SetSingleOptions(var0_32, "ownType", true)
	arg0_32:SetMultiOptions(var1_32, "typeType", true)
	arg0_32:SetSingleOptions(var2_32, "shipHaveType", true)
	arg0_32:SetMultiOptions(var3_32, "campType", true)
	arg0_32:SetMultiOptions(var4_32, "rarityType", true)
	arg0_32:SetMultiOptions(var5_32, "shipType", true)
	arg0_32:SetMultiOptions(var6_32, "themeType", true)
end

function var0_0.SetOptionList(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = UIItemList.New(arg1_33, arg1_33:GetChild(0))

	var0_33:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = arg2_33[arg1_34 + 1]

			if arg3_33 then
				var0_34 = i18n(var0_34)
			end

			arg2_34.name = arg1_34

			setScrollText(arg2_34:Find("mask/Text"), var0_34)
		end
	end)
	var0_33:align(#arg2_33)
end

function var0_0.SetSingleOptions(arg0_35, arg1_35, arg2_35, arg3_35)
	for iter0_35 = 0, arg1_35.childCount - 1 do
		local var0_35 = arg1_35:GetChild(iter0_35)

		arg0_35:SetOptionSelect(arg1_35:GetChild(iter0_35), iter0_35 == arg0_35.filterValuesTemp[arg2_35])

		if not arg3_35 then
			onButton(arg0_35, var0_35, function()
				arg0_35.filterValuesTemp[arg2_35] = iter0_35

				for iter0_36 = 0, arg1_35.childCount - 1 do
					arg0_35:SetOptionSelect(arg1_35:GetChild(iter0_36), iter0_36 == iter0_35)
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetMultiOptions(arg0_37, arg1_37, arg2_37, arg3_37)
	for iter0_37 = 0, arg1_37.childCount - 1 do
		local var0_37 = arg1_37:GetChild(iter0_37)

		arg0_37:SetOptionSelect(arg1_37:GetChild(iter0_37), table.contains(arg0_37.filterValuesTemp[arg2_37], iter0_37))

		if not arg3_37 then
			onButton(arg0_37, var0_37, function()
				if iter0_37 == 0 then
					arg0_37.filterValuesTemp[arg2_37] = {
						0
					}

					for iter0_38 = 0, arg1_37.childCount - 1 do
						arg0_37:SetOptionSelect(arg1_37:GetChild(iter0_38), iter0_38 == 0)
					end
				else
					table.removebyvalue(arg0_37.filterValuesTemp[arg2_37], 0)

					if table.contains(arg0_37.filterValuesTemp[arg2_37], iter0_37) then
						table.removebyvalue(arg0_37.filterValuesTemp[arg2_37], iter0_37)
					else
						table.insert(arg0_37.filterValuesTemp[arg2_37], iter0_37)
					end

					local var0_38 = true

					for iter1_38 = 1, arg1_37.childCount - 1 do
						if not table.contains(arg0_37.filterValuesTemp[arg2_37], iter1_38) then
							var0_38 = false

							break
						end
					end

					if #arg0_37.filterValuesTemp[arg2_37] == 0 then
						var0_38 = true
					end

					if var0_38 then
						arg0_37.filterValuesTemp[arg2_37] = {
							0
						}
					end

					for iter2_38 = 0, arg1_37.childCount - 1 do
						arg0_37:SetOptionSelect(arg1_37:GetChild(iter2_38), table.contains(arg0_37.filterValuesTemp[arg2_37], iter2_38))
					end
				end
			end, SFX_PANEL)
		end
	end
end

function var0_0.SetOptionSelect(arg0_39, arg1_39, arg2_39)
	setActive(arg1_39:Find("selectedFrame"), arg2_39)

	local var0_39

	if IsNil(arg1_39:Find("Text")) then
		var0_39 = arg1_39:Find("mask/Text"):GetComponent(typeof(Text))
	else
		var0_39 = arg1_39:Find("Text"):GetComponent(typeof(Text))
	end

	if arg2_39 then
		var0_39.color = Color.New(1, 1, 1, 1)
	else
		var0_39.color = Color.New(0, 0, 0, 0.5)
	end
end

function var0_0.GetSkinClassify(arg0_40)
	arg0_40.classifyIds = Clone(pg.skin_page_template.all)

	table.insert(arg0_40.classifyIds, 1, var1_0)

	arg0_40.classifyNames = {}

	for iter0_40, iter1_40 in ipairs(arg0_40.classifyIds) do
		if iter1_40 == var1_0 then
			table.insert(arg0_40.classifyNames, i18n("index_all"))
		else
			table.insert(arg0_40.classifyNames, pg.skin_page_template[iter1_40].name)
		end
	end
end

function var0_0.filterOk(arg0_41, arg1_41)
	local var0_41 = arg0_41.filterValues.ownType
	local var1_41 = arg0_41.filterValues.typeType
	local var2_41 = arg0_41.filterValues.shipHaveType
	local var3_41 = arg0_41.filterValues.campType
	local var4_41 = arg0_41.filterValues.rarityType
	local var5_41 = arg0_41.filterValues.shipType
	local var6_41 = arg0_41.filterValues.themeType
	local var7_41 = arg1_41.id
	local var8_41 = arg1_41:GetDefaultShipConfig()

	if not var8_41 then
		return false
	end

	local var9_41 = arg0_41:ToVShip(var8_41)

	if var0_41 ~= 0 then
		local var10_41 = false
		local var11_41 = getProxy(ShipSkinProxy):hasSkin(var7_41)
		local var12_41 = arg1_41:NoUse()

		if var0_41 == 1 and var11_41 and var12_41 then
			var10_41 = true
		end

		if not var10_41 then
			return false
		end
	end

	if var1_41[1] ~= 0 then
		local var13_41 = false

		for iter0_41, iter1_41 in ipairs(var1_41) do
			if iter1_41 == 1 and (arg1_41:IsLive2d() or arg1_41:IsLive2dPlus()) then
				var13_41 = true
			end

			if iter1_41 == 2 and not arg1_41:IsLive2d() and not arg1_41:IsLive2dPlus() and not arg1_41:IsSpine() and not arg1_41:IsSpinePlus() then
				var13_41 = true
			end

			if iter1_41 == 3 and (arg1_41:IsSpine() or arg1_41:IsSpinePlus()) then
				var13_41 = true
			end

			if iter1_41 == 4 and arg1_41:IsBG() then
				var13_41 = true
			end

			if iter1_41 == 5 and arg1_41:IsDbg() then
				var13_41 = true
			end

			if iter1_41 == 6 and arg1_41:isBgm() then
				var13_41 = true
			end

			if var13_41 then
				break
			end
		end

		if not var13_41 then
			return false
		end
	end

	if var2_41 ~= 0 then
		local var14_41 = false
		local var15_41 = arg1_41:CantUse()

		if var2_41 == 1 and not var15_41 then
			var14_41 = true
		end

		if var2_41 == 2 and var15_41 then
			var14_41 = true
		end

		if not var14_41 then
			return false
		end
	end

	if var3_41[1] ~= 0 then
		local var16_41 = false

		for iter2_41, iter3_41 in ipairs(var3_41) do
			local var17_41 = ShipIndexCfg.camp

			for iter4_41, iter5_41 in ipairs(var17_41[iter3_41 + 1].types) do
				if iter5_41 == Nation.LINK then
					if var9_41:getNation() >= Nation.LINK then
						var16_41 = true
					end
				elseif iter5_41 == var9_41:getNation() then
					var16_41 = true
				end
			end

			if var16_41 then
				break
			end
		end

		if not var16_41 then
			return false
		end
	end

	if var4_41[1] ~= 0 then
		local var18_41 = false

		for iter6_41, iter7_41 in ipairs(var4_41) do
			local var19_41 = ShipIndexCfg.rarity

			if table.contains(var19_41[iter7_41 + 1].types, var9_41:getRarity()) then
				var18_41 = true
			end

			if var18_41 then
				break
			end
		end

		if not var18_41 then
			return false
		end
	end

	if var5_41[1] ~= 0 then
		local var20_41 = false

		for iter8_41, iter9_41 in ipairs(var5_41) do
			local var21_41 = ShipIndexCfg.type
			local var22_41 = var21_41[iter9_41 + 1].types

			if iter9_41 + 1 < 4 then
				local var23_41 = var21_41[iter9_41].shipTypes

				if table.contains(var22_41, var9_41:getShipType()) then
					var20_41 = true
				end

				if table.contains(var22_41, var9_41:getTeamType()) then
					var20_41 = true
				end
			elseif table.contains(var22_41, var9_41:getShipType()) then
				var20_41 = true
			end

			if var20_41 then
				break
			end
		end

		if not var20_41 then
			return false
		end
	end

	if var6_41[1] ~= 0 then
		local var24_41 = false

		for iter10_41, iter11_41 in ipairs(var6_41) do
			local var25_41 = arg0_41.classifyIds[iter11_41 + 1]

			if var25_41 == var1_0 then
				var24_41 = true
			else
				local var26_41 = arg0_41:GetShopTypeIdBySkinId(var7_41)

				var24_41 = (var26_41 == 0 and var2_0 or var26_41) == var25_41
			end

			if var24_41 then
				break
			end
		end

		if not var24_41 then
			return false
		end
	end

	return true
end

function var0_0.ToVShip(arg0_42, arg1_42)
	if not arg0_42.vship then
		arg0_42.vship = {}

		function arg0_42.vship.getNation()
			return arg0_42.vship.config.nationality
		end

		function arg0_42.vship.getShipType()
			return arg0_42.vship.config.type
		end

		function arg0_42.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_42.vship.config.type)
		end

		function arg0_42.vship.getRarity()
			return arg0_42.vship.config.rarity
		end
	end

	arg0_42.vship.config = arg1_42

	return arg0_42.vship
end

function var0_0.GetShopTypeIdBySkinId(arg0_47, arg1_47)
	local var0_47 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if not arg0_47.shopTypeIdList then
		arg0_47.shopTypeIdList = {}
	end

	if arg0_47.shopTypeIdList[arg1_47] then
		return arg0_47.shopTypeIdList[arg1_47]
	end

	for iter0_47, iter1_47 in pairs(var0_47) do
		for iter2_47, iter3_47 in ipairs(iter1_47) do
			arg0_47.shopTypeIdList[iter3_47] = iter0_47

			if iter3_47 == arg1_47 then
				return iter0_47
			end
		end
	end
end

function var0_0.willExit(arg0_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.cards) do
		iter1_48:Dispose()
	end

	arg0_48.cards = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48._tf)
end

function var0_0.onBackPressed(arg0_49)
	var0_0.super.onBackPressed(arg0_49)
end

return var0_0
