local var0 = class("QuotaGoodsCard", import(".BaseGoodsCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.itemTF = findTF(arg0.tr, "item")
	arg0.nameTxt = findTF(arg0.tr, "item/name_mask/name")
	arg0.resIconTF = findTF(arg0.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	arg0.mask = arg0.tr:Find("mask")
	arg0.countTF = findTF(arg0.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0.discountTF = findTF(arg0.tr, "item/discount")

	setActive(arg0.discountTF, false)

	arg0.limitCountTF = findTF(arg0.tr, "item/count_contain/count"):GetComponent(typeof(Text))
	arg0.limitCountLabelTF = findTF(arg0.tr, "item/count_contain/label"):GetComponent(typeof(Text))
	arg0.limitCountLabelTF.text = i18n("quota_shop_owned")
	arg0.limitTag = arg0.tr:Find("mask/tag/limit_tag")
end

function var0.update(arg0, arg1, arg2, arg3, arg4)
	arg0.goodsVO = arg1

	local var0 = arg0.goodsVO:canPurchase()

	setActive(arg0.mask, not var0)
	setActive(arg0.limitTag, not var0)
	onButton(arg0, arg0.mask, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("quota_shop_limit_error"))
	end, SFX_PANEL)

	local var1 = arg1:getConfig("commodity_type")
	local var2 = arg1:getConfig("commodity_id")
	local var3 = Drop.New({
		type = var1,
		id = var2,
		count = arg1:getConfig("num")
	})

	updateDrop(arg0.itemTF, var3)

	local var4 = ""

	if var1 == DROP_TYPE_SKIN then
		var4 = pg.ship_skin_template[var2].name or "??"
	else
		var4 = var3:getConfig("name") or "??"
	end

	arg0.countTF.text = arg1:getConfig("resource_num")

	if string.match(var4, "(%d+)") then
		setText(arg0.nameTxt, shortenString(var4, 5))
	else
		setText(arg0.nameTxt, shortenString(var4, 6))
	end

	local var5 = Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getIcon()

	arg0.resIconTF.sprite = GetSpriteFromAtlas(var5, "")

	local var6 = arg1:GetLimitGoodCount()
	local var7 = arg1:GetPurchasableCnt()

	arg0.limitCountTF.text = var6 - var7 .. "/" .. var6
end

function var0.setAsLastSibling(arg0)
	arg0.tr:SetAsLastSibling()
end

function var0.OnDispose(arg0)
	arg0.goodsVO = nil
end

return var0
