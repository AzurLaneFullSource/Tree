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
	arg0_2.tipText = arg0_2:findTF("frame/bg/tipText")
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

	arg0_9:SetTipText(arg1_9:getSkinId())
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

function var0_0.SetTipText(arg0_13, arg1_13)
	local var0_13 = pg.ship_skin_template[arg1_13].ship_group
	local var1_13 = pg.gameset.no_share_skin_tip.description
	local var2_13
	local var3_13

	for iter0_13, iter1_13 in ipairs(var1_13) do
		for iter2_13, iter3_13 in ipairs(iter1_13) do
			if var0_13 == iter3_13[1] then
				var2_13 = iter1_13
				var3_13 = iter2_13

				break
			end
		end
	end

	setActive(arg0_13.tipText, var3_13)

	if var3_13 then
		local var4_13 = ""

		for iter4_13, iter5_13 in ipairs(var2_13) do
			if iter4_13 ~= var3_13 then
				if var4_13 == "" then
					var4_13 = i18n(iter5_13[2])
				else
					var4_13 = var4_13 .. "、" .. i18n(iter5_13[2])
				end
			end
		end

		setText(arg0_13.tipText, i18n("no_share_skin_gametip", i18n(var2_13[var3_13][2]), var4_13))
	end
end

function var0_0.Hide(arg0_14)
	var0_0.super.Hide(arg0_14)
	arg0_14:emit(NewSkinShopMainView.EVT_SHOW_OR_HIDE_PURCHASE_VIEW, false)
	setAnchoredPosition(pg.playerResUI.gemAddBtn, {
		x = -155
	})

	arg0_14.commodity = nil
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
