local var0_0 = class("NewServerShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0_0.Show(arg0_1, arg1_1)
	local var0_1 = arg1_1:GetConsume()
	local var1_1 = {
		id = arg1_1.id,
		count = arg1_1:GetCanPurchaseCnt(),
		type = arg1_1:GetDropType(),
		price = var0_1.count,
		displays = arg1_1:GetSelectableGoods()
	}

	arg0_1.commodity = arg1_1

	var0_0.super.Show(arg0_1, var1_1)

	arg0_1.limitOnePurchase = arg1_1:LimitPurchaseSubGoods()
	arg0_1.descTxt.text = arg0_1.limitOnePurchase and i18n("new_server_shop_sel_goods_tip") or ""

	GetImageSpriteFromAtlasAsync(var0_1:getConfig("icon"), "", arg0_1.resIcon)
end

function var0_0.UpdateItem(arg0_2, arg1_2, arg2_2, arg3_2)
	var0_0.super.UpdateItem(arg0_2, arg1_2, arg2_2, arg3_2)

	local var0_2 = arg3_2:Find("mask")

	setActive(var0_2, not arg0_2.commodity:CanPurchaseSubGoods(arg2_2))
end

function var0_0.ClickItem(arg0_3, arg1_3, arg2_3)
	if arg0_3.limitOnePurchase and not arg0_3.commodity:CanPurchaseSubGoods(arg2_3) then
		return
	end

	var0_0.super.ClickItem(arg0_3, arg1_3, arg2_3)
end

function var0_0.PressAddBtn(arg0_4, arg1_4, arg2_4)
	if arg0_4.limitOnePurchase and table.contains(arg0_4.selectedList, arg2_4) then
		return
	end

	var0_0.super.PressAddBtn(arg0_4, arg1_4, arg2_4)
end

function var0_0.OnConfirm(arg0_5)
	pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
		id = arg0_5.commodity.id,
		selectedList = arg0_5.selectedList
	})
end

return var0_0
