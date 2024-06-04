local var0 = class("GoodsCard", import(".BaseGoodsCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.mask = arg0.tr:Find("mask")
	arg0.selloutTag = arg0.tr:Find("mask/tag/sellout_tag")

	setText(arg0.selloutTag, i18n("common_sale_out"))

	arg0.levelTag = arg0.tr:Find("mask/tag/level_tag")

	setText(arg0.levelTag, i18n("shop_charge_level_limit"))

	arg0.levelTagText = arg0.tr:Find("mask/tag/level_tag/Text")
	arg0.stars = arg0.tr:Find("item/icon_bg/stars")
	arg0.itemTF = findTF(arg0.tr, "item")
	arg0.nameTxt = findTF(arg0.tr, "item/name_mask/name")
	arg0.discountTF = findTF(arg0.tr, "item/discount")
	arg0.discountTextTF = findTF(arg0.discountTF, "Text"):GetComponent(typeof(Text))
	arg0.countTF = findTF(arg0.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0.resIconTF = findTF(arg0.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	arg0.itemIconTF = arg0.itemTF:Find("icon_bg/icon"):GetComponent(typeof(Image))
	arg0.itemCountTF = arg0.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0.maskTip = i18n("buy_countLimit")

	onButton(arg0, arg0.mask, function()
		pg.TipsMgr.GetInstance():ShowTips(arg0.maskTip)
	end, SFX_PANEL)
end

function var0.setGroupMask(arg0, arg1)
	local var0 = arg0.goodsVO:getConfig("group_limit")
	local var1 = var0 > 0 and var0 <= arg1

	if isActive(arg0.mask) then
		return
	end

	setActive(arg0.mask, var1)

	if var0 > 0 and var0 <= arg1 then
		setActive(arg0.selloutTag, true)
		setActive(arg0.levelTag, false)
	end
end

function var0.setLevelMask(arg0, arg1)
	local var0 = arg0.goodsVO:getLevelLimit(arg1)
	local var1 = arg0.goodsVO:isLevelLimit(arg1)

	if isActive(arg0.mask) then
		return
	end

	setActive(arg0.mask, var1)

	if var1 then
		setText(arg0.levelTagText, tostring(var0))
		setActive(arg0.levelTag, true)
		setActive(arg0.selloutTag, false)

		arg0.maskTip = i18n("charge_level_limit")
	end
end

function var0.update(arg0, arg1)
	arg0.goodsVO = arg1

	local var0 = arg0.goodsVO:canPurchase()

	setActive(arg0.mask, not var0)
	setActive(arg0.selloutTag, not var0)
	setActive(arg0.stars, false)

	local var1 = arg1:getDropInfo()

	updateDrop(arg0.itemTF, var1)

	local var2 = var1:getConfig("name") or ""

	setText(arg0.nameTxt, shortenString(var2, 6))

	local var3 = ""
	local var4 = arg1:getConfig("resource_num")

	if arg1:getConfig("genre") == ShopArgs.ShoppingStreetLimit then
		var3 = 100 - arg1.discount .. "%OFF"
		var4 = var4 * (arg1.discount / 100)
	end

	setActive(arg0.discountTF, false)

	arg0.discountTF = arg1.activityDiscount and findTF(arg0.tr, "item/discount_activity") or findTF(arg0.tr, "item/discount")
	arg0.discountTextTF = findTF(arg0.discountTF, "Text"):GetComponent(typeof(Text))

	setActive(arg0.discountTF, arg1:hasDiscount())

	arg0.discountTextTF.text = var3
	arg0.countTF.text = math.ceil(var4)

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg1:getConfig("resource_type")
	}):getIcon(), "", tf(arg0.resIconTF))
end

function var0.OnDispose(arg0)
	arg0.goodsVO = nil
end

return var0
