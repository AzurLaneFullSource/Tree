local var0 = class("BackYardThemeInfoPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardThemeInfoPage"
end

function var0.OnLoaded(arg0)
	arg0.scrollRect = arg0:findTF("frame/list"):GetComponent("LScrollRect")
	arg0.nameTxt = arg0:findTF("frame/name"):GetComponent(typeof(Text))
	arg0.icon = arg0:findTF("frame/icon/Image"):GetComponent(typeof(Image))
	arg0.desc = arg0:findTF("frame/desc"):GetComponent(typeof(Text))
	arg0.backBtn = arg0:findTF("frame/back")
	arg0.leftArrBtn = arg0:findTF("arr_left")
	arg0.rightArrBtn = arg0:findTF("arr_right")
	arg0.gemTxt = arg0:findTF("res_gem/Text"):GetComponent(typeof(Text))
	arg0.goldTxt = arg0:findTF("res_gold/Text"):GetComponent(typeof(Text))
	arg0.gemAddBtn = arg0:findTF("res_gem/jiahao")
	arg0.goldAddBtn = arg0:findTF("res_gold/jiahao")
	arg0.purchaseBtn = arg0:findTF("frame/purchase_btn")
	arg0.purchaseAllBtn = arg0:findTF("frame/purchase_all_btn")

	setText(arg0.purchaseBtn:Find("Text"), i18n("fur_onekey_buy"))
	setText(arg0.purchaseAllBtn:Find("Text"), i18n("fur_all_buy"))
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollRect.onInitItem(arg0)
		arg0:OnInitCard(arg0)
	end

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateCard(arg0, arg1)
	end

	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.purchaseBtn, function()
		arg0.contextData.themeMsgBox:ExecuteAction("SetUp", arg0.themeVO, arg0.dorm, arg0.player)
	end, SFX_PANEL)
	onButton(arg0, arg0.purchaseAllBtn, function()
		arg0.contextData.themeAllMsgBox:ExecuteAction("SetUp", arg0.themeVO, arg0.dorm, arg0.player)
	end, SFX_PANEL)
	onButton(arg0, arg0.leftArrBtn, function()
		if arg0.OnPrevTheme then
			arg0.OnPrevTheme()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.rightArrBtn, function()
		if arg0.OnNextTheme then
			arg0.OnNextTheme()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.goldAddBtn, function()
		arg0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDormMoney)
	end, SFX_PANEL)
	onButton(arg0, arg0.gemAddBtn, function()
		arg0:emit(NewBackYardShopMediator.ON_CHARGE, PlayerConst.ResDiamond)
	end, SFX_PANEL)
end

function var0.OnPlayerUpdated(arg0, arg1)
	arg0.player = arg1

	arg0:UpdateRes()
end

function var0.DormUpdated(arg0, arg1)
	arg0.dorm = arg1
end

function var0.FurnituresUpdated(arg0, arg1)
	local var0 = arg0.dorm:GetPurchasedFurnitures()

	for iter0, iter1 in ipairs(arg1) do
		local var1 = var0[iter1]

		arg0:OnDisplayUpdated(var1)
		arg0:OnCardUpdated(var1)
	end

	arg0:UpdatePurchaseBtn()
end

function var0.OnDisplayUpdated(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1.id == arg1.id then
			arg0.displays[iter0] = arg1
		end
	end
end

function var0.OnCardUpdated(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.furniture.id == arg1.id then
			iter1:Update(arg1)
		end
	end
end

function var0.SetUp(arg0, arg1, arg2, arg3, arg4)
	arg0:Show()

	arg0.index = arg1
	arg0.dorm = arg3
	arg0.themeVO = arg2
	arg0.player = arg4

	arg0:InitFurnitureList()
	arg0:UpdateThemeInfo()
	arg0:UpdateRes()
end

function var0.UpdateRes(arg0)
	arg0.gemTxt.text = arg0.player:getTotalGem()
	arg0.goldTxt.text = arg0.player:getResource(PlayerConst.ResDormMoney)
end

function var0.InitFurnitureList(arg0)
	local var0 = arg0.themeVO:GetFurnitures()
	local var1 = arg0.dorm:GetPurchasedFurnitures()

	arg0.displays = {}

	for iter0, iter1 in ipairs(var0) do
		local var2 = var1[iter1] or Furniture.New({
			id = iter1
		})

		table.insert(arg0.displays, var2)
	end

	table.sort(arg0.displays, function(arg0, arg1)
		local var0 = arg0:canPurchase() and 1 or 0
		local var1 = arg1:canPurchase() and 1 or 0

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)
	arg0.scrollRect:SetTotalCount(#arg0.displays)
end

function var0.OnInitCard(arg0, arg1)
	local var0 = BackYardFurnitureCard.New(arg1)

	onButton(arg0, var0._go, function()
		if var0.furniture:canPurchase() then
			arg0.contextData.furnitureMsgBox:ExecuteAction("SetUp", var0.furniture, arg0.dorm, arg0.player)
		end
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateCard(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitCard(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1)
end

function var0.UpdateThemeInfo(arg0)
	local var0 = arg0.themeVO

	arg0.nameTxt.text = HXSet.hxLan(var0:getConfig("name"))

	GetSpriteFromAtlasAsync("BackYardTheme/theme_" .. var0.id, "", function(arg0)
		if IsNil(arg0.icon) then
			return
		end

		arg0.icon.sprite = arg0
	end)
	arg0.icon:SetNativeSize()

	arg0.desc.text = HXSet.hxLan(var0:getConfig("desc"))

	arg0:UpdatePurchaseBtn()
end

function var0.UpdatePurchaseBtn(arg0)
	local var0 = arg0.themeVO:GetFurnitures()
	local var1 = arg0.dorm:GetPurchasedFurnitures()
	local var2 = _.any(var0, function(arg0)
		return not var1[arg0]
	end)

	setActive(arg0.purchaseBtn, var2)

	local var3 = _.any(var0, function(arg0)
		return arg0.dorm:GetOwnFurnitureCount(arg0) < pg.furniture_data_template[arg0].count
	end)

	setActive(arg0.purchaseAllBtn, var3)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		weight = LayerWeightConst.BASE_LAYER
	})

	if arg0.OnEnter then
		arg0.OnEnter()
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0.OnExit then
		arg0.OnExit()
	end
end

function var0.OnDestroy(arg0)
	arg0:Hide()

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Clear()
	end
end

return var0
