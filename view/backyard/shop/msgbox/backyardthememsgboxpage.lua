local var0 = class("BackYardThemeMsgBoxPage", import(".BackYardFurnitureMsgBoxPage"))

function var0.getUIName(arg0)
	return "ThemeMsgboxPage"
end

function var0.OnLoaded(arg0)
	var0.super.OnLoaded(arg0)

	arg0.purchaseTr = arg0:findTF("frame/tip")
	arg0.purchase = arg0:findTF("frame/tip/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)
	onButton(arg0, arg0.gemPurchaseBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.goldPurchaseBtn, function()
		local var0 = arg0:GetAddList()

		if #var0 <= 0 then
			return
		end

		local var1 = _.map(var0, function(arg0)
			return arg0.id
		end)

		arg0:emit(NewBackYardShopMediator.ON_SHOPPING, var1, PlayerConst.ResDormMoney)
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0.dorm = arg2
	arg0.themeVO = arg1
	arg0.player = arg3
	arg0.count = 1
	arg0.maxCount = 1

	arg0:UpdateMainInfo()
	arg0:UpdateBtns()
	arg0:UpdatePrice()
	arg0:Show()

	arg0.purchase.text = i18n("purchase_backyard_theme_desc_for_onekey")

	setActive(arg0.purchaseTr, true)
	setText(arg0.gemPurchaseBtn:Find("content/Text"), i18n("word_buy"))
	setText(arg0.goldPurchaseBtn:Find("content/Text"), i18n("word_buy"))
end

function var0.UpdateMainInfo(arg0)
	arg0.nameTxt.text = arg0.themeVO:getConfig("name")
	arg0.themeTxt.text = ""
	arg0.descTxt.text = arg0.themeVO:getConfig("desc")
	arg0.maxCnt.text = ""
	arg0.icon.sprite = GetSpriteFromAtlas("BackYardTheme/" .. arg0.themeVO.id, "")
	tf(arg0.icon.gameObject).sizeDelta = Vector2(336, 336)
	arg0.maxBtnTxt.text = "+" .. arg0.maxCount
end

function var0.UpdateBtns(arg0)
	local var0 = true
	local var1 = false

	setActive(arg0.goldPurchaseBtn, var0)
	setActive(arg0.gemPurchaseBtn, var1)
	setActive(arg0.gemIcon, var1)
	setActive(arg0.gemCount, var1)
	setActive(arg0.goldIcon, var0)
	setActive(arg0.goldCount, var0)
	setActive(arg0.line, var0 and var1)
end

function var0.GetAddList(arg0)
	local var0 = {}
	local var1 = arg0.themeVO:GetFurnitures()
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

function var0.UpdatePrice(arg0)
	local var0 = arg0:GetAddList()
	local var1 = 0
	local var2 = _.reduce(var0, 0, function(arg0, arg1)
		return arg0 + arg1:getPrice(PlayerConst.ResDormMoney)
	end)

	arg0.gemCount.text = var1 * arg0.count
	arg0.goldCount.text = var2 * arg0.count

	arg0:UpdateEnergy(var0)
end

function var0.OnDestroy(arg0)
	return
end

return var0
