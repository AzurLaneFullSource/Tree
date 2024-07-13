local var0_0 = class("BackYardThemePage", import(".BackYardShopBasePage"))

function var0_0.getUIName(arg0_1)
	return "BackYardThemePage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2:LoadList()
	arg0_2:LoadDetail()

	arg0_2.largeSpLoader = BackYardLargeSpriteLoader.New(6)
end

function var0_0.LoadList(arg0_3)
	arg0_3._parentTF = arg0_3._tf.parent
	arg0_3.adpter = arg0_3:findTF("adpter")
	arg0_3.themeContainer = arg0_3:findTF("list/frame")
	arg0_3.scrollRect = arg0_3:findTF("list/frame/mask"):GetComponent("LScrollRect")
	arg0_3.scrollRectWidth = arg0_3:findTF("list/frame/mask").rect.width
	arg0_3.searchInput = arg0_3:findTF("adpter/search")
	arg0_3.searchClear = arg0_3.searchInput:Find("clear")

	setText(arg0_3.searchInput:Find("Placeholder"), i18n("courtyard_label_search_holder"))
end

function var0_0.LoadDetail(arg0_4)
	arg0_4.purchaseBtn = arg0_4:findTF("adpter/descript/btn_goumai")
	arg0_4.title = arg0_4:findTF("adpter/descript/title"):GetComponent(typeof(Text))
	arg0_4.desc = arg0_4:findTF("adpter/descript/desc"):GetComponent(typeof(Text))
	arg0_4.actualPrice = arg0_4:findTF("adpter/descript/price/actual_price")
	arg0_4.actualPriceTxt = arg0_4:findTF("adpter/descript/price/actual_price/Text"):GetComponent(typeof(Text))
	arg0_4.goldTxt = arg0_4:findTF("adpter/descript/price/price/Text"):GetComponent(typeof(Text))
	arg0_4.preview = arg0_4:findTF("preview"):GetComponent(typeof(Image))
	arg0_4.descript = arg0_4:findTF("adpter/descript")
	arg0_4.infoPage = BackYardThemeInfoPage.New(arg0_4._tf.parent, arg0_4.event, arg0_4.contextData)

	function arg0_4.infoPage.OnEnter()
		arg0_4:UnBlurView()
	end

	function arg0_4.infoPage.OnExit()
		arg0_4:BlurView()
	end

	function arg0_4.infoPage.OnPrevTheme()
		arg0_4:OnInfoPagePrevTheme()
	end

	function arg0_4.infoPage.OnNextTheme()
		arg0_4:OnInfoPageNextTheme()
	end

	onButton(arg0_4, arg0_4.purchaseBtn, function()
		local var0_9 = arg0_4:GetSelectedIndex()

		arg0_4.infoPage:ExecuteAction("SetUp", var0_9, arg0_4.selected, arg0_4.dorm, arg0_4.player)
	end, SFX_PANEL)
	setText(arg0_4.purchaseBtn:Find("Text"), i18n("word_buy"))
end

function var0_0.OnInit(arg0_10)
	arg0_10.cards = {}

	function arg0_10.scrollRect.onInitItem(arg0_11)
		arg0_10:OnInitCard(arg0_11)
	end

	function arg0_10.scrollRect.onUpdateItem(arg0_12, arg1_12)
		arg0_10:OnUpdateCard(arg0_12, arg1_12)
	end

	arg0_10:InitInput()
	onButton(arg0_10, arg0_10.searchClear, function()
		setInputText(arg0_10.searchInput, "")
	end, SFX_PANEL)
end

function var0_0.InitInput(arg0_14)
	onInputChanged(arg0_14, arg0_14.searchInput, function()
		local var0_15 = getInputText(arg0_14.searchInput)

		setActive(arg0_14.searchClear, var0_15 ~= "")
		arg0_14:OnSearchKeyChange()
	end)
end

function var0_0.GetData(arg0_16)
	local var0_16 = {}
	local var1_16 = getProxy(DormProxy):GetSystemThemes()
	local var2_16 = getInputText(arg0_16.searchInput)
	local var3_16 = arg0_16.dorm:GetPurchasedFurnitures()
	local var4_16 = {}

	for iter0_16, iter1_16 in ipairs(var1_16) do
		if not iter1_16:IsOverTime() and iter1_16:MatchSearchKey(var2_16) then
			table.insert(var0_16, iter1_16)

			var4_16[iter1_16.id] = iter1_16:IsPurchased(var3_16) and 1 or 0
		end
	end

	local var5_16 = pg.backyard_theme_template

	local function var6_16(arg0_17, arg1_17)
		if var5_16[arg0_17.id].hot == var5_16[arg1_17.id].hot then
			return var5_16[arg0_17.id].order > var5_16[arg1_17.id].order
		else
			return var5_16[arg0_17.id].hot > var5_16[arg1_17.id].hot
		end
	end

	table.sort(var0_16, function(arg0_18, arg1_18)
		local var0_18 = var4_16[arg0_18.id]
		local var1_18 = var4_16[arg1_18.id]

		if var0_18 == var1_18 then
			if var5_16[arg0_18.id].new == var5_16[arg1_18.id].new then
				return var6_16(arg0_18, arg1_18)
			else
				return var5_16[arg0_18.id].new > var5_16[arg1_18.id].new
			end
		else
			return var0_18 < var1_18
		end
	end)

	return var0_16
