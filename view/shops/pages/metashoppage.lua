local var0_0 = class("MetaShopPage", import(".ActivityShopPage"))

function var0_0.getUIName(arg0_1)
	return "MetaShop"
end

function var0_0.ResId2ItemId(arg0_2, arg1_2)
	return arg1_2
end

function var0_0.SetResIcon(arg0_3)
	var0_0.super.SetResIcon(arg0_3, DROP_TYPE_ITEM)
end

function var0_0.UpdateTip(arg0_4)
	arg0_4.time.text = i18n("meta_shop_tip")
end

function var0_0.OnUpdatePlayer(arg0_5)
	return
end

function var0_0.OnUpdateItems(arg0_6)
	local var0_6 = arg0_6.shop:GetResList()

	for iter0_6, iter1_6 in pairs(arg0_6.resTrList) do
		local var1_6 = iter1_6[1]
		local var2_6 = iter1_6[2]
		local var3_6 = iter1_6[3]
		local var4_6 = var0_6[iter0_6]

		setActive(var1_6, var4_6 ~= nil)

		if var4_6 ~= nil then
			var3_6.text = (arg0_6.items[var4_6] or Item.New({
				count = 0,
				id = var4_6
			})).count
		end
	end
end

function var0_0.OnPurchase(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.shop.activityId

	arg0_7:emit(NewShopsMediator.ON_META_SHOP, var0_7, 1, arg1_7.id, arg2_7)
end

function var0_0.GetPaintingName(arg0_8)
	local var0_8, var1_8, var2_8 = var0_0.super.GetPaintingName(arg0_8)
	local var3_8

	if type(var0_8) == "table" then
		var3_8 = var0_8[math.random(1, #var0_8)]
	else
		var3_8 = var0_8
	end

	return var3_8, var1_8, var2_8
end

return var0_0
