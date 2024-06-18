local var0_0 = class("BackYardThemeInfoPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardThemeInfoPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollRect = arg0_2:findTF("frame/list"):GetComponent("LScrollRect")
	arg0_2.nameTxt = arg0_2:findTF("frame/name"):GetComponent(typeof(Text))
	arg0_2.icon = arg0_2:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0_2.desc = arg0_2:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0_2.backBtn = arg0_2:findTF("frame/back")
	arg0_2.leftArrBtn = arg0_2:findTF("arr_left")
	arg0_2.rightArrBtn = arg0_2:findTF("arr_right")
	arg0_2.gemTxt = arg0_2:findTF("res_gem/Text"):GetComponent(typeof(Text))
	arg0_2.goldTxt = arg0_2:findTF("res_gold/Text"):GetComponent(typeof(Text))
	arg0_2.gemAddBtn = arg0_2:findTF("res_gem/jiahao")
	arg0_2.goldAddBtn = arg0_2:findTF("res_gold/jiahao")
	arg0_2.purchaseBtn = arg0_2:findTF("frame/purchase_btn")
	arg0_2.purchaseAllBtn = arg0_2:findTF("frame/purchase_all_btn")

	setText(arg0_2.purchaseBtn:Find("Text"), i18n("fur_onekey_buy"))
	setText(arg0_2.purchaseAllBtn:Find("Text"), i18n("fur_all_buy"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.cards = {}

	function arg0_3.scrollRect.onInitItem(arg0_4)
		arg0_3:OnInitCard(arg0_4)
	end

	function arg0_3.scrollRect.onUpdateItem(arg0_5, arg1_5)
		arg0_3:OnUpdateCard(arg0_5, arg1_5)
	end

	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.purchaseBtn, function()
		arg0_3.contextData.themeMsgBox:ExecuteAction("SetUp", arg0_3.themeVO, arg0_3.dorm, arg0_3.player)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.purchaseAllBtn, function()
		arg0_3.contextData.themeAllMsgBox:ExecuteAction("SetUp", arg0_3.themeVO, arg0_3.dorm, arg0_3.player)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.leftArrBtn, function()
		if arg0_3.OnPrevTheme then
			arg0_3.OnPrevTheme()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.rightArrBtn, function()
		if arg0_3.OnNextTheme then
			arg0_3.OnNextTheme()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goldAddBtn, function()
		arg0_3:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.gemAddBtn, function()
		arg0_3:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
end

function var0_0.OnPlayerUpdated(arg0_14, arg1_14)
	arg0_14.player = arg1_14

	arg0_14:UpdateRes()
end

function var0_0.DormUpdated(arg0_15, arg1_15)
	arg0_15.dorm = arg1_15
end

function var0_0.FurnituresUpdated(arg0_16, arg1_16)
	local var0_16 = arg0_16.dorm:GetPurchasedFurnitures()

	for iter0_16, iter1_16 in ipairs(arg1_16) do
		local var1_16 = var0_16[iter1_16]

		arg0_16:OnDisplayUpdated(var1_16)
		arg0_16:OnCardUpdated(var1_16)
	end

	arg0_16:UpdatePurchaseBtn()
end

function var0_0.OnDisplayUpdated(arg0_17, arg1_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.displays) do
		if iter1_17.id == arg1_17.id then
			arg0_17.displays[iter0_17] = arg1_17
		end
	end
end

function var0_0.OnCardUpdated(arg0_18, arg1_18)
	for iter0_18, iter1_18 in pairs(arg0_18.cards) do
		if iter1_18.furniture.id == arg1_18.id then
			iter1_18:Update(arg1_18)
		end
	end
end

function var0_0.SetUp(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg0_19:Show()

	arg0_19.index = arg1_19
	arg0_19.dorm = arg3_19
	arg0_19.themeVO = arg2_19
	arg0_19.player = arg4_19

	arg0_19:InitFurnitureList()
	arg0_19:UpdateThemeInfo()
	arg0_19:UpdateRes()
end

function var0_0.UpdateRes(arg0_20)
	arg0_20.gemTxt.text = arg0_20.player:getTotalGem()
	arg0_20.goldTxt.text = arg0_20.player:getResource(PlayerConst.ResDormMoney)
end

function var0_0.InitFurnitureList(arg0_21)
	local var0_21 = arg0_21.themeVO:GetFurnitures()
	local var1_21 = arg0_21.dorm:GetPurchasedFurnitures()

	arg0_21.displays = {}

	for iter0_21, iter1_21 in ipairs(var0_21) do
		local var2_21 = var1_21[iter1_21] or Furniture.New({
			id = iter1_21
		})

		table.insert(arg0_21.displays, var2_21)
	end

	table.sort(arg0_21.displays, function(arg0_22, arg1_22)
		local var0_22 = arg0_22:canPurchase() and 1 or 0
		local var1_22 = arg1_22:canPurchase() and 1 or 0

		if var0_22 == var1_22 then
			return arg0_22.id < arg1_22.id
		else
			return var1_22 < var0_22
		end
	end)
	arg0_21.scrollRect:SetTotalCount(#arg0_21.displays)
end

function var0_0.OnInitCard(arg0_23, arg1_23)
	local var0_23 = BackYardFurnitureCard.New(arg1_23)

	onButton(arg0_23, var0_23._go, function()
		if var0_23.furniture:canPurchase() then
			arg0_23.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0_23.furniture, arg0_23.dorm, arg0_23.player)
		end
	end, SFX_PANEL)

	arg0_23.cards[arg1_23] = var0_23
end

function var0_0.OnUpdateCard(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.cards[arg2_25]

	if not var0_25 then
		arg0_25:OnInitCard(arg2_25)

		var0_25 = arg0_25.cards[arg2_25]
	end

	local var1_25 = arg0_25.displays[arg1_25 + 1]

	var0_25:Update(var1_25)
end

function var0_0.UpdateThemeInfo(arg0_26)
	local var0_26 = arg0_26.themeVO

	arg0_26.nameTxt.text = HXSet.hxLan(var0_26:getConfig("name"))

	GetSpriteFromAtlasAsync("BackYardTheme/theme_" .. var0_26.id, "", function(arg0_27)
		if IsNil(arg0_26.icon) then
			return
		end

		arg0_26.icon.sprite = arg0_27
	end)
	arg0_26.icon:SetNativeSize()

	arg0_26.desc.text = HXSet.hxLan(var0_26:getConfig("desc"))

	arg0_26:UpdatePurchaseBtn()
end

function var0_0.UpdatePurchaseBtn(arg0_28)
	local var0_28 = arg0_28.themeVO:GetFurnitures()
	local var1_28 = arg0_28.dorm:GetPurchasedFurnitures()
	local var2_28 = _.any(var0_28, function(arg0_29)
		return not var1_28[arg0_29]
	end)

	setActive(arg0_28.purchaseBtn, var2_28)

	local var3_28 = _.any(var0_28, function(arg0_30)
		return arg0_28.dorm:GetOwnFurnitureCount(arg0_30) < pg.furniture_data_template[arg0_30].count
	end)

	setActive(arg0_28.purchaseAllBtn, var3_28)
end

function var0_0.Show(arg0_31)
	var0_0.super.Show(arg0_31)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_31._tf, {
		weight = LayerWeightConst.BASE_LAYER
	})

	if arg0_31.OnEnter then
		arg0_31.OnEnter()
	end
end

function var0_0.Hide(arg0_32)
	var0_0.super.Hide(arg0_32)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_32._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0_32.OnExit then
		arg0_32.OnExit()
	end
end

function var0_0.OnDestroy(arg0_33)
	arg0_33:Hide()

	for iter0_33, iter1_33 in pairs(arg0_33.cards) do
		iter1_33:Clear()
	end
end

return var0_0
