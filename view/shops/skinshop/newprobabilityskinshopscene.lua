local var0 = class("NewProbabilitySkinShopScene", import(".NewSkinShopScene"))

function var0.ResUISettings(arg0)
	return false
end

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.contextData.mode = NewSkinShopScene.MODE_OVERVIEW
	arg0.commodity = arg0:GetCommodity(arg0.contextData.commodityId)
	arg0.itemView = NewProbabilitySkinShopView.New(arg0._tf:Find("overlay"), arg0.event)
	arg0.chargeTipWindow = ChargeTipWindow.New(arg0._tf, arg0.event)
end

function var0.GetCommodity(arg0, arg1)
	local var0 = Goods.Create({
		shop_id = arg1
	}, Goods.TYPE_CHARGE)
	local var1 = getProxy(ShopsProxy):getChargedList() or {}
	local var2 = ChargeConst.getBuyCount(var1, var0.id)

	var0:updateBuyCount(var2)

	return var0
end

function var0.OnChargeSuccess(arg0, arg1)
	local var0 = arg0:GetCommodity(arg1)

	arg0.commodity = var0

	arg0.chargeTipWindow:ExecuteAction("Show", var0)

	if arg0.itemView and arg0.itemView:GetLoaded() then
		arg0.itemView:Flush(var0)
	end
end

function var0.didEnter(arg0)
	var0.super.didEnter(arg0)
	setActive(arg0.atlasBtn, false)
	setActive(arg0:findTF("overlay/left/mask"), false)

	local var0 = arg0:findTF("overlay/bottom")
	local var1 = var0.sizeDelta.x - 160
	local var2 = rtf(arg0.scrollrect.gameObject)

	var2.sizeDelta = Vector2(var1, var0.sizeDelta.y)

	setAnchoredPosition(var2, {
		x = 0
	})
	setAnchoredPosition(arg0.prevBtn, {
		x = 32
	})
	setActive(arg0:findTF("overlay/right/price"), false)
	setActive(arg0.live2dFilter, false)
	setActive(arg0.changeBtn, false)
end

function var0.UpdateCouponBtn(arg0)
	arg0.couponTr.localScale = Vector3(0, 0, 0)
end

function var0.UpdateVoucherBtn(arg0)
	arg0.voucherTr.localScale = Vector3(0, 0, 0)
end

function var0.UpdateTitle(arg0, arg1)
	arg0.title.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "probabilityshop")

	arg0.title:SetNativeSize()
	setAnchoredPosition(arg0.title.gameObject, {
		x = 363
	})
	setActive(arg0.titleEn.gameObject, false)
end

function var0.GetAllCommodity(arg0)
	local var0 = arg0.commodity:GetSkinProbability()

	return getProxy(ShipSkinProxy):GetProbabilitySkins(var0)
end

function var0.GetSkinProbability(arg0)
	local var0 = arg0.commodity:GetSkinProbability()

	return getProxy(ShipSkinProxy):GetSkinProbabilitys(var0)
end

function var0.GetSkinClassify(arg0, arg1, arg2)
	return {
		NewSkinShopScene.PAGE_ALL
	}
end

function var0.IsType(arg0, arg1, arg2)
	return true
end

function var0.UpdateCommodities(arg0, arg1, arg2, arg3)
	arg0.skinProbabilityList = arg0:GetSkinProbability()

	seriesAsync({
		function(arg0)
			var0.super.UpdateCommodities(arg0, arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:FlushItemView(arg0)
		end
	}, arg3)
end

function var0.FlushItemView(arg0, arg1)
	arg0.itemView:ExecuteAction("Show", arg0.commodity)
	arg1()
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	var0.super.OnUpdateItem(arg0, arg1, arg2)

	local var0 = arg0.cards[arg2]
	local var1 = var0.commodity.buyCount == 0

	setActive(var0.tagImg, not var1)
	setActive(var0.tagEnImg, false)
	setActive(var0.discountTag, false)
	setActive(var0.timelimitTag, false)

	if not var1 then
		var0.tagImg.sprite = GetSpriteFromAtlas("ui/SkinShopUI_atlas", "tag_yigoumai")
	end

	local var2 = arg0.skinProbabilityList[var0.commodity:getSkinId()] or 0

	var0.txt.text = " " .. string.format("%0.1f", var2 / 100) .. "%"
end

function var0.willExit(arg0)
	if arg0.itemView then
		arg0.itemView:Destroy()

		arg0.itemView = nil
	end

	if arg0.chargeTipWindow then
		arg0.chargeTipWindow:Destroy()

		arg0.chargeTipWindow = nil
	end

	Input.multiTouchEnabled = true
end

return var0
