local var0 = class("BackYardThemePage", import(".BackYardShopBasePage"))

function var0.getUIName(arg0)
	return "BackYardThemePage"
end

function var0.OnLoaded(arg0)
	arg0:LoadList()
	arg0:LoadDetail()

	arg0.largeSpLoader = BackYardLargeSpriteLoader.New(6)
end

function var0.LoadList(arg0)
	arg0._parentTF = arg0._tf.parent
	arg0.adpter = arg0:findTF("adpter")
	arg0.themeContainer = arg0:findTF("list/frame")
	arg0.scrollRect = arg0:findTF("list/frame/mask"):GetComponent("LScrollRect")
	arg0.scrollRectWidth = arg0:findTF("list/frame/mask").rect.width
	arg0.searchInput = arg0:findTF("adpter/search")
	arg0.searchClear = arg0.searchInput:Find("clear")

	setText(arg0.searchInput:Find("Placeholder"), i18n("courtyard_label_search_holder"))
end

function var0.LoadDetail(arg0)
	arg0.purchaseBtn = arg0:findTF("adpter/descript/btn_goumai")
	arg0.title = arg0:findTF("adpter/descript/title"):GetComponent(typeof(Text))
	arg0.desc = arg0:findTF("adpter/descript/desc"):GetComponent(typeof(Text))
	arg0.actualPrice = arg0:findTF("adpter/descript/price/actual_price")
	arg0.actualPriceTxt = arg0:findTF("adpter/descript/price/actual_price/Text"):GetComponent(typeof(Text))
	arg0.goldTxt = arg0:findTF("adpter/descript/price/price/Text"):GetComponent(typeof(Text))
	arg0.preview = arg0:findTF("preview"):GetComponent(typeof(Image))
	arg0.descript = arg0:findTF("adpter/descript")
	arg0.infoPage = BackYardThemeInfoPage.New(arg0._tf.parent, arg0.event, arg0.contextData)

	function arg0.infoPage.OnEnter()
		arg0:UnBlurView()
	end

	function arg0.infoPage.OnExit()
		arg0:BlurView()
	end

	function arg0.infoPage.OnPrevTheme()
		arg0:OnInfoPagePrevTheme()
	end

	function arg0.infoPage.OnNextTheme()
		arg0:OnInfoPageNextTheme()
	end

	onButton(arg0, arg0.purchaseBtn, function()
		local var0 = arg0:GetSelectedIndex()

		arg0.infoPage:ExecuteAction("SetUp", var0, arg0.selected, arg0.dorm, arg0.player)
	end, SFX_PANEL)
	setText(arg0.purchaseBtn:Find("Text"), i18n("word_buy"))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitCard(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateCard(arg0, arg1)
	end

	arg0:InitInput()
	onButton(arg0, arg0.searchClear, function()
		setInputText(arg0.searchInput, "")
	end, SFX_PANEL)
end

function var0.InitInput(arg0)
	onInputChanged(arg0, arg0.searchInput, function()
		local var0 = getInputText(arg0.searchInput)

		setActive(arg0.searchClear, var0 ~= "")
		arg0:OnSearchKeyChange()
	end)
end

function var0.GetData(arg0)
	local var0 = {}
	local var1 = getProxy(DormProxy):GetSystemThemes()
	local var2 = getInputText(arg0.searchInput)
	local var3 = arg0.dorm:GetPurchasedFurnitures()
	local var4 = {}

	for iter0, iter1 in ipairs(var1) do
		if not iter1:IsOverTime() and iter1:MatchSearchKey(var2) then
			table.insert(var0, iter1)

			var4[iter1.id] = iter1:IsPurchased(var3) and 1 or 0
		end
	end

	local var5 = pg.backyard_theme_template

	local function var6(arg0, arg1)
		if var5[arg0.id].hot == var5[arg1.id].hot then
			return var5[arg0.id].order > var5[arg1.id].order
		else
			return var5[arg0.id].hot > var5[arg1.id].hot
		end
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = var4[arg0.id]
		local var1 = var4[arg1.id]

		if var0 == var1 then
			if var5[arg0.id].new == var5[arg1.id].new then
				return var6(arg0, arg1)
			else
				return var5[arg0.id].new > var5[arg1.id].new
			end
		else
			return var0 < var1
		end
	end)

	return var0
