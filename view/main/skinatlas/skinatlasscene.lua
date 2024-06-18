local var0_0 = class("SkinAtlasScene", import("...base.BaseUI"))

var0_0.PAGE_ALL = -1
var0_0.ON_NEXT_SKIN = "SkinAtlasScene:ON_NEXT_SKIN"
var0_0.ON_PREV_SKIN = "SkinAtlasScene:ON_PREV_SKIN"

function var0_0.getUIName(arg0_1)
	return "SkinAtlasUI"
end

function var0_0.init(arg0_2)
	arg0_2.canvasGroup = arg0_2._tf:GetComponent(typeof(CanvasGroup))
	arg0_2.backBtn = arg0_2:findTF("adapt/top_panel/back_btn")
	arg0_2.homeBtn = arg0_2:findTF("adapt/top_panel/option")
	arg0_2.indexBtn = arg0_2:findTF("adapt/top_panel/index_btn")
	arg0_2.indexBtnSel = arg0_2.indexBtn:Find("sel")
	arg0_2.inptuTr = arg0_2:findTF("adapt/top_panel/search")
	arg0_2.emptyTr = arg0_2:findTF("adapt/main_panel/empty")

	local var0_2 = arg0_2:findTF("adapt/left_panel/mask/content/0")
	local var1_2 = arg0_2:findTF("adapt/left_panel")

	arg0_2.rollingCircleRect = RollingCircleRect.New(var0_2, var1_2)

	arg0_2.rollingCircleRect:SetCallback(arg0_2, var0_0.OnSelectSkinPage, var0_0.OnConfirmSkinPage)

	arg0_2.scrollrect = arg0_2:findTF("adapt/main_panel/scrollrect"):GetComponent("LScrollRect")
	arg0_2.previewPage = SkinAtlasPreviewPage.New(arg0_2._tf, arg0_2.event)

	setText(arg0_2:findTF("adapt/main_panel/empty/Text1"), i18n("skinatlas_search_result_is_empty"))
	setText(arg0_2:findTF("adapt/top_panel/search/holder"), i18n("skinatlas_search_holder"))

	arg0_2.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinAtlasIndexLayer.ExtraALL
	}
end

function var0_0.didEnter(arg0_3)
	arg0_3.cards = {}

	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:closeView()
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.indexBtn, function()
		arg0_3:emit(SkinAtlasMediator.OPEN_INDEX, {
			OnFilter = function(arg0_7)
				arg0_3:OnFilter(arg0_7)
			end,
			defaultIndex = arg0_3.defaultIndex
		})
	end, SFX_PANEL)
	arg0_3:bind(var0_0.ON_NEXT_SKIN, function(arg0_8, arg1_8)
		arg0_3:SwitchPreviewSkin(arg1_8 + 1)
	end)
	arg0_3:bind(var0_0.ON_PREV_SKIN, function(arg0_9, arg1_9)
		arg0_3:SwitchPreviewSkin(arg1_9 - 1)
	end)

	function arg0_3.scrollrect.onInitItem(arg0_10)
		arg0_3:OnInitItem(arg0_10)
	end

	function arg0_3.scrollrect.onUpdateItem(arg0_11, arg1_11)
		arg0_3:OnUpdateItem(arg0_11, arg1_11)
	end

	onInputChanged(arg0_3, arg0_3.inptuTr, function()
		arg0_3:OnSearch()
	end)
	arg0_3:InitSkinPages()
end

function var0_0.SwitchPreviewSkin(arg0_13, arg1_13)
	if arg0_13.displays and arg0_13.displays[arg1_13] then
		local var0_13 = arg0_13.displays[arg1_13]

		arg0_13.previewPage:ExecuteAction("Flush", var0_13, arg1_13)
	end
end

local function var1_0(arg0_14)
	local var0_14 = pg.skin_page_template
	local var1_14 = arg0_14:GetID()
	local var2_14 = var1_14 == var0_0.PAGE_ALL and "text_all" or "text_" .. var0_14[var1_14].res

	LoadSpriteAtlasAsync("SkinClassified", var2_14 .. "01", function(arg0_15)
		local var0_15 = arg0_14._tr:Find("name"):GetComponent(typeof(Image))

		var0_15.sprite = arg0_15

		var0_15:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2_14, function(arg0_16)
		local var0_16 = arg0_14._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0_16.sprite = arg0_16

		var0_16:SetNativeSize()
	end)
	setText(arg0_14._tr:Find("eng"), var1_14 == var0_0.PAGE_ALL and "ALL" or var0_14[var1_14].english_name)
end

function var0_0.InitSkinPages(arg0_17, arg1_17)
	local var0_17 = Clone(pg.skin_page_template.all)

	table.insert(var0_17, 1, var0_0.PAGE_ALL)

	arg0_17.canvasGroup.blocksRaycasts = false

	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		table.insert(var1_17, function(arg0_18)
			local var0_18 = arg0_17.rollingCircleRect:AddItem(iter1_17)

			var1_0(var0_18)

			if (iter0_17 - 1) % 3 == 0 or iter0_17 == #var0_17 then
				onNextTick(arg0_18)
			else
				arg0_18()
			end
		end)
	end

	seriesAsync(var1_17, function()
		setActive(arg0_17.scrollrect.gameObject, true)
		arg0_17.rollingCircleRect:ScrollTo(var0_0.PAGE_ALL)

		arg0_17.canvasGroup.blocksRaycasts = true
	end)
end

