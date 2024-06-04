local var0 = class("NewServerShopPurchasePanel", import(".GuildShopPurchasePanel"))

function var0.Show(arg0, arg1)
	local var0 = arg1:GetConsume()
	local var1 = {
		id = arg1.id,
		count = arg1:GetCanPurchaseCnt(),
		type = arg1:GetDropType(),
		price = var0.count,
		displays = arg1:GetSelectableGoods()
	}

	arg0.commodity = arg1

	var0.super.Show(arg0, var1)

	arg0.limitOnePurchase = arg1:LimitPurchaseSubGoods()
	arg0.descTxt.text = arg0.limitOnePurchase and i18n("new_server_shop_sel_goods_tip") or ""

	GetImageSpriteFromAtlasAsync(var0:getConfig("icon"), "", arg0.resIcon)
end

function var0.UpdateItem(arg0, arg1, arg2, arg3)
	var0.super.UpdateItem(arg0, arg1, arg2, arg3)

	local var0 = arg3:Find("mask")

	setActive(var0, not arg0.commodity:CanPurchaseSubGoods(arg2))
end

function var0.ClickItem(arg0, arg1, arg2)
	if arg0.limitOnePurchase and not arg0.commodity:CanPurchaseSubGoods(arg2) then
		return
	end

	var0.super.ClickItem(arg0, arg1, arg2)
end

function var0.PressAddBtn(arg0, arg1, arg2)
	if arg0.limitOnePurchase and table.contains(arg0.selectedList, arg2) then
		return
	end

	var0.super.PressAddBtn(arg0, arg1, arg2)
end

function var0.OnConfirm(arg0)
	pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
		id = arg0.commodity.id,
		selectedList = arg0.selectedList
	})
end

return var0
