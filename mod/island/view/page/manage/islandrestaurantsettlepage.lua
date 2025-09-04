local var0_0 = class("IslandRestaurantSettlePage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandRestaurantSettleUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTF = arg0_2._tf:Find("title/name/Text")

	local var0_2 = arg0_2._tf:Find("window/sale")

	setText(var0_2:Find("title"), i18n("island_manage_sale_daily"))

	arg0_2.switchToggle = var0_2:Find("switch")

	setText(arg0_2.switchToggle:Find("on/Text"), i18n("island_manage_fake_price"))
	setText(arg0_2.switchToggle:Find("off/Text"), i18n("island_manage_real_price"))

	arg0_2.saleUIList = UIItemList.New(var0_2:Find("content"), var0_2:Find("content/tpl"))

	local var1_2 = arg0_2._tf:Find("window/remain")

	setText(var1_2:Find("title"), i18n("island_manage_result_1"))

	arg0_2.remainUIList = UIItemList.New(var1_2:Find("content"), var1_2:Find("content/tpl"))

	local var2_2 = arg0_2._tf:Find("window/summary")

	setText(var2_2:Find("title/Text"), i18n("island_manage_result_3"))

	arg0_2.countTF = var2_2:Find("count/info/value")

	setText(var2_2:Find("count/info/name"), i18n("island_manage_word_cnt"))

	arg0_2.priceTF = var2_2:Find("price/info/value")

	setText(var2_2:Find("price/info/name"), i18n("island_manage_saleroom"))

	arg0_2.expSliderTF = var2_2:Find("exp/info/slider")
	arg0_2.expProgressTF = var2_2:Find("exp/info/slider/progress")

	setText(var2_2:Find("exp/info/name"), i18n("island_manage_shop_exp"))
	setText(arg0_2._tf:Find("tip"), i18n("child_close_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("mask"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.switchToggle, function(arg0_5)
		arg0_3.saleUIList:eachActive(function(arg0_6, arg1_6)
			setActive(arg1_6:Find("price"), arg0_5)
		end)
	end, SFX_PANEL)
	arg0_3.saleUIList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_3.saleList[arg1_7 + 1]

			arg0_3:UpdateCommonItem(arg2_7, var0_7)
			setText(arg2_7:Find("price/Text"), var0_7.price)
		end
	end)
	arg0_3.remainUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_3.remainList[arg1_8 + 1]

			arg0_3:UpdateCommonItem(arg2_8, var0_8)
		end
	end)

	arg0_3.maxAttrEffect = pg.island_chara_att[1].manage_effect / 10000
end

function var0_0.OnShow(arg0_9, arg1_9, arg2_9)
	arg0_9:BlurPanel()

	arg0_9.callback = arg2_9
	arg0_9.restId = arg1_9.restId
	arg0_9.shipCnt = arg1_9.oldShipCnt
	arg0_9.ships = {}

	local var0_9 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	for iter0_9, iter1_9 in ipairs(arg1_9.shipIds) do
		table.insert(arg0_9.ships, var0_9:GetShipById(iter1_9))
	end

	setText(arg0_9.titleTF, pg.island_manage_restaurant[arg0_9.restId].name)

	arg0_9.saleList = arg1_9.saleList

	arg0_9.saleUIList:align(#arg0_9.saleList)

	arg0_9.remainList = arg1_9.remainList

	arg0_9.remainUIList:align(#arg0_9.remainList)

	arg0_9.totalCnt, arg0_9.totalPrice = 0, 0

	for iter2_9, iter3_9 in ipairs(arg0_9.saleList) do
		arg0_9.totalCnt = arg0_9.totalCnt + iter3_9.num
		arg0_9.totalPrice = arg0_9.totalPrice + iter3_9.price
	end

	setText(arg0_9.countTF, arg0_9.totalCnt)
	setText(arg0_9.priceTF, arg0_9.totalPrice)

	local var1_9 = getProxy(IslandProxy):GetIsland():GetManageAgency():GetRestaurant(arg0_9.restId)
	local var2_9 = var1_9:GetSales()
	local var3_9 = var1_9:GetCanUpgradeExp()

	setSlider(arg0_9.expSliderTF, 0, 1, var2_9 / var3_9)
	setText(arg0_9.expProgressTF, var2_9 .. "/" .. var3_9)
	triggerToggle(arg0_9.switchToggle, false)
end

function var0_0.UpdateCommonItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = pg.island_item_data_template[arg2_10.id].icon

	LoadImageSpriteAsync("island/" .. var0_10, arg1_10:Find("bg/icon"))
	setText(arg1_10:Find("count/Text"), arg2_10.num)

	local var1_10 = arg0_10:GetAttrsFactorsRatio(arg2_10.id)

	setFillAmount(arg1_10:Find("bg/silder/bar"), var1_10)
end

function var0_0.OnHide(arg0_11)
	arg0_11:UnBlurPanel()
	existCall(arg0_11.callback)

	arg0_11.callback = nil
end

function var0_0.GetAttrsFactorsRatio(arg0_12, arg1_12)
	local var0_12 = pg.island_item_data_template[arg1_12].sub_attribute
	local var1_12 = var0_12[2] / 100

	return (IslandRestaurantPage.CaclShipAttrFactors(arg0_12.ships, IslandShipAttr.MANAGE_KEY) + IslandRestaurantPage.CaclShipAttrFactors(arg0_12.ships, var0_12[1]) * var1_12) / (arg0_12.shipCnt * (arg0_12.maxAttrEffect + arg0_12.maxAttrEffect * var1_12))
end

return var0_0