function var0_0.OnSelectSkinPage(arg0_20, arg1_20)
	if arg0_20.selectedSkinPageItem then
		setActive(arg0_20.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0_20.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1_20._tr:Find("selected"), true)
	setActive(arg1_20._tr:Find("name"), false)

	arg0_20.selectedSkinPageItem = arg1_20
end

function var0_0.OnConfirmSkinPage(arg0_21, arg1_21)
	arg0_21.skinPageID = arg1_21:GetID()

	arg0_21:UpdateSkinCards()
end

function var0_0.OnSearch(arg0_22)
	arg0_22:UpdateSkinCards()
end

function var0_0.OnFilter(arg0_23, arg1_23)
	arg0_23.defaultIndex = {
		typeIndex = arg1_23.typeIndex,
		campIndex = arg1_23.campIndex,
		rarityIndex = arg1_23.rarityIndex,
		extraIndex = arg1_23.extraIndex
	}

	arg0_23:UpdateSkinCards()
	setActive(arg0_23.indexBtnSel, arg1_23.typeIndex ~= ShipIndexConst.TypeAll or arg1_23.campIndex ~= ShipIndexConst.CampAll or arg1_23.rarityIndex ~= ShipIndexConst.RarityAll or arg1_23.extraIndex ~= SkinAtlasIndexLayer.ExtraALL)
end

function var0_0.ToVShip(arg0_24, arg1_24)
	if not arg0_24.vship then
		arg0_24.vship = {}

		function arg0_24.vship.getNation()
			return arg0_24.vship.config.nationality
		end

		function arg0_24.vship.getShipType()
			return arg0_24.vship.config.type
		end

		function arg0_24.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_24.vship.config.type)
		end

		function arg0_24.vship.getRarity()
			return arg0_24.vship.config.rarity
		end
	end

	arg0_24.vship.config = arg1_24

	return arg0_24.vship
end

function var0_0.MatchIndex(arg0_29, arg1_29)
	local var0_29 = arg1_29:GetDefaultShipConfig()

	if not var0_29 then
		return false
	end

	local var1_29 = arg0_29:ToVShip(var0_29)
	local var2_29 = ShipIndexConst.filterByType(var1_29, arg0_29.defaultIndex.typeIndex)
	local var3_29 = ShipIndexConst.filterByCamp(var1_29, arg0_29.defaultIndex.campIndex)
	local var4_29 = ShipIndexConst.filterByRarity(var1_29, arg0_29.defaultIndex.rarityIndex)
	local var5_29 = SkinAtlasIndexLayer.filterByExtra(arg1_29, arg0_29.defaultIndex.extraIndex)

	return var2_29 and var3_29 and var4_29 and var5_29
end

function var0_0.GetSkinList(arg0_30, arg1_30, arg2_30)
	local var0_30 = {}
	local var1_30 = getProxy(ShipSkinProxy):GetOwnSkins()

	for iter0_30, iter1_30 in pairs(var1_30) do
		if (arg1_30 == var0_0.PAGE_ALL or iter1_30:IsType(arg1_30)) and not iter1_30:IsDefault() and iter1_30:IsMatchKey(arg2_30) and arg0_30:MatchIndex(iter1_30) then
			table.insert(var0_30, iter1_30)
		end
	end

	return var0_30
end

function var0_0.UpdateSkinCards(arg0_31)
	local var0_31 = arg0_31.skinPageID
	local var1_31 = getInputText(arg0_31.inptuTr)

	arg0_31.displays = arg0_31:GetSkinList(var0_31, var1_31)

	arg0_31:SortDisplay(arg0_31.displays)
	arg0_31.scrollrect:SetTotalCount(#arg0_31.displays)
	setActive(arg0_31.emptyTr, #arg0_31.displays == 0)
end

function var0_0.SortDisplay(arg0_32, arg1_32)
	table.sort(arg1_32, function(arg0_33, arg1_33)
		local var0_33 = arg0_33:getConfig("ship_group")
		local var1_33 = arg1_33:getConfig("ship_group")

		if var0_33 == var1_33 then
			return arg0_33:getConfig("group_index") < arg1_33:getConfig("group_index")
		else
			return var0_33 < var1_33
		end
	end)
end

function var0_0.OnInitItem(arg0_34, arg1_34)
	local var0_34 = SkinAtlasCard.New(arg1_34)

	onButton(arg0_34, var0_34._tf, function()
		arg0_34.previewPage:ExecuteAction("Show", var0_34.skin, var0_34.index)
	end, SFX_PANEL)

	arg0_34.cards[arg1_34] = var0_34
end

function var0_0.OnUpdateItem(arg0_36, arg1_36, arg2_36)
	if not arg0_36.cards[arg2_36] then
		arg0_36:OnInitItem(arg2_36)
	end

	arg0_36.cards[arg2_36]:Update(arg0_36.displays[arg1_36 + 1], arg1_36 + 1)
end

function var0_0.onBackPressed(arg0_37)
	if arg0_37.previewPage and arg0_37.previewPage:GetLoaded() and arg0_37.previewPage:isShowing() then
		if arg0_37.previewPage:IsShowSelectShipView() then
			arg0_37.previewPage:CloseSelectShipView()

			return
		end

		arg0_37.previewPage:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_37)
end

function var0_0.willExit(arg0_38)
	for iter0_38, iter1_38 in pairs(arg0_38.cards) do
		iter1_38:Dispose()
	end

	arg0_38.cards = nil

	if arg0_38.rollingCircleRect then
		arg0_38.rollingCircleRect:Dispose()

		arg0_38.rollingCircleRect = nil
	end

	if arg0_38.previewPage then
		arg0_38.previewPage:Destroy()

		arg0_38.previewPage = nil
	end
end

return var0_0
