local var0 = class("SkinAtlasScene", import("...base.BaseUI"))

var0.PAGE_ALL = -1
var0.ON_NEXT_SKIN = "SkinAtlasScene:ON_NEXT_SKIN"
var0.ON_PREV_SKIN = "SkinAtlasScene:ON_PREV_SKIN"

function var0.getUIName(arg0)
	return "SkinAtlasUI"
end

function var0.init(arg0)
	arg0.canvasGroup = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.backBtn = arg0:findTF("adapt/top_panel/back_btn")
	arg0.homeBtn = arg0:findTF("adapt/top_panel/option")
	arg0.indexBtn = arg0:findTF("adapt/top_panel/index_btn")
	arg0.indexBtnSel = arg0.indexBtn:Find("sel")
	arg0.inptuTr = arg0:findTF("adapt/top_panel/search")
	arg0.emptyTr = arg0:findTF("adapt/main_panel/empty")

	local var0 = arg0:findTF("adapt/left_panel/mask/content/0")
	local var1 = arg0:findTF("adapt/left_panel")

	arg0.rollingCircleRect = RollingCircleRect.New(var0, var1)

	arg0.rollingCircleRect:SetCallback(arg0, var0.OnSelectSkinPage, var0.OnConfirmSkinPage)

	arg0.scrollrect = arg0:findTF("adapt/main_panel/scrollrect"):GetComponent("LScrollRect")
	arg0.previewPage = SkinAtlasPreviewPage.New(arg0._tf, arg0.event)

	setText(arg0:findTF("adapt/main_panel/empty/Text1"), i18n("skinatlas_search_result_is_empty"))
	setText(arg0:findTF("adapt/top_panel/search/holder"), i18n("skinatlas_search_holder"))

	arg0.defaultIndex = {
		typeIndex = ShipIndexConst.TypeAll,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = SkinAtlasIndexLayer.ExtraALL
	}
end

function var0.didEnter(arg0)
	arg0.cards = {}

	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.indexBtn, function()
		arg0:emit(SkinAtlasMediator.OPEN_INDEX, {
			OnFilter = function(arg0)
				arg0:OnFilter(arg0)
			end,
			defaultIndex = arg0.defaultIndex
		})
	end, SFX_PANEL)
	arg0:bind(var0.ON_NEXT_SKIN, function(arg0, arg1)
		arg0:SwitchPreviewSkin(arg1 + 1)
	end)
	arg0:bind(var0.ON_PREV_SKIN, function(arg0, arg1)
		arg0:SwitchPreviewSkin(arg1 - 1)
	end)

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	onInputChanged(arg0, arg0.inptuTr, function()
		arg0:OnSearch()
	end)
	arg0:InitSkinPages()
end

function var0.SwitchPreviewSkin(arg0, arg1)
	if arg0.displays and arg0.displays[arg1] then
		local var0 = arg0.displays[arg1]

		arg0.previewPage:ExecuteAction("Flush", var0, arg1)
	end
end

local function var1(arg0)
	local var0 = pg.skin_page_template
	local var1 = arg0:GetID()
	local var2 = var1 == var0.PAGE_ALL and "text_all" or "text_" .. var0[var1].res

	LoadSpriteAtlasAsync("SkinClassified", var2 .. "01", function(arg0)
		local var0 = arg0._tr:Find("name"):GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
	end)
	LoadSpriteAtlasAsync("SkinClassified", var2, function(arg0)
		local var0 = arg0._tr:Find("selected/Image"):GetComponent(typeof(Image))

		var0.sprite = arg0

		var0:SetNativeSize()
	end)
	setText(arg0._tr:Find("eng"), var1 == var0.PAGE_ALL and "ALL" or var0[var1].english_name)
end

function var0.InitSkinPages(arg0, arg1)
	local var0 = Clone(pg.skin_page_template.all)

	table.insert(var0, 1, var0.PAGE_ALL)

	arg0.canvasGroup.blocksRaycasts = false

	local var1 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var1, function(arg0)
			local var0 = arg0.rollingCircleRect:AddItem(iter1)

			var1(var0)

			if (iter0 - 1) % 3 == 0 or iter0 == #var0 then
				onNextTick(arg0)
			else
				arg0()
			end
		end)
	end

	seriesAsync(var1, function()
		setActive(arg0.scrollrect.gameObject, true)
		arg0.rollingCircleRect:ScrollTo(var0.PAGE_ALL)

		arg0.canvasGroup.blocksRaycasts = true
	end)
end

