local var0_0 = class("BackYardThemeMsgBoxPage", import(".BackYardFurnitureMsgBoxPage"))

function var0_0.getUIName(arg0_1)
	return "ThemeMsgboxPage"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.purchaseTr = arg0_2:findTF("frame/tip")
	arg0_2.purchase = arg0_2:findTF("frame/tip/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.gemPurchaseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.goldPurchaseBtn, function()
		local var0_5 = arg0_3:GetAddList()

		if #var0_5 <= 0 then
			return
		end

		local var1_5 = _.map(var0_5, function(arg0_6)
			return arg0_6.id
		end)

		arg0_3:emit(NewBackYardShopMediator.ON_SHOPPING, var1_5, PlayerConst.ResDormMoney)
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.dorm = arg2_7
	arg0_7.themeVO = arg1_7
	arg0_7.player = arg3_7
	arg0_7.count = 1
	arg0_7.maxCount = 1

	arg0_7:UpdateMainInfo()
	arg0_7:UpdateBtns()
	arg0_7:UpdatePrice()
	arg0_7:Show()

	arg0_7.purchase.text = i18n("purchase_backyard_theme_desc_for_onekey")

	setActive(arg0_7.purchaseTr, true)
	setText(arg0_7.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0_7.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
end

function var0_0.UpdateMainInfo(arg0_8)
	arg0_8.nameTxt.text = arg0_8.themeVO:getConfig("name")
	arg0_8.themeTxt.text = ""
	arg0_8.descTxt.text = arg0_8.themeVO:getConfig("desc")
	arg0_8.maxCnt.text = ""
	arg0_8.icon.sprite = GetSpriteFromAtlas("BackYardTheme/" .. arg0_8.themeVO.id, "")
	tf(arg0_8.icon.gameObject).sizeDelta = Vector2(336, 336)
	arg0_8.maxBtnTxt.text = "+" .. arg0_8.maxCount
end

function var0_0.UpdateBtns(arg0_9)
	local var0_9 = true
	local var1_9 = false

	setActive(arg0_9.goldPurchaseBtn, var0_9)
	setActive(arg0_9.gemPurchaseBtn, var1_9)
	setActive(arg0_9.gemIcon, var1_9)
	setActive(arg0_9.gemCount, var1_9)
	setActive(arg0_9.goldIcon, var0_9)
	setActive(arg0_9.goldCount, var0_9)
	setActive(arg0_9.line, var0_9 and var1_9)
end

function var0_0.GetAddList(arg0_10)
	local var0_10 = {}
	local var1_10 = arg0_10.themeVO:GetFurnitures()
	local var2_10 = arg0_10.dorm:GetPurchasedFurnitures()

	for iter0_10, iter1_10 in ipairs(var1_10) do
		if not var2_10[iter1_10] then
			table.insert(var0_10, Furniture.New({
				id = iter1_10
			}))
		end
	end

	return var0_10
end

function var0_0.UpdatePrice(arg0_11)
	local var0_11 = arg0_11:GetAddList()
	local var1_11 = 0
	local var2_11 = _.reduce(var0_11, 0, function(arg0_12, arg1_12)
		return arg0_12 + arg1_12:getPrice(PlayerConst.ResDormMoney)
	end)

	arg0_11.gemCount.text = var1_11 * arg0_11.count
	arg0_11.goldCount.text = var2_11 * arg0_11.count

	arg0_11:UpdateEnergy(var0_11)
end

function var0_0.OnDestroy(arg0_13)
	return
end

return var0_0
