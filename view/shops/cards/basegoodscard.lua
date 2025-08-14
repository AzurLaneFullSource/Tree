local var0_0 = class("BaseGoodsCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.mask = findTF(arg0_1.tf, "mask")
	arg0_1.selloutTag = findTF(arg0_1.tf, "mask/tag/sellout_tag")
	arg0_1.sellEndTag = findTF(arg0_1.tf, "mask/tag/sellend_tag")
	arg0_1.levelTag = findTF(arg0_1.tf, "mask/tag/level_tag")
	arg0_1.unexchangeTag = findTF(arg0_1.tf, "mask/tag/unexchange_tag")
	arg0_1.nameTxt = findTF(arg0_1.tf, "name_mask/name")
	arg0_1.discountTF = findTF(arg0_1.tf, "discount")
	arg0_1.discountTextTF = findTF(arg0_1.discountTF, "Text")
	arg0_1.countTF = findTF(arg0_1.tf, "consume/contain/Text")
	arg0_1.resIconTF = findTF(arg0_1.tf, "consume/contain/icon"):GetComponent(typeof(Image))
	arg0_1.limitCountLabelTF = findTF(arg0_1.tf, "count_contain/label")
	arg0_1.itemTF = findTF(arg0_1.tf, "itemBg/item")
	arg0_1.itemIconBgTF = findTF(arg0_1.itemTF, "icon_bg")
	arg0_1.itemIconFrameTF = findTF(arg0_1.itemTF, "icon_bg/frame")
	arg0_1.stars = findTF(arg0_1.itemTF, "icon_bg/stars")
	arg0_1.itemIconTF = findTF(arg0_1.itemTF, "icon_bg/icon"):GetComponent(typeof(Image))
	arg0_1.itemCountTF = findTF(arg0_1.itemTF, "icon_bg/count")
	arg0_1.maskTip = i18n("buy_countLimit")

	setActive(arg0_1.discountTF, false)
	setActive(arg0_1.tf:Find("group_locked"), false)
	setActive(arg0_1.tf:Find("group_locked/Text"), i18n("shop_item_unobtained"))
	setActive(arg0_1.tf:Find("limit_time_sell"), false)
	setActive(arg0_1.tf:Find("itemBg/item/icon_bg/slv"), false)
	eachChild(arg0_1.tf:Find("mask/tag"), function(arg0_2)
		setActive(arg0_2, false)
	end)
	ClearAllText(arg0_1.go)
	removeAllOnButton(arg0_1.go)
	setText(arg0_1.tf:Find("mask/tag/limit_tag"), i18n("quota_shop_good_limit"))
	setText(arg0_1.tf:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	setText(arg0_1.tf:Find("mask/tag/unexchange_tag"), i18n("meta_shop_exchange_limit"))
	setText(arg0_1.sellEndTag, i18n("shop_sell_ended"))
	setText(arg0_1.selloutTag, i18n("common_sale_out"))
	removeAllChildren(arg0_1.stars)

	local var0_1 = arg0_1.tf:Find("itemBg/item/icon_bg/icon")

	var0_1.offsetMin = Vector2(2, 2)
	var0_1.offsetMax = Vector2(-2, -2)

	local var1_1 = arg0_1.tf:Find("itemBg/item/icon_bg/frame")

	var1_1.offsetMin = Vector2(0, 0)
	var1_1.offsetMax = Vector2(0, 0)
end

function var0_0.Dispose(arg0_3)
	arg0_3:OnDispose()
	pg.DelegateInfo.Dispose(arg0_3)
end

function var0_0.OnDispose(arg0_4)
	return
end

return var0_0
