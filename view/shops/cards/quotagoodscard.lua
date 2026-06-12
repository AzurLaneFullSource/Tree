local var0_0 = class("QuotaGoodsCard", import(".BaseGoodsCard"))

function var0_0.update(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.goodsVO = arg1_1

	local var0_1 = arg0_1.goodsVO:canPurchase()

	setActive(arg0_1.mask, not var0_1)
	setActive(arg0_1.limitTag, not var0_1)
	onButton(arg0_1, arg0_1.mask, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("quota_shop_limit_error"))
	end, SFX_PANEL)

	local var1_1 = arg1_1:getConfig("commodity_type")
	local var2_1 = arg1_1:getConfig("commodity_id")
	local var3_1 = Drop.New({
		type = var1_1,
		id = var2_1,
		count = arg1_1:getConfig("num")
	})

	updateDrop(arg0_1.itemTF, var3_1)

	local var4_1 = ""

	if var1_1 == DROP_TYPE_SKIN then
		var4_1 = pg.ship_skin_template[var2_1].name or "??"
	else
		var4_1 = var3_1:getConfig("name") or "??"
	end

	setScrollText(arg0_1.nameTxt, var4_1)
	setText(arg0_1.countTF, arg1_1:getConfig("resource_num"))

	local var5_1 = Drop.New({
		type = arg1_1:getConfig("resource_category"),
		id = arg1_1:getConfig("resource_type")
	}):getIcon()

	GetImageSpriteFromAtlasAsync(var5_1, "", arg0_1.resIconTF)

	local var6_1 = arg1_1:GetLimitGoodCount()
	local var7_1 = math.min(arg1_1:GetOwnedGoodCount(), var6_1)

	setText(arg0_1.limitCountLabelTF, i18n("quota_shop_owned") .. var6_1 - var7_1 .. "/" .. var6_1)
	setActive(arg0_1.limitCountLabelTF, true)
	setActive(arg0_1.groupLocked, arg0_1.itemTF:Find("group_locked").gameObject.activeSelf)
end

function var0_0.setAsLastSibling(arg0_3)
	arg0_3.tf:SetAsLastSibling()
end

function var0_0.OnDispose(arg0_4)
	arg0_4.goodsVO = nil
end

return var0_0
