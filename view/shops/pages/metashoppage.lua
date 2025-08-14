local var0_0 = class("MetaShopPage", import(".ActivitySelectableShopPage"))

function var0_0.ResId2ItemId(arg0_1, arg1_1)
	return arg1_1
end

function var0_0.SetResIcon(arg0_2)
	var0_0.super.SetResIcon(arg0_2, DROP_TYPE_ITEM)
end

function var0_0.UpdateTip(arg0_3)
	arg0_3.tipText.text = i18n("meta_shop_tip")
end

function var0_0.SetPurchaseConfirmCb(arg0_4, arg1_4)
	arg0_4.purchaseWindow:ExecuteAction("SetConfirmCb", function(arg0_5, arg1_5, arg2_5)
		arg0_4:emit(NewShopMainMediator.ON_META_SHOP, arg0_4.shop.activityId, 1, arg0_5, arg2_5, arg1_5)
	end)
	arg0_4.purchaseWindow:ExecuteAction("Hide")
end

function var0_0.OnUpdatePlayer(arg0_6)
	return
end

function var0_0.OnUpdateItems(arg0_7)
	arg0_7:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_8)
	local var0_8 = {}
	local var1_8 = arg0_8.shop:GetResList()

	for iter0_8, iter1_8 in ipairs(var1_8) do
		local var2_8 = (arg0_8.items[iter1_8] or Item.New({
			count = 0,
			id = iter1_8
		})).count

		table.insert(var0_8, {
			type = DROP_TYPE_ITEM,
			resID = iter1_8,
			cnt = var2_8
		})
	end

	return var0_8
end

function var0_0.RefreshUI(arg0_9)
	arg0_9:UpdateTip()
	setActive(arg0_9.tipTextGo, true)
	setActive(arg0_9.helpBtn, false)
	setActive(arg0_9.resolveBtn, false)
	setActive(arg0_9.refreshBtn, false)
end

function var0_0.OnPurchase(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.shop.activityId

	arg0_10:emit(NewShopMainMediator.ON_META_SHOP, var0_10, 1, arg1_10.id, arg2_10, {
		{
			key = arg1_10:getConfig("commodity_id"),
			value = arg2_10
		}
	})
end

function var0_0.GetPaintingName(arg0_11)
	local var0_11, var1_11, var2_11 = var0_0.super.GetPaintingName(arg0_11)
	local var3_11

	if type(var0_11) == "table" then
		var3_11 = var0_11[math.random(1, #var0_11)]
	else
		var3_11 = var0_11
	end

	return var3_11, var1_11, var2_11
end

return var0_0
