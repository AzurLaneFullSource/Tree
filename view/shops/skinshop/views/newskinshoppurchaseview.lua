local var0 = class("NewSkinShopPurchaseView", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewSkinShopPurchaseUI"
end

function var0.OnLoaded(arg0)
	arg0.cancelBtn = arg0:findTF("frame/cancel")
	arg0.confirmBtn = arg0:findTF("frame/confirm")
	arg0.toggle = arg0:findTF("frame")
	arg0.title = arg0:findTF("frame/title")
	arg0.text = arg0:findTF("frame/bg/Text"):GetComponent(typeof(Text))
	arg0.textWithGift = arg0:findTF("frame/gift_bg/Text"):GetComponent(typeof(Text))
	arg0.dropsList = UIItemList.New(arg0:findTF("frame/gift_bg/gift/drops"), arg0:findTF("frame/gift_bg/gift/drops/item"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.commodity then
			arg0:emit(NewSkinShopMainView.EVT_ON_PURCHASE, arg0.commodity)
		end
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.commodity = arg1

	arg0:Flush(arg1)
	arg0:emit(NewSkinShopMainView.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, true)
end

function var0.GetText(arg0, arg1)
	return arg1 and arg0.textWithGift or arg0.text
end

function var0.Flush(arg0, arg1)
	local var0 = arg1:GetGiftList()
	local var1 = #var0 > 0

	triggerToggle(arg0.toggle, var1)

	local var2 = arg0:GetText(var1)

	setAnchoredPosition(arg0.title, {
		y = var1 and 460 or 401
	})

	local var3 = (tf(pg.playerResUI._go).rect.width - arg0._tf.rect.width) * 0.5

	print(var3)
	setAnchoredPosition(pg.playerResUI.gemAddBtn, {
		x = -32 + math.abs(var3)
	})

	local var4 = arg1:GetPrice()
	local var5 = pg.ship_skin_template[arg1:getSkinId()].name
	local var6 = var4 <= getProxy(PlayerProxy):getRawData():getChargeGem() and COLOR_GREEN or COLOR_RED

	var2.text = i18n("skin_shop_buy_confirm", var6, var4, var5)

	arg0:FlushGift(var0)
end

function var0.FlushGift(arg0, arg1)
	arg0.dropsList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = {
				type = var0.type,
				id = var0.id,
				count = var0.count
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.dropsList:align(#arg1)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:emit(NewSkinShopMainView.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, false)
	setAnchoredPosition(pg.playerResUI.gemAddBtn, {
		x = -155
	})

	arg0.commodity = nil
end

function var0.OnDestroy(arg0)
	return
end

return var0
