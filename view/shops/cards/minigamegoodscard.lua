local var0_0 = class("MiniGameGoodsCard", import(".BaseGoodsCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.mask = arg0_1.tr:Find("mask")
	arg0_1.selloutTag = arg0_1.tr:Find("mask/tag/sellout_tag")

	setActive(arg0_1.selloutTag, true)
	setText(arg0_1.selloutTag, i18n("common_sale_out"))

	arg0_1.levelTag = arg0_1.tr:Find("mask/tag/level_tag")

	setText(arg0_1.levelTag, i18n("shop_charge_level_limit"))

	arg0_1.levelTagText = arg0_1.tr:Find("mask/tag/level_tag/Text")
	arg0_1.stars = arg0_1.tr:Find("item/icon_bg/stars")
	arg0_1.itemTF = findTF(arg0_1.tr, "item")
	arg0_1.nameTxt = findTF(arg0_1.tr, "item/name_mask/name")
	arg0_1.discountTF = findTF(arg0_1.tr, "item/discount")
	arg0_1.discountTextTF = findTF(arg0_1.discountTF, "Text"):GetComponent(typeof(Text))
	arg0_1.countTF = findTF(arg0_1.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0_1.resIconTF = findTF(arg0_1.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	arg0_1.itemIconTF = arg0_1.itemTF:Find("icon_bg/icon"):GetComponent(typeof(Image))
	arg0_1.itemCountTF = arg0_1.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0_1.countContainTf = findTF(arg0_1.tr, "item/count_contain/count")

	setText(findTF(arg0_1.tr, "item/count_contain/label"), i18n("activity_shop_exchange_count"))

	arg0_1.maskTip = i18n("buy_countLimit")

	setText(arg0_1.tr:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	onButton(arg0_1, arg0_1.mask, function()
		pg.TipsMgr.GetInstance():ShowTips(arg0_1.maskTip)
	end, SFX_PANEL)
end

function var0_0.setGroupMask(arg0_3, arg1_3)
	local var0_3 = arg0_3.goodsVO:getConfig("group_limit")
	local var1_3 = var0_3 > 0 and var0_3 <= arg1_3

	if isActive(arg0_3.mask) then
		return
	end

	setActive(arg0_3.mask, var1_3)

	if var0_3 > 0 and var0_3 <= arg1_3 then
		setActive(arg0_3.selloutTag, true)
		setActive(arg0_3.levelTag, false)
	end
end

function var0_0.setLevelMask(arg0_4, arg1_4)
	local var0_4 = arg0_4.goodsVO:getLevelLimit(arg1_4)
	local var1_4 = arg0_4.goodsVO:isLevelLimit(arg1_4)

	if isActive(arg0_4.mask) then
		return
	end

	setActive(arg0_4.mask, var1_4)

	if var1_4 then
		setText(arg0_4.levelTagText, tostring(var0_4))
		setActive(arg0_4.levelTag, true)
		setActive(arg0_4.selloutTag, false)

		arg0_4.maskTip = i18n("charge_level_limit")
	end
end

function var0_0.update(arg0_5, arg1_5)
	arg0_5.goodsVO = arg1_5

	local var0_5 = arg0_5.goodsVO:CanPurchase()

	setActive(arg0_5.mask, not var0_5)
	setActive(arg0_5.stars, false)

	local var1_5 = arg1_5:GetDropInfo()

	updateDrop(arg0_5.itemTF, var1_5)

	local var2_5 = var1_5:getConfig("name") or ""

	setText(arg0_5.nameTxt, shortenString(var2_5, 6))

	local var3_5 = ""
	local var4_5 = arg1_5:getConfig("price")
	local var5_5 = arg1_5:GetMaxCnt()
	local var6_5 = arg1_5:getConfig("goods_purchase_limit")

	setText(arg0_5.countContainTf, var5_5 .. "/" .. var6_5)
	setActive(arg0_5.discountTF, false)

	arg0_5.countTF.text = math.ceil(var4_5)

	GetSpriteFromAtlasAsync("ui/ShopsUI_atlas", "minigameRes", function(arg0_6)
		arg0_5.resIconTF:GetComponent(typeof(Image)).sprite = arg0_6
	end)
end

function var0_0.OnDispose(arg0_7)
	arg0_7.goodsVO = nil
end

return var0_0
