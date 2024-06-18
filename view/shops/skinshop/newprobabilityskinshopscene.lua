local var0_0 = class("NewProbabilitySkinShopScene", import(".NewSkinShopScene"))

function var0_0.ResUISettings(arg0_1)
	return false
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.contextData.mode = NewSkinShopScene.MODE_OVERVIEW
	arg0_2.commodity = arg0_2:GetCommodity(arg0_2.contextData.commodityId)
	arg0_2.itemView = NewProbabilitySkinShopView.New(arg0_2._tf:Find("overlay"), arg0_2.event)
	arg0_2.chargeTipWindow = ChargeTipWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.GetCommodity(arg0_3, arg1_3)
	local var0_3 = Goods.Create({
		shop_id = arg1_3
	}, Goods.TYPE_CHARGE)
	local var1_3 = getProxy(ShopsProxy):getChargedList() or {}
	local var2_3 = ChargeConst.getBuyCount(var1_3, var0_3.id)

	var0_3:updateBuyCount(var2_3)

	return var0_3
end

function var0_0.OnChargeSuccess(arg0_4, arg1_4)
	local var0_4 = arg0_4:GetCommodity(arg1_4)

	arg0_4.commodity = var0_4

	arg0_4.chargeTipWindow:ExecuteAction("Show", var0_4)

	if arg0_4.itemView and arg0_4.itemView:GetLoaded() then
		arg0_4.itemView:Flush(var0_4)
	end
end

function var0_0.didEnter(arg0_5)
	var0_0.super.didEnter(arg0_5)
	setActive(arg0_5.atlasBtn, false)
	setActive(arg0_5:findTF("overlay/left/mask"), false)

	local var0_5 = arg0_5:findTF("overlay/bottom")
	local var1_5 = var0_5.sizeDelta.x - 160
	local var2_5 = rtf(arg0_5.scrollrect.gameObject)

	var2_5.sizeDelta = Vector2(var1_5, var0_5.sizeDelta.y)

	setAnchoredPosition(var2_5, {
		x = 0
	})
	setAnchoredPosition(arg0_5.prevBtn, {
		x = 32
	})
	setActive(arg0_5:findTF("overlay/right/price"), false)
	setActive(arg0_5.live2dFilter, false)
	setActive(arg0_5.changeBtn, false)
end

function var0_0.UpdateCouponBtn(arg0_6)
	arg0_6.couponTr.localScale = Vector3(0, 0, 0)
end

function var0_0.UpdateVoucherBtn(arg0_7)
	arg0_7.voucherTr.localScale = Vector3(0, 0, 0)
end

function var0_0.UpdateTitle(arg0_8, arg1_8)
	arg0_8.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "probabilityshop")

	arg0_8.title:SetNativeSize()
	setAnchoredPosition(arg0_8.title.gameObject, {
		x = 363
	})
	setActive(arg0_8.titleEn.gameObject, false)
end

function var0_0.GetAllCommodity(arg0_9)
	local var0_9 = arg0_9.commodity:GetSkinProbability()

	return getProxy(ShipSkinProxy):GetProbabilitySkins(var0_9)
end

function var0_0.GetSkinProbability(arg0_10)
	local var0_10 = arg0_10.commodity:GetSkinProbability()

	return getProxy(ShipSkinProxy):GetSkinProbabilitys(var0_10)
end

function var0_0.GetSkinClassify(arg0_11, arg1_11, arg2_11)
	return {
		NewSkinShopScene.PAGE_ALL
	}
end

function var0_0.IsType(arg0_12, arg1_12, arg2_12)
	return true
end

function var0_0.UpdateCommodities(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.skinProbabilityList = arg0_13:GetSkinProbability()

	seriesAsync({
		function(arg0_14)
			var0_0.super.UpdateCommodities(arg0_13, arg1_13, arg2_13, arg0_14)
		end,
		function(arg0_15)
			arg0_13:FlushItemView(arg0_15)
		end
	}, arg3_13)
end

function var0_0.FlushItemView(arg0_16, arg1_16)
	arg0_16.itemView:ExecuteAction("Show", arg0_16.commodity)
	arg1_16()
end

function var0_0.OnUpdateItem(arg0_17, arg1_17, arg2_17)
	var0_0.super.OnUpdateItem(arg0_17, arg1_17, arg2_17)

	local var0_17 = arg0_17.cards[arg2_17]
	local var1_17 = var0_17.commodity.buyCount == 0

	setActive(var0_17.tagImg, not var1_17)
	setActive(var0_17.tagEnImg, false)
	setActive(var0_17.discountTag, false)
	setActive(var0_17.timelimitTag, false)

	if not var1_17 then
		var0_17.tagImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "tag_yigoumai")
	end

	local var2_17 = arg0_17.skinProbabilityList[var0_17.commodity:getSkinId()] or 0

	var0_17.txt.text = " " .. string.format("%0.1f", var2_17 / 100) .. "%"
end

function var0_0.willExit(arg0_18)
	if arg0_18.itemView then
		arg0_18.itemView:Destroy()

		arg0_18.itemView = nil
	end

	if arg0_18.chargeTipWindow then
		arg0_18.chargeTipWindow:Destroy()

		arg0_18.chargeTipWindow = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