end

function var0_0.FurnituresUpdated(arg0_19, arg1_19)
	if arg0_19.infoPage:GetLoaded() then
		arg0_19.infoPage:ExecuteAction("FurnituresUpdated", arg1_19)
	end

	if arg0_19.card then
		arg0_19:UpdatePrice(arg0_19.card)
	end

	arg0_19:InitThemeList()
end

function var0_0.OnDormUpdated(arg0_20)
	if arg0_20.infoPage:GetLoaded() then
		arg0_20.infoPage:ExecuteAction("DormUpdated", arg0_20.dorm)
	end
end

function var0_0.OnPlayerUpdated(arg0_21)
	if arg0_21.infoPage:GetLoaded() then
		arg0_21.infoPage:ExecuteAction("OnPlayerUpdated", arg0_21.player)
	end
end

function var0_0.OnSetUp(arg0_22)
	arg0_22:InitThemeList()
	arg0_22:BlurView()
end

function var0_0.InitThemeList(arg0_23)
	arg0_23.disPlays = arg0_23:GetData()

	onNextTick(function()
		arg0_23.scrollRect:SetTotalCount(#arg0_23.disPlays)
	end)
end

function var0_0.OnSearchKeyChange(arg0_25)
	arg0_25:InitThemeList()
end

function var0_0.CreateCard(arg0_26, arg1_26)
	return (BackYardThemeCard.New(arg1_26))
end

function var0_0.OnInitCard(arg0_27, arg1_27)
	local var0_27 = arg0_27:CreateCard(arg1_27)

	onButton(arg0_27, var0_27._go, function()
		arg0_27:OnCardClick(var0_27)

		local var0_28 = arg0_27.selected

		arg0_27.selected = var0_27.themeVO

		if var0_28 then
			for iter0_28, iter1_28 in pairs(arg0_27.cards) do
				if iter1_28.themeVO.id == var0_28.id and iter1_28._go.name ~= "-1" then
					preCard = iter1_28

					break
				end
			end

			if preCard then
				preCard:UpdateSelected(arg0_27.selected)
			end
		end

		var0_27:UpdateSelected(arg0_27.selected)
	end, SFX_PANEL)

	arg0_27.cards[arg1_27] = var0_27
end

function var0_0.OnUpdateCard(arg0_29, arg1_29, arg2_29)
	if not arg0_29.cards[arg2_29] then
		arg0_29:OnInitCard(arg2_29)
	end

	local var0_29 = arg0_29.cards[arg2_29]
	local var1_29 = arg0_29.dorm:GetPurchasedFurnitures()
	local var2_29 = arg0_29.disPlays[arg1_29 + 1]

	var0_29:Update(var2_29, var2_29:IsPurchased(var1_29))
	var0_29:UpdateSelected(arg0_29.selected)

	if arg0_29:NoSelected() and arg1_29 == 0 then
		triggerButton(var0_29._go)
	end
end

function var0_0.NoSelected(arg0_30)
	return not arg0_30.selected or not _.any(arg0_30.disPlays, function(arg0_31)
		return arg0_31.id == arg0_30.selected.id
	end)
end

function var0_0.OnCardClick(arg0_32, arg1_32)
	arg0_32:UpdateMainPage(arg1_32.themeVO)
end

function var0_0.UpdateMainPage(arg0_33, arg1_33)
	if arg1_33 == arg0_33.card then
		return
	end

	local var0_33 = arg1_33:getConfig("name")
	local var1_33 = string.gsub(var0_33, "<size=%d+>", "")

	arg0_33.title.text = string.gsub(var1_33, "</size>", "")
	arg0_33.desc.text = arg1_33:getConfig("desc")

	local var2_33 = arg1_33:getConfig("discount")
	local var3_33 = arg1_33:HasDiscount()

	setActive(arg0_33.actualPrice, var3_33)
	arg0_33:UpdatePrice(arg1_33)
	arg0_33.largeSpLoader:LoadSpriteAsync("BackYardTheme/theme_" .. arg1_33.id, function(arg0_34)
		if IsNil(arg0_33.preview) then
			return
		end

		arg0_33.preview.sprite = arg0_34
		arg0_33.preview.enabled = true
	end)

	arg0_33.card = arg1_33
end

function var0_0.UpdatePrice(arg0_35, arg1_35)
	local var0_35, var1_35 = arg0_35:CalcThemePrice(arg1_35)

	arg0_35.actualPriceTxt.text = var1_35
	arg0_35.goldTxt.text = var0_35
end

function var0_0.GetAddList(arg0_36, arg1_36)
	local var0_36 = {}
	local var1_36 = arg1_36:GetFurnitures()
	local var2_36 = arg0_36.dorm:GetPurchasedFurnitures()

	for iter0_36, iter1_36 in ipairs(var1_36) do
		if not var2_36[iter1_36] then
			table.insert(var0_36, Furniture.New({
				id = iter1_36
			}))
		end
	end

	return var0_36
end

function var0_0.CalcThemePrice(arg0_37, arg1_37)
	local var0_37 = arg0_37:GetAddList(arg1_37)
	local var1_37 = 0
	local var2_37 = 0

	for iter0_37, iter1_37 in ipairs(var0_37) do
		var2_37 = var2_37 + iter1_37:getConfig("dorm_icon_price")
		var1_37 = var1_37 + iter1_37:getPrice(PlayerConst.ResDormMoney)
	end

	return var1_37, var2_37
end

local function var1_0(arg0_38, arg1_38)
	local var0_38

	for iter0_38, iter1_38 in pairs(arg0_38) do
		if iter1_38.themeVO.id == arg1_38.id then
			var0_38 = iter1_38

			break
		end
	end

	return var0_38
end

local function var2_0(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39:HeadIndexToValue(arg1_39)
	local var1_39 = arg0_39:HeadIndexToValue(arg2_39)

	return math.abs(var1_39 - var0_39)
end

function var0_0.GetSelectedIndex(arg0_40)
	local var0_40 = 0

	for iter0_40, iter1_40 in ipairs(arg0_40.disPlays) do
		if iter1_40.id == arg0_40.selected.id then
			var0_40 = iter0_40

			break
		end
	end

	return var0_40
end

function var0_0.OnSwitchToNextTheme(arg0_41)
	local var0_41 = arg0_41:GetSelectedIndex()

	if var0_41 >= #arg0_41.disPlays then
		return false
	end

	local var1_41 = arg0_41.disPlays[var0_41 + 1]
	local var2_41 = var1_0(arg0_41.cards, var1_41)

	local function var3_41(arg0_42)
		return go(arg0_41.scrollRect).transform.localPosition.x + arg0_41.scrollRectWidth / 2 < go(arg0_41.scrollRect).transform.parent:InverseTransformPoint(arg0_42._tf.position).x
	end

	if not var2_41 or var2_41 and var3_41(var2_41) then
		local var4_41 = var2_0(arg0_41.scrollRect, 1, 2)

		arg0_41.scrollRect:ScrollTo(arg0_41.scrollRect.value + var4_41, true)

		var2_41 = var1_0(arg0_41.cards, var1_41)
	end

	if var2_41 then
		triggerButton(var2_41._go)
	end

	return true
end

function var0_0.OnSwitchToPrevTheme(arg0_43)
	local var0_43 = arg0_43:GetSelectedIndex()

	if var0_43 <= 1 then
		return false
	end

	local var1_43 = arg0_43.disPlays[var0_43 - 1]
	local var2_43 = var1_0(arg0_43.cards, var1_43)

	local function var3_43(arg0_44)
		return go(arg0_43.scrollRect).transform.localPosition.x - arg0_43.scrollRectWidth / 2 > go(arg0_43.scrollRect).transform.parent:InverseTransformPoint(arg0_44._tf.position).x
	end

	if not var2_43 or var2_43 and var3_43(var2_43) then
		local var4_43 = var2_0(arg0_43.scrollRect, 1, 2)

		arg0_43.scrollRect:ScrollTo(arg0_43.scrollRect.value - var4_43, true)

		var2_43 = var1_0(arg0_43.cards, var1_43)
	end

	if var2_43 then
		triggerButton(var2_43._go)
	end

	return true
end

function var0_0.OnInfoPagePrevTheme(arg0_45)
	if arg0_45:OnSwitchToPrevTheme() then
		triggerButton(arg0_45.purchaseBtn)
	end
end

function var0_0.OnInfoPageNextTheme(arg0_46)
	if arg0_46:OnSwitchToNextTheme() then
		triggerButton(arg0_46.purchaseBtn)
	end
end

function var0_0.Hide(arg0_47)
	var0_0.super.Hide(arg0_47)
	arg0_47:UnBlurView()
end

function var0_0.BlurView(arg0_48)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_48.adpter, {
		pbList = {
			arg0_48:findTF("adpter/descript")
		},
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.UnBlurView(arg0_49)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_49.adpter, arg0_49._tf)
end

function var0_0.OnDestroy(arg0_50)
	if arg0_50.largeSpLoader then
		arg0_50.largeSpLoader:Dispose()

		arg0_50.largeSpLoader = nil
	end

	if arg0_50.infoPage then
		arg0_50.infoPage.OnExit = nil
		arg0_50.infoPage.OnEnter = nil
		arg0_50.infoPage.OnPrevTheme = nil
		arg0_50.infoPage.OnNextTheme = nil

		arg0_50.infoPage:Destroy()
	end

	for iter0_50, iter1_50 in pairs(arg0_50.cards or {}) do
		iter1_50:Dispose()
	end

	arg0_50.cards = nil

	arg0_50:Hide()
end

return var0_0
