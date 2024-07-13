local var0_0 = class("EducateShopLayer", import("..base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateShopUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
end

function var0_0.initData(arg0_3)
	assert(arg0_3.contextData.shopId, "打开商店layer需要传入shopId")

	arg0_3.shopId = arg0_3.contextData.shopId
end

function var0_0.findUI(arg0_4)
	arg0_4.anim = arg0_4:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0_4.animEvent = arg0_4:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0_4.animEvent:SetEndEvent(function()
		arg0_4:emit(var0_0.ON_CLOSE)
	end)

	arg0_4.windowTF = arg0_4:findTF("anim_root/window")
	arg0_4.titleTF = arg0_4:findTF("title", arg0_4.windowTF)

	setText(arg0_4:findTF("Text", arg0_4.titleTF), i18n("word_shop"))

	arg0_4.closeBtn = arg0_4:findTF("close_btn", arg0_4.titleTF)
	arg0_4.discountTF = arg0_4:findTF("Text/discount", arg0_4.titleTF)
	arg0_4.discountValueTF = arg0_4:findTF("Text", arg0_4.discountTF)
	arg0_4.goodContent = arg0_4:findTF("view/content", arg0_4.windowTF)
	arg0_4.goodUIList = UIItemList.New(arg0_4.goodContent, arg0_4:findTF("tpl", arg0_4.goodContent))

	setText(arg0_4:findTF("tpl/sellout/Text", arg0_4.goodContent), i18n("word_sell_out"))

	arg0_4.tipTF = arg0_4:findTF("tip", arg0_4.windowTF)
	arg0_4.detailPanelTF = arg0_4:findTF("detail/content", arg0_4.windowTF)
	arg0_4.detailEmptyTF = arg0_4:findTF("detail/empty", arg0_4.windowTF)

	setText(arg0_4:findTF("Text", arg0_4.detailEmptyTF), i18n("child_shop_empty_tip"))

	arg0_4.detailName = arg0_4:findTF("title/Text", arg0_4.detailPanelTF)
	arg0_4.detailDesc = arg0_4:findTF("desc", arg0_4.detailPanelTF)
	arg0_4.detailIcon = arg0_4:findTF("icon", arg0_4.detailPanelTF)
	arg0_4.detailAttrsTF = arg0_4:findTF("attrs", arg0_4.detailPanelTF)

	setActive(arg0_4:findTF("count", arg0_4.detailPanelTF), false)

	arg0_4.countValueTF = arg0_4:findTF("count/bg/Text", arg0_4.detailPanelTF)
	arg0_4.addCountBtn = arg0_4:findTF("count/add", arg0_4.detailPanelTF)
	arg0_4.reduceCountBtn = arg0_4:findTF("count/reduce", arg0_4.detailPanelTF)
	arg0_4.maxCountBtn = arg0_4:findTF("count/max", arg0_4.detailPanelTF)
	arg0_4.priceValue = arg0_4:findTF("price/value/Text", arg0_4.detailPanelTF)

	setText(arg0_4:findTF("price/title", arg0_4.detailPanelTF), i18n("child_shop_price_title"))

	arg0_4.purchaseBtn = arg0_4:findTF("purchase_btn", arg0_4.detailPanelTF)

	setText(arg0_4:findTF("Text", arg0_4.purchaseBtn), i18n("word_buy"))
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6:findTF("anim_root/bg"), function()
		arg0_6:_close()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.closeBtn, function()
		arg0_6:_close()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.addCountBtn, function()
		if arg0_6.countValue >= arg0_6:GetMaxCount() then
			return
		end

		arg0_6.countValue = arg0_6.countValue + 1

		arg0_6:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.reduceCountBtn, function()
		if arg0_6.countValue <= 1 then
			return
		end

		arg0_6.countValue = arg0_6.countValue - 1

		arg0_6:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.maxCountBtn, function()
		local var0_11 = arg0_6:GetMaxCount()

		if arg0_6.countValue == var0_11 then
			return
		end

		arg0_6.countValue = var0_11

		arg0_6:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.purchaseBtn, function()
		if arg0_6:GetMaxCount() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		arg0_6:emit(EducateShopMediator.ON_SHOPPING, {
			shopId = arg0_6.shopId,
			goods = {
				{
					id = arg0_6.goods[arg0_6.selectedIndex].id,
					num = arg0_6.countValue
				}
			}
		})
	end, SFX_PANEL)
	arg0_6.goodUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			arg0_6:updateGoodItem(arg1_13, arg2_13)
		end
	end)
end

function var0_0.didEnter(arg0_14)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_14._tf, {
		groupName = arg0_14:getGroupNameFromData(),
		weight = arg0_14:getWeightFromData() + 2
	})

	arg0_14.selectedIndex = 1
	arg0_14.countValue = 1

	arg0_14:refreshShops()
end