function var0.OnSelectSkinPage(arg0, arg1)
	if arg0.selectedSkinPageItem then
		setActive(arg0.selectedSkinPageItem._tr:Find("selected"), false)
		setActive(arg0.selectedSkinPageItem._tr:Find("name"), true)
	end

	setActive(arg1._tr:Find("selected"), true)
	setActive(arg1._tr:Find("name"), false)

	arg0.selectedSkinPageItem = arg1
end

function var0.OnConfirmSkinPage(arg0, arg1)
	arg0.skinPageID = arg1:GetID()

	arg0:UpdateSkinCards()
end

function var0.OnSearch(arg0)
	arg0:UpdateSkinCards()
end

function var0.OnFilter(arg0, arg1)
	arg0.defaultIndex = {
		typeIndex = arg1.typeIndex,
		campIndex = arg1.campIndex,
		rarityIndex = arg1.rarityIndex,
		extraIndex = arg1.extraIndex
	}

	arg0:UpdateSkinCards()
	setActive(arg0.indexBtnSel, arg1.typeIndex ~= ShipIndexConst.TypeAll or arg1.campIndex ~= ShipIndexConst.CampAll or arg1.rarityIndex ~= ShipIndexConst.RarityAll or arg1.extraIndex ~= SkinAtlasIndexLayer.ExtraALL)
end

function var0.ToVShip(arg0, arg1)
	if not arg0.vship then
		arg0.vship = {}

		function arg0.vship.getNation()
			return arg0.vship.config.nationality
		end

		function arg0.vship.getShipType()
			return arg0.vship.config.type
		end

		function arg0.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0.vship.config.type)
		end

		function arg0.vship.getRarity()
			return arg0.vship.config.rarity
		end
	end

	arg0.vship.config = arg1

	return arg0.vship
end

function var0.MatchIndex(arg0, arg1)
	local var0 = arg1:GetDefaultShipConfig()

	if not var0 then
		return false
	end

	local var1 = arg0:ToVShip(var0)
	local var2 = ShipIndexConst.filterByType(var1, arg0.defaultIndex.typeIndex)
	local var3 = ShipIndexConst.filterByCamp(var1, arg0.defaultIndex.campIndex)
	local var4 = ShipIndexConst.filterByRarity(var1, arg0.defaultIndex.rarityIndex)
	local var5 = SkinAtlasIndexLayer.filterByExtra(arg1, arg0.defaultIndex.extraIndex)

	return var2 and var3 and var4 and var5
end

function var0.GetSkinList(arg0, arg1, arg2)
	local var0 = {}
	local var1 = getProxy(ShipSkinProxy):GetOwnSkins()

	for iter0, iter1 in pairs(var1) do
		if (arg1 == var0.PAGE_ALL or iter1:IsType(arg1)) and not iter1:IsDefault() and iter1:IsMatchKey(arg2) and arg0:MatchIndex(iter1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.UpdateSkinCards(arg0)
	local var0 = arg0.skinPageID
	local var1 = getInputText(arg0.inptuTr)

	arg0.displays = arg0:GetSkinList(var0, var1)

	arg0:SortDisplay(arg0.displays)
	arg0.scrollrect:SetTotalCount(#arg0.displays)
	setActive(arg0.emptyTr, #arg0.displays == 0)
end

function var0.SortDisplay(arg0, arg1)
	table.sort(arg1, function(arg0, arg1)
		local var0 = arg0:getConfig("ship_group")
		local var1 = arg1:getConfig("ship_group")

		if var0 == var1 then
			return arg0:getConfig("group_index") < arg1:getConfig("group_index")
		else
			return var0 < var1
		end
	end)
end

function var0.OnInitItem(arg0, arg1)
	local var0 = SkinAtlasCard.New(arg1)

	onButton(arg0, var0._tf, function()
		arg0.previewPage:ExecuteAction("Show", var0.skin, var0.index)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	if not arg0.cards[arg2] then
		arg0:OnInitItem(arg2)
	end

	arg0.cards[arg2]:Update(arg0.displays[arg1 + 1], arg1 + 1)
end

function var0.onBackPressed(arg0)
	if arg0.previewPage and arg0.previewPage:GetLoaded() and arg0.previewPage:isShowing() then
		if arg0.previewPage:IsShowSelectShipView() then
			arg0.previewPage:CloseSelectShipView()

			return
		end

		arg0.previewPage:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	if arg0.rollingCircleRect then
		arg0.rollingCircleRect:Dispose()

		arg0.rollingCircleRect = nil
	end

	if arg0.previewPage then
		arg0.previewPage:Destroy()

		arg0.previewPage = nil
	end
end

return var0
