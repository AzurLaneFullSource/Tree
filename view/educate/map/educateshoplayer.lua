local var0 = class("EducateShopLayer", import("..base.EducateBaseUI"))

function var0.getUIName(arg0)
	return "EducateShopUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
end

function var0.initData(arg0)
	assert(arg0.contextData.shopId, "打开商店layer需要传入shopId")

	arg0.shopId = arg0.contextData.shopId
end

function var0.findUI(arg0)
	arg0.anim = arg0:findTF("anim_root"):GetComponent(typeof(Animation))
	arg0.animEvent = arg0:findTF("anim_root"):GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:emit(var0.ON_CLOSE)
	end)

	arg0.windowTF = arg0:findTF("anim_root/window")
	arg0.titleTF = arg0:findTF("title", arg0.windowTF)

	setText(arg0:findTF("Text", arg0.titleTF), i18n("word_shop"))

	arg0.closeBtn = arg0:findTF("close_btn", arg0.titleTF)
	arg0.discountTF = arg0:findTF("Text/discount", arg0.titleTF)
	arg0.discountValueTF = arg0:findTF("Text", arg0.discountTF)
	arg0.goodContent = arg0:findTF("view/content", arg0.windowTF)
	arg0.goodUIList = UIItemList.New(arg0.goodContent, arg0:findTF("tpl", arg0.goodContent))

	setText(arg0:findTF("tpl/sellout/Text", arg0.goodContent), i18n("word_sell_out"))

	arg0.tipTF = arg0:findTF("tip", arg0.windowTF)
	arg0.detailPanelTF = arg0:findTF("detail/content", arg0.windowTF)
	arg0.detailEmptyTF = arg0:findTF("detail/empty", arg0.windowTF)

	setText(arg0:findTF("Text", arg0.detailEmptyTF), i18n("child_shop_empty_tip"))

	arg0.detailName = arg0:findTF("title/Text", arg0.detailPanelTF)
	arg0.detailDesc = arg0:findTF("desc", arg0.detailPanelTF)
	arg0.detailIcon = arg0:findTF("icon", arg0.detailPanelTF)
	arg0.detailAttrsTF = arg0:findTF("attrs", arg0.detailPanelTF)

	setActive(arg0:findTF("count", arg0.detailPanelTF), false)

	arg0.countValueTF = arg0:findTF("count/bg/Text", arg0.detailPanelTF)
	arg0.addCountBtn = arg0:findTF("count/add", arg0.detailPanelTF)
	arg0.reduceCountBtn = arg0:findTF("count/reduce", arg0.detailPanelTF)
	arg0.maxCountBtn = arg0:findTF("count/max", arg0.detailPanelTF)
	arg0.priceValue = arg0:findTF("price/value/Text", arg0.detailPanelTF)

	setText(arg0:findTF("price/title", arg0.detailPanelTF), i18n("child_shop_price_title"))

	arg0.purchaseBtn = arg0:findTF("purchase_btn", arg0.detailPanelTF)

	setText(arg0:findTF("Text", arg0.purchaseBtn), i18n("word_buy"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0:findTF("anim_root/bg"), function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:_close()
	end, SFX_PANEL)
	onButton(arg0, arg0.addCountBtn, function()
		if arg0.countValue >= arg0:GetMaxCount() then
			return
		end

		arg0.countValue = arg0.countValue + 1

		arg0:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0, arg0.reduceCountBtn, function()
		if arg0.countValue <= 1 then
			return
		end

		arg0.countValue = arg0.countValue - 1

		arg0:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0, arg0.maxCountBtn, function()
		local var0 = arg0:GetMaxCount()

		if arg0.countValue == var0 then
			return
		end

		arg0.countValue = var0

		arg0:updateDetailPrice()
	end, SFX_PANEL)
	onButton(arg0, arg0.purchaseBtn, function()
		if arg0:GetMaxCount() == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

			return
		end

		arg0:emit(EducateShopMediator.ON_SHOPPING, {
			shopId = arg0.shopId,
			goods = {
				{
					id = arg0.goods[arg0.selectedIndex].id,
					num = arg0.countValue
				}
			}
		})
	end, SFX_PANEL)
	arg0.goodUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateGoodItem(arg1, arg2)
		end
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData() + 2
	})

	arg0.selectedIndex = 1
	arg0.countValue = 1

	arg0:refreshShops()
end

