local var0_0 = class("NewSkinShopPurchaseView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewSkinShopPurchaseUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.toggle = arg0_2:findTF("frame")
	arg0_2.title = arg0_2:findTF("frame/title")
	arg0_2.text = arg0_2:findTF("frame/bg/Text"):GetComponent(typeof(Text))
	arg0_2.textWithGift = arg0_2:findTF("frame/gift_bg/Text"):GetComponent(typeof(Text))
	arg0_2.dropsList = UIItemList.New(arg0_2:findTF("frame/gift_bg/gift/drops"), arg0_2:findTF("frame/gift_bg/gift/drops/item"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if arg0_3.commodity then
			arg0_3:emit(NewSkinShopMainView.EVT_ON_PURCHASE, arg0_3.commodity)
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.commodity = arg1_7

	arg0_7:Flush(arg1_7)
	arg0_7:emit(NewSkinShopMainView.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, true)
end

function var0_0.GetText(arg0_8, arg1_8)
	return arg1_8 and arg0_8.textWithGift or arg0_8.text
end

function var0_0.Flush(arg0_9, arg1_9)
	local var0_9 = arg1_9:GetGiftList()
	local var1_9 = #var0_9 > 0

	triggerToggle(arg0_9.toggle, var1_9)

	local var2_9 = arg0_9:GetText(var1_9)

	setAnchoredPosition(arg0_9.title, {
		y = var1_9 and 460 or 401
	})

	local var3_9 = (tf(pg.playerResUI._go).rect.width - arg0_9._tf.rect.width) * 0.5

	print(var3_9)
	setAnchoredPosition(pg.playerResUI.gemAddBtn, {
		x = -32 + math.abs(var3_9)
	})

	local var4_9 = arg1_9:GetPrice()
	local var5_9 = pg.ship_skin_template[arg1_9:getSkinId()].name
	local var6_9 = var4_9 <= getProxy(PlayerProxy):getRawData():getChargeGem() and COLOR_GREEN or COLOR_RED

	var2_9.text = i18n("skin_shop_buy_confirm", var6_9, var4_9, var5_9)

	arg0_9:FlushGift(var0_9)
end

function var0_0.FlushGift(arg0_10, arg1_10)
	arg0_10.dropsList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg1_10[arg1_11 + 1]
			local var1_11 = {
				type = var0_11.type,
				id = var0_11.id,
				count = var0_11.count
			}

			updateDrop(arg2_11, var1_11)
			onButton(arg0_10, arg2_11, function()
				arg0_10:emit(BaseUI.ON_DROP, var1_11)
			end, SFX_PANEL)
		end
	end)
	arg0_10.dropsList:align(#arg1_10)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	arg0_13:emit(NewSkinShopMainView.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, false)
	setAnchoredPosition(pg.playerResUI.gemAddBtn, {
		x = -155
	})

	arg0_13.commodity = nil
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