end

function var0.FurnituresUpdated(arg0, arg1)
	if arg0.infoPage:GetLoaded() then
		arg0.infoPage:ExecuteAction("FurnituresUpdated", arg1)
	end

	if arg0.card then
		arg0:UpdatePrice(arg0.card)
	end

	arg0:InitThemeList()
end

function var0.OnDormUpdated(arg0)
	if arg0.infoPage:GetLoaded() then
		arg0.infoPage:ExecuteAction("DormUpdated", arg0.dorm)
	end
end

function var0.OnPlayerUpdated(arg0)
	if arg0.infoPage:GetLoaded() then
		arg0.infoPage:ExecuteAction("OnPlayerUpdated", arg0.player)
	end
end

function var0.OnSetUp(arg0)
	arg0:InitThemeList()
	arg0:BlurView()
end

function var0.InitThemeList(arg0)
	arg0.disPlays = arg0:GetData()

	onNextTick(function()
		arg0.scrollRect:SetTotalCount(#arg0.disPlays)
	end)
end

function var0.OnSearchKeyChange(arg0)
	arg0:InitThemeList()
end

function var0.CreateCard(arg0, arg1)
	return (BackYardThemeCard.New(arg1))
end

function var0.OnInitCard(arg0, arg1)
	local var0 = arg0:CreateCard(arg1)

	onButton(arg0, var0._go, function()
		arg0:OnCardClick(var0)

		local var0 = arg0.selected

		arg0.selected = var0.themeVO

		if var0 then
			for iter0, iter1 in pairs(arg0.cards) do
				if iter1.themeVO.id == var0.id and iter1._go.name ~= "-1" then
					preCard = iter1

					break
				end
			end

			if preCard then
				preCard:UpdateSelected(arg0.selected)
			end
		end

		var0:UpdateSelected(arg0.selected)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateCard(arg0, arg1, arg2)
	if not arg0.cards[arg2] then
		arg0:OnInitCard(arg2)
	end

	local var0 = arg0.cards[arg2]
	local var1 = arg0.dorm:GetPurchasedFurnitures()
	local var2 = arg0.disPlays[arg1 + 1]

	var0:Update(var2, var2:IsPurchased(var1))
	var0:UpdateSelected(arg0.selected)

	if arg0:NoSelected() and arg1 == 0 then
		triggerButton(var0._go)
	end
end

function var0.NoSelected(arg0)
	return not arg0.selected or not _.any(arg0.disPlays, function(arg0)
		return arg0.id == arg0.selected.id
	end)
end

function var0.OnCardClick(arg0, arg1)
	arg0:UpdateMainPage(arg1.themeVO)
end

function var0.UpdateMainPage(arg0, arg1)
	if arg1 == arg0.card then
		return
	end

	local var0 = arg1:getConfig("name")
	local var1 = string.gsub(var0, "<size=%d+>", "")

	arg0.title.text = string.gsub(var1, "</size>", "")
	arg0.desc.text = arg1:getConfig("desc")

	local var2 = arg1:getConfig("discount")
	local var3 = arg1:HasDiscount()

	setActive(arg0.actualPrice, var3)
	arg0:UpdatePrice(arg1)
	arg0.largeSpLoader:LoadSpriteAsync("BackYardTheme/theme_" .. arg1.id, function(arg0)
		if IsNil(arg0.preview) then
			return
		end

		arg0.preview.sprite = arg0
		arg0.preview.enabled = true
	end)

	arg0.card = arg1
end

function var0.UpdatePrice(arg0, arg1)
	local var0, var1 = arg0:CalcThemePrice(arg1)

	arg0.actualPriceTxt.text = var1
	arg0.goldTxt.text = var0
end

function var0.GetAddList(arg0, arg1)
	local var0 = {}
	local var1 = arg1:GetFurnitures()
	local var2 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in ipairs(var1) do
		if not var2[iter1] then
			table.insert(var0, Furniture.New({
				id = iter1
			}))
		end
	end

	return var0
end

function var0.CalcThemePrice(arg0, arg1)
	local var0 = arg0:GetAddList(arg1)
	local var1 = 0
	local var2 = 0

	for iter0, iter1 in ipairs(var0) do
		var2 = var2 + iter1:getConfig("dorm_icon_price")
		var1 = var1 + iter1:getPrice(PlayerConst.ResDormMoney)
	end

	return var1, var2
end

local function var1(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0) do
		if iter1.themeVO.id == arg1.id then
			var0 = iter1

			break
		end
	end

	return var0
end

local function var2(arg0, arg1, arg2)
	local var0 = arg0:HeadIndexToValue(arg1)
	local var1 = arg0:HeadIndexToValue(arg2)

	return math.abs(var1 - var0)
end

function var0.GetSelectedIndex(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.disPlays) do
		if iter1.id == arg0.selected.id then
			var0 = iter0

			break
		end
	end

	return var0
end

function var0.OnSwitchToNextTheme(arg0)
	local var0 = arg0:GetSelectedIndex()

	if var0 >= #arg0.disPlays then
		return false
	end

	local var1 = arg0.disPlays[var0 + 1]
	local var2 = var1(arg0.cards, var1)

	local function var3(arg0)
		return go(arg0.scrollRect).transform.localPosition.x + arg0.scrollRectWidth / 2 < go(arg0.scrollRect).transform.parent:InverseTransformPoint(arg0._tf.position).x
	end

	if not var2 or var2 and var3(var2) then
		local var4 = var2(arg0.scrollRect, 1, 2)

		arg0.scrollRect:ScrollTo(arg0.scrollRect.value + var4, true)

		var2 = var1(arg0.cards, var1)
	end

	if var2 then
		triggerButton(var2._go)
	end

	return true
end

function var0.OnSwitchToPrevTheme(arg0)
	local var0 = arg0:GetSelectedIndex()

	if var0 <= 1 then
		return false
	end

	local var1 = arg0.disPlays[var0 - 1]
	local var2 = var1(arg0.cards, var1)

	local function var3(arg0)
		return go(arg0.scrollRect).transform.localPosition.x - arg0.scrollRectWidth / 2 > go(arg0.scrollRect).transform.parent:InverseTransformPoint(arg0._tf.position).x
	end

	if not var2 or var2 and var3(var2) then
		local var4 = var2(arg0.scrollRect, 1, 2)

		arg0.scrollRect:ScrollTo(arg0.scrollRect.value - var4, true)

		var2 = var1(arg0.cards, var1)
	end

	if var2 then
		triggerButton(var2._go)
	end

	return true
end

function var0.OnInfoPagePrevTheme(arg0)
	if arg0:OnSwitchToPrevTheme() then
		triggerButton(arg0.purchaseBtn)
	end
end

function var0.OnInfoPageNextTheme(arg0)
	if arg0:OnSwitchToNextTheme() then
		triggerButton(arg0.purchaseBtn)
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:UnBlurView()
end

function var0.BlurView(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.adpter, {
		pbList = {
			arg0:findTF("adpter/descript")
		},
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.UnBlurView(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.adpter, arg0._tf)
end

function var0.OnDestroy(arg0)
	if arg0.largeSpLoader then
		arg0.largeSpLoader:Dispose()

		arg0.largeSpLoader = nil
	end

	if arg0.infoPage then
		arg0.infoPage.OnExit = nil
		arg0.infoPage.OnEnter = nil
		arg0.infoPage.OnPrevTheme = nil
		arg0.infoPage.OnNextTheme = nil

		arg0.infoPage:Destroy()
	end

	for iter0, iter1 in pairs(arg0.cards or {}) do
		iter1:Dispose()
	end

	arg0.cards = nil

	arg0:Hide()
end

return var0