function var0_0.updateGoodItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15 + 1
	local var1_15 = arg0_15.goods[var0_15]

	setActive(arg0_15:findTF("discount", arg2_15), arg0_15.isDiscount)
	setText(arg0_15:findTF("discount/Text", arg2_15), "-" .. arg0_15.discountValue)

	local var2_15 = var1_15:GetPrice()
	local var3_15 = arg0_15.isDiscount and var1_15:GetPrice(arg0_15.discountRatio) or var2_15

	setActive(arg0_15:findTF("bottom/price/price_original", arg2_15), arg0_15.isDiscount)
	setText(arg0_15:findTF("bottom/price/price_original", arg2_15), var2_15)
	setText(arg0_15:findTF("bottom/price/price_final", arg2_15), var3_15)

	local var4_15 = var1_15:GetShowInfo()

	EducateHelper.UpdateDropShow(arg0_15:findTF("item", arg2_15), var4_15)
	setActive(arg0_15:findTF("sellout", arg2_15), not var1_15:CanBuy())
	setActive(arg0_15:findTF("selected", arg2_15), var0_15 == arg0_15.selectedIndex)
	onButton(arg0_15, arg2_15, function()
		if var0_15 == arg0_15.selectedIndex then
			return
		end

		arg0_15.selectedIndex = var0_15

		for iter0_16 = 0, arg0_15.goodContent.childCount - 1 do
			local var0_16 = arg0_15.goodContent:GetChild(iter0_16)

			setActive(arg0_15:findTF("selected", var0_16), iter0_16 + 1 == arg0_15.selectedIndex)
		end

		arg0_15:updateDetail()
	end, SFX_PANEL)
end

function var0_0.refreshShops(arg0_17)
	local var0_17 = getProxy(EducateProxy):GetCurTime()

	arg0_17.shopProxy = getProxy(EducateProxy):GetShopProxy()
	arg0_17.shop = arg0_17.shopProxy:GetShopWithId(arg0_17.shopId)
	arg0_17.goods = arg0_17.shop:GetGoods(var0_17)
	arg0_17.char = getProxy(EducateProxy):GetCharData()
	arg0_17.isDiscount = arg0_17.shopProxy:IsDiscountById(arg0_17.shopId)
	arg0_17.discountRatio = arg0_17.shopProxy:GetDiscountById(arg0_17.shopId)
	arg0_17.discountValue = arg0_17.isDiscount and arg0_17.discountRatio / 100 .. "%" or ""

	setActive(arg0_17.discountTF, arg0_17.isDiscount)
	setText(arg0_17.discountValueTF, arg0_17.discountValue)
	setText(arg0_17.tipTF, arg0_17.shop:GetShopTip())
	arg0_17.goodUIList:align(#arg0_17.goods)

	local var1_17 = underscore.detect(arg0_17.goods, function(arg0_18)
		return arg0_18:GetRemainCnt() > 0
	end)

	setActive(arg0_17.detailEmptyTF, not var1_17)
	setActive(arg0_17.detailPanelTF, var1_17)

	if var1_17 then
		arg0_17:updateDetail()
	end
end

function var0_0.updateDetail(arg0_19)
	arg0_19.countValue = 1

	local var0_19 = arg0_19.goods[arg0_19.selectedIndex]:GetShowInfo()
	local var1_19 = pg.child_item[var0_19.id]

	setText(arg0_19.detailName, var1_19.name)
	setText(arg0_19.detailDesc, var1_19.desc)
	setText(arg0_19.countValueTF, arg0_19.countValue)
	LoadImageSpriteAsync("educateprops/" .. var1_19.icon, arg0_19.detailIcon)

	local var2_19 = EducateHelper.GetItemAddDrops(var0_19)

	arg0_19:updateDetailAttrs(var2_19)
	arg0_19:updateDetailPrice()
end

function var0_0.updateDetailAttrs(arg0_20, arg1_20)
	local var0_20

	var0_20 = #arg1_20 > 2 and 2 or #arg1_20

	for iter0_20 = 1, arg0_20.detailAttrsTF.childCount do
		local var1_20 = arg1_20[iter0_20]
		local var2_20 = arg0_20.detailAttrsTF:GetChild(iter0_20 - 1)

		if var1_20 then
			setActive(var2_20, true)
			EducateHelper.UpdateDropShowForAttr(var2_20, var1_20)
		else
			setActive(var2_20, false)
		end
	end
end

function var0_0.updateDetailPrice(arg0_21)
	setText(arg0_21.countValueTF, arg0_21.countValue)

	local var0_21 = arg0_21.goods[arg0_21.selectedIndex]:GetCost(arg0_21.discountRatio)

	setText(arg0_21.priceValue, var0_21.num * arg0_21.countValue)
	setGray(arg0_21.purchaseBtn, arg0_21:GetMaxCount() == 0, true)
end

function var0_0.GetMaxCount(arg0_22)
	local var0_22 = arg0_22.goods[arg0_22.selectedIndex]
	local var1_22 = var0_22:GetRemainCnt()
	local var2_22 = var0_22:GetCost(arg0_22.discountRatio)
	local var3_22 = math.floor(arg0_22.char:GetResById(var2_22.id) / var2_22.num)

	return math.min(var1_22, var3_22)
end

function var0_0._close(arg0_23)
	arg0_23.anim:Play("anim_educate_shop_out")
end

function var0_0.onBackPressed(arg0_24)
	arg0_24:_close()
end

function var0_0.willExit(arg0_25)
	arg0_25.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25._tf)
end

return var0_0
