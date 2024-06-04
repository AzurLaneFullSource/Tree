local var0 = class("MetaShopPage", import(".ActivityShopPage"))

function var0.getUIName(arg0)
	return "MetaShop"
end

function var0.ResId2ItemId(arg0, arg1)
	return arg1
end

function var0.SetResIcon(arg0)
	var0.super.SetResIcon(arg0, DROP_TYPE_ITEM)
end

function var0.UpdateTip(arg0)
	arg0.time.text = i18n("meta_shop_tip")
end

function var0.OnUpdatePlayer(arg0)
	return
end

function var0.OnUpdateItems(arg0)
	local var0 = arg0.shop:GetResList()

	for iter0, iter1 in pairs(arg0.resTrList) do
		local var1 = iter1[1]
		local var2 = iter1[2]
		local var3 = iter1[3]
		local var4 = var0[iter0]

		setActive(var1, var4 ~= nil)

		if var4 ~= nil then
			var3.text = (arg0.items[var4] or Item.New({
				count = 0,
				id = var4
			})).count
		end
	end
end

function var0.OnPurchase(arg0, arg1, arg2)
	local var0 = arg0.shop.activityId

	arg0:emit(NewShopsMediator.ON_META_SHOP, var0, 1, arg1.id, arg2)
end

function var0.GetPaintingName(arg0)
	local var0, var1, var2 = var0.super.GetPaintingName(arg0)
	local var3

	if type(var0) == "table" then
		var3 = var0[math.random(1, #var0)]
	else
		var3 = var0
	end

	return var3, var1, var2
end

return var0
