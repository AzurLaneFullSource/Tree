local var0_0 = class("MetaShopPage", import(".ActivitySelectableShopPage"))

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

function var0_0.SetPurchaseConfirmCb(arg0_5, arg1_5)
	arg0_5.purchaseWindow:ExecuteAction("SetConfirmCb", function(arg0_6, arg1_6, arg2_6)
		arg0_5:emit(NewShopsMediator.ON_META_SHOP, arg0_5.shop.activityId, 1, arg0_6, arg2_6, arg1_6)
	end)
	arg0_5.purchaseWindow:ExecuteAction("Hide")
end

function var0_0.OnUpdatePlayer(arg0_7)
	return
end

function var0_0.OnUpdateItems(arg0_8)
	local var0_8 = arg0_8.shop:GetResList()

	for iter0_8, iter1_8 in pairs(arg0_8.resTrList) do
		local var1_8 = iter1_8[1]
		local var2_8 = iter1_8[2]
		local var3_8 = iter1_8[3]
		local var4_8 = var0_8[iter0_8]

		setActive(var1_8, var4_8 ~= nil)

		if var4_8 ~= nil then
			var3_8.text = (arg0_8.items[var4_8] or Item.New({
				count = 0,
				id = var4_8
			})).count
		end
	end
end

function var0_0.OnPurchase(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.shop.activityId

	arg0_9:emit(NewShopsMediator.ON_META_SHOP, var0_9, 1, arg1_9.id, arg2_9, {
		{
			key = arg1_9:getConfig("commodity_id"),
			value = arg2_9
		}
	})
end

function var0_0.GetPaintingName(arg0_10)
	local var0_10, var1_10, var2_10 = var0_0.super.GetPaintingName(arg0_10)
	local var3_10

	if type(var0_10) == "table" then
		var3_10 = var0_10[math.random(1, #var0_10)]
	else
		var3_10 = var0_10
	end

	return var3_10, var1_10, var2_10
end

return var0_0
