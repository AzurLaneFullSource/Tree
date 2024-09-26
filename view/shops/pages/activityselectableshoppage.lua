local var0_0 = class("ActivitySelectableShopPage", import(".ActivityShopPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.purchaseWindow = ActivityShopPurchasePanel.New(arg0_1._tf, arg0_1.event)

	arg0_1:SetPurchaseConfirmCb()
end

function var0_0.UpdateShop(arg0_2, ...)
	var0_0.super.UpdateShop(arg0_2, ...)

	if arg0_2.purchaseWindow:isShowing() then
		arg0_2.purchaseWindow:ExecuteAction("Hide")
	end
end

function var0_0.SetPurchaseConfirmCb(arg0_3, arg1_3)
	assert("false", "请参考MetaShopPage实现该方法")
end

function var0_0.OnInitItem(arg0_4, arg1_4)
	local var0_4 = ActivityGoodsCard.New(arg1_4)

	var0_4.tagImg.raycastTarget = false

	onButton(arg0_4, var0_4.tr, function()
		if var0_4.goodsVO:Selectable() then
			arg0_4.purchaseWindow:ExecuteAction("Show", {
				icon = "props/21000",
				id = var0_4.goodsVO.id,
				count = var0_4.goodsVO:getConfig("num_limit"),
				type = var0_4.goodsVO:getConfig("commodity_type"),
				price = var0_4.goodsVO:getConfig("resource_num"),
				displays = var0_4.goodsVO:getConfig("commodity_id_list"),
				num = var0_4.goodsVO:getConfig("num")
			})
		else
			arg0_4:OnClickCommodity(var0_4.goodsVO, function(arg0_6, arg1_6)
				arg0_4:OnPurchase(arg0_6, arg1_6)
			end)
		end
	end, SFX_PANEL)

	arg0_4.cards[arg1_4] = var0_4
end

function var0_0.OnDestroy(arg0_7)
	var0_0.super.OnDestroy(arg0_7)
	arg0_7.purchaseWindow:Destroy()
end

return var0_0
