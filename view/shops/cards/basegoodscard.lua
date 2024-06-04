local var0 = class("BaseGoodsCard")

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.go = arg1
	arg0.tf = arg1.transform

	setActive(arg0.tf:Find("item/discount"), false)
	setActive(arg0.tf:Find("item/group_locked"), false)
	setActive(arg0.tf:Find("item/limit_time_sell"), false)
	setActive(arg0.tf:Find("item/icon_bg/slv"), false)
	eachChild(arg0.tf:Find("mask/tag"), function(arg0)
		setActive(arg0, false)
	end)
	ClearAllText(arg0.go)
	removeAllOnButton(arg0.go)
	setText(arg0.tf:Find("mask/tag/limit_tag"), i18n("quota_shop_good_limit"))
	setText(arg0.tf:Find("mask/tag/limit_tag/limit_tag_en"), "LIMIT")
	setText(arg0.tf:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	setText(arg0.tf:Find("mask/tag/sellout_tag/sellout_tag_en"), "SELL OUT")
	setText(arg0.tf:Find("mask/tag/unexchange_tag"), i18n("meta_shop_exchange_limit"))
	setText(arg0.tf:Find("mask/tag/unexchange_tag/sellout_tag_en"), "LIMIT")
	removeAllChildren(arg0.tf:Find("item/icon_bg/stars"))

	local var0 = arg0.tf:Find("item/icon_bg/icon")

	var0.offsetMin = Vector2(2, 2)
	var0.offsetMax = Vector2(-2, -2)

	local var1 = arg0.tf:Find("item/icon_bg/frame")

	var1.offsetMin = Vector2(0, 0)
	var1.offsetMax = Vector2(0, 0)
end

function var0.Dispose(arg0)
	arg0:OnDispose()
	eachChild(arg0.tf:Find("item/icon_bg/frame"), function(arg0)
		setActive(arg0, false)
	end)
	pg.DelegateInfo.Dispose(arg0)
end

function var0.OnDispose(arg0)
	return
end

return var0