function var0.updateGoodItem(arg0, arg1, arg2)
	local var0 = arg1 + 1
	local var1 = arg0.goods[var0]

	setActive(arg0:findTF("discount", arg2), arg0.isDiscount)
	setText(arg0:findTF("discount/Text", arg2), "-" .. arg0.discountValue)

	local var2 = var1:GetPrice()
	local var3 = arg0.isDiscount and var1:GetPrice(arg0.discountRatio) or var2

	setActive(arg0:findTF("bottom/price/price_original", arg2), arg0.isDiscount)
	setText(arg0:findTF("bottom/price/price_original", arg2), var2)
	setText(arg0:findTF("bottom/price/price_final", arg2), var3)

	local var4 = var1:GetShowInfo()

	EducateHelper.UpdateDropShow(arg0:findTF("item", arg2), var4)
	setActive(arg0:findTF("sellout", arg2), not var1:CanBuy())
	setActive(arg0:findTF("selected", arg2), var0 == arg0.selectedIndex)
	onButton(arg0, arg2, function()
		if var0 == arg0.selectedIndex then
			return
		end

		arg0.selectedIndex = var0

		for iter0 = 0, arg0.goodContent.childCount - 1 do
			local var0 = arg0.goodContent:GetChild(iter0)

			setActive(arg0:findTF("selected", var0), iter0 + 1 == arg0.selectedIndex)
		end

		arg0:updateDetail()
	end, SFX_PANEL)
end

function var0.refreshShops(arg0)
	local var0 = getProxy(EducateProxy):GetCurTime()

	arg0.shopProxy = getProxy(EducateProxy):GetShopProxy()
	arg0.shop = arg0.shopProxy:GetShopWithId(arg0.shopId)
	arg0.goods = arg0.shop:GetGoods(var0)
	arg0.char = getProxy(EducateProxy):GetCharData()
	arg0.isDiscount = arg0.shopProxy:IsDiscountById(arg0.shopId)
	arg0.discountRatio = arg0.shopProxy:GetDiscountById(arg0.shopId)
	arg0.discountValue = arg0.isDiscount and arg0.discountRatio / 100 .. "%" or ""

	setActive(arg0.discountTF, arg0.isDiscount)
	setText(arg0.discountValueTF, arg0.discountValue)
	setText(arg0.tipTF, arg0.shop:GetShopTip())
	arg0.goodUIList:align(#arg0.goods)

	local var1 = underscore.detect(arg0.goods, function(arg0)
		return arg0:GetRemainCnt() > 0
	end)

	setActive(arg0.detailEmptyTF, not var1)
	setActive(arg0.detailPanelTF, var1)

	if var1 then
		arg0:updateDetail()
	end
end

function var0.updateDetail(arg0)
	arg0.countValue = 1

	local var0 = arg0.goods[arg0.selectedIndex]:GetShowInfo()
	local var1 = pg.child_item[var0.id]

	setText(arg0.detailName, var1.name)
	setText(arg0.detailDesc, var1.desc)
	setText(arg0.countValueTF, arg0.countValue)
	LoadImageSpriteAsync("educateprops/" .. var1.icon, arg0.detailIcon)

	local var2 = EducateHelper.GetItemAddDrops(var0)

	arg0:updateDetailAttrs(var2)
	arg0:updateDetailPrice()
end

function var0.updateDetailAttrs(arg0, arg1)
	local var0

	var0 = #arg1 > 2 and 2 or #arg1

	for iter0 = 1, arg0.detailAttrsTF.childCount do
		local var1 = arg1[iter0]
		local var2 = arg0.detailAttrsTF:GetChild(iter0 - 1)

		if var1 then
			setActive(var2, true)
			EducateHelper.UpdateDropShowForAttr(var2, var1)
		else
			setActive(var2, false)
		end
	end
end

function var0.updateDetailPrice(arg0)
	setText(arg0.countValueTF, arg0.countValue)

	local var0 = arg0.goods[arg0.selectedIndex]:GetCost(arg0.discountRatio)

	setText(arg0.priceValue, var0.num * arg0.countValue)
	setGray(arg0.purchaseBtn, arg0:GetMaxCount() == 0, true)
end

function var0.GetMaxCount(arg0)
	local var0 = arg0.goods[arg0.selectedIndex]
	local var1 = var0:GetRemainCnt()
	local var2 = var0:GetCost(arg0.discountRatio)
	local var3 = math.floor(arg0.char:GetResById(var2.id) / var2.num)

	return math.min(var1, var3)
end

function var0._close(arg0)
	arg0.anim:Play("anim_educate_shop_out")
end

function var0.onBackPressed(arg0)
	arg0:_close()
end

function var0.willExit(arg0)
	arg0.animEvent:SetEndEvent(nil)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
end

return var0
