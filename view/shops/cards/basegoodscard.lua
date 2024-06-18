local var0_0 = class("BaseGoodsCard")

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform

	setActive(arg0_1.tf:Find("item/discount"), false)
	setActive(arg0_1.tf:Find("item/group_locked"), false)
	setActive(arg0_1.tf:Find("item/limit_time_sell"), false)
	setActive(arg0_1.tf:Find("item/icon_bg/slv"), false)
	eachChild(arg0_1.tf:Find("mask/tag"), function(arg0_2)
		setActive(arg0_2, false)
	end)
	ClearAllText(arg0_1.go)
	removeAllOnButton(arg0_1.go)
	setText(arg0_1.tf:Find("mask/tag/limit_tag"), i18n("quota_shop_good_limit"))
	setText(arg0_1.tf:Find("mask/tag/limit_tag/limit_tag_en"), "LIMIT")
	setText(arg0_1.tf:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	setText(arg0_1.tf:Find("mask/tag/sellout_tag/sellout_tag_en"), "SELL OUT")
	setText(arg0_1.tf:Find("mask/tag/unexchange_tag"), i18n("meta_shop_exchange_limit"))
	setText(arg0_1.tf:Find("mask/tag/unexchange_tag/sellout_tag_en"), "LIMIT")
	removeAllChildren(arg0_1.tf:Find("item/icon_bg/stars"))

	local var0_1 = arg0_1.tf:Find("item/icon_bg/icon")

	var0_1.offsetMin = Vector2(2, 2)
	var0_1.offsetMax = Vector2(-2, -2)

	local var1_1 = arg0_1.tf:Find("item/icon_bg/frame")

	var1_1.offsetMin = Vector2(0, 0)
	var1_1.offsetMax = Vector2(0, 0)
end

function var0_0.Dispose(arg0_3)
	arg0_3:OnDispose()
	eachChild(arg0_3.tf:Find("item/icon_bg/frame"), function(arg0_4)
		setActive(arg0_4, false)
	end)
	pg.DelegateInfo.Dispose(arg0_3)
end

function var0_0.OnDispose(arg0_5)
	return
end

return var0_0
