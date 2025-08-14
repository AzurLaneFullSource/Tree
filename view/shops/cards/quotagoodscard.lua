local var0_0 = class("QuotaGoodsCard", import(".BaseGoodsCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.limitTag = arg0_1.tf:Find("mask/tag/limit_tag")
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.goodsVO = arg1_2

	local var0_2 = arg0_2.goodsVO:canPurchase()

	setActive(arg0_2.mask, not var0_2)
	setActive(arg0_2.limitTag, not var0_2)
	onButton(arg0_2, arg0_2.mask, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("quota_shop_limit_error"))
	end, SFX_PANEL)

	local var1_2 = arg1_2:getConfig("commodity_type")
	local var2_2 = arg1_2:getConfig("commodity_id")
	local var3_2 = Drop.New({
		type = var1_2,
		id = var2_2,
		count = arg1_2:getConfig("num")
	})

	updateDrop(arg0_2.itemTF, var3_2)

	local var4_2 = ""

	if var1_2 == DROP_TYPE_SKIN then
		var4_2 = pg.ship_skin_template[var2_2].name or "??"
	else
		var4_2 = var3_2:getConfig("name") or "??"
	end

	setScrollText(arg0_2.nameTxt, var4_2)
	setText(arg0_2.countTF, arg1_2:getConfig("resource_num"))

	local var5_2 = Drop.New({
		type = arg1_2:getConfig("resource_category"),
		id = arg1_2:getConfig("resource_type")
	}):getIcon()

	GetImageSpriteFromAtlasAsync(var5_2, "", arg0_2.resIconTF)

	local var6_2 = arg1_2:GetLimitGoodCount()
	local var7_2 = arg1_2:GetPurchasableCnt()

	setText(arg0_2.limitCountLabelTF, i18n("quota_shop_owned") .. var6_2 - var7_2 .. "/" .. var6_2)
	setActive(arg0_2.limitCountLabelTF, true)
end

function var0_0.setAsLastSibling(arg0_4)
	arg0_4.tf:SetAsLastSibling()
end

function var0_0.OnDispose(arg0_5)
	arg0_5.goodsVO = nil
end

return var0_0
