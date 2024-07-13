local var0_0 = class("ActivityGoodsCard", import(".BaseGoodsCard"))

var0_0.Color = {}
var0_0.DefaultColor = {
	0.874509803921569,
	0.929411764705882,
	1
}

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.go = arg1_1
	arg0_1.tr = tf(arg1_1)
	arg0_1.itemTF = findTF(arg0_1.tr, "item")
	arg0_1.nameTxt = findTF(arg0_1.tr, "item/name_mask/name")
	arg0_1.resIconTF = findTF(arg0_1.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	arg0_1.mask = arg0_1.tr:Find("mask")
	arg0_1.selloutTag = arg0_1.tr:Find("mask/tag/sellout_tag")
	arg0_1.sellEndTag = arg0_1.tr:Find("mask/tag/sellend_tag")

	setActive(arg0_1.sellEndTag, false)

	arg0_1.unexchangeTag = arg0_1.tr:Find("mask/tag/unexchange_tag")
	arg0_1.countTF = findTF(arg0_1.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0_1.discountTF = findTF(arg0_1.tr, "item/discount")

	setActive(arg0_1.discountTF, false)

	arg0_1.limitTimeSellTF = findTF(arg0_1.tr, "item/limit_time_sell")

	setActive(arg0_1.limitTimeSellTF, false)

	arg0_1.limitCountTF = findTF(arg0_1.tr, "item/count_contain/count"):GetComponent(typeof(Text))
	arg0_1.limitCountLabelTF = findTF(arg0_1.tr, "item/count_contain/label"):GetComponent(typeof(Text))
	arg0_1.limitCountLabelTF.text = i18n("activity_shop_exchange_count")
	arg0_1.tagImg = arg0_1.tr:Find("mask/tag"):GetComponent(typeof(Image))
	arg0_1.limitPassTag = arg0_1.tr:Find("mask/tag/pass_tag")
end

function var0_0.update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.goodsVO = arg1_2

	local var0_2 = arg0_2.goodsVO:CheckCntLimit()
	local var1_2 = var0_2 and not arg0_2.goodsVO:CheckArgLimit()

	setActive(arg0_2.mask, not var0_2 or var1_2)
	setActive(arg0_2.selloutTag, not var0_2)

	if arg0_2.limitPassTag then
		setActive(arg0_2.limitPassTag, false)
	end

	removeOnButton(arg0_2.mask)

	if var1_2 then
		local var2_2, var3_2, var4_2 = arg0_2.goodsVO:CheckArgLimit()

		if var3_2 == "pass" then
			setActive(arg0_2.limitPassTag, true)
			setText(findTF(arg0_2.limitPassTag, "Text"), i18n("eventshop_unlock_info", var4_2))
			onButton(arg0_2, arg0_2.mask, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("eventshop_unlock_hint", var4_2))
			end, SFX_PANEL)
		elseif var3_2 == 1 or var3_2 == 2 then
			setText(arg0_2.unexchangeTag, var4_2)

			local var5_2 = ""

			if var3_2 == 1 then
				var5_2 = "LIMIT"
			end

			if var3_2 == 2 then
				var5_2 = "LOCK"
			end

			setText(arg0_2.unexchangeTag:Find("sellout_tag_en"), var5_2)
			setActive(arg0_2.unexchangeTag, true)
		end
	end

	local var6_2 = Drop.New({
		type = arg1_2:getConfig("commodity_type"),
		id = arg1_2:getConfig("commodity_id"),
		count = arg1_2:getConfig("num")
	})

	updateDrop(arg0_2.itemTF, var6_2)
	setActive(arg0_2.limitTimeSellTF, false)

	if var0_2 then
		local var7_2, var8_2, var9_2 = arg0_2.goodsVO:CheckTimeLimit()

		setActive(arg0_2.limitTimeSellTF, var7_2 and var8_2)

		if var7_2 and not var8_2 then
			setActive(arg0_2.mask, true)
			setActive(arg0_2.sellEndTag, true)
			removeOnButton(arg0_2.mask)
			onButton(arg0_2, arg0_2.mask, function()
				if var9_2 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var6_2:getName()))
				end
			end, SFX_PANEL)
		end
	end

	GetSpriteFromAtlasAsync(Drop.New({
		type = arg1_2:getConfig("resource_category"),
		id = arg1_2:getConfig("resource_type")
	}):getIcon(), "", function(arg0_5)
		arg0_2.resIconTF.sprite = arg0_5
	end)

	arg0_2.countTF.text = arg1_2:getConfig("resource_num")

	local var10_2 = var6_2:getName() or "??"

	if string.match(var10_2, "(%d+)") then
		setText(arg0_2.nameTxt, shortenString(var10_2, 5))
	else
		setText(arg0_2.nameTxt, shortenString(var10_2, 6))
	end

	local var11_2 = arg1_2:getConfig("num_limit")

	if var11_2 == 0 then
		arg0_2.limitCountTF.text = i18n("common_no_limit")
	else
		local var12_2 = arg1_2:GetPurchasableCnt()

		arg0_2.limitCountTF.text = math.max(var12_2, 0) .. "/" .. var11_2
	end

	local var13_2 = var0_0.Color[arg2_2] or var0_0.DefaultColor

	arg0_2.limitCountTF.color = arg3_2 or Color.New(unpack(var13_2))
	arg0_2.limitCountLabelTF.color = arg3_2 or Color.New(unpack(var13_2))
	arg4_2 = arg4_2 or Color.New(0, 0, 0, 1)

	if GetComponent(arg0_2.limitCountTF, typeof(Outline)) then
		setOutlineColor(arg0_2.limitCountTF, arg4_2)
	end

	if GetComponent(arg0_2.limitCountLabelTF, typeof(Outline)) then
		setOutlineColor(arg0_2.limitCountLabelTF, arg4_2)
	end
end

function var0_0.setAsLastSibling(arg0_6)
	arg0_6.tr:SetAsLastSibling()
end

function var0_0.StaticUpdate(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = tf(arg0_7)
	local var1_7 = findTF(var0_7, "item")
	local var2_7 = findTF(var0_7, "item/name_mask/name")
	local var3_7 = findTF(var0_7, "item/consume/contain/icon"):GetComponent(typeof(Image))
	local var4_7 = var0_7:Find("mask")
	local var5_7 = var0_7:Find("mask/tag/sellout_tag")
	local var6_7 = findTF(var0_7, "item/consume/contain/Text"):GetComponent(typeof(Text))
	local var7_7 = findTF(var0_7, "item/discount")

	setActive(var7_7, false)

	local var8_7 = findTF(var0_7, "item/count_contain/count"):GetComponent(typeof(Text))
	local var9_7 = findTF(var0_7, "item/count_contain/label"):GetComponent(typeof(Text))
	local var10_7, var11_7 = arg1_7:canPurchase()

	setActive(var4_7, not var10_7)
	setActive(var5_7, not var10_7)

	local var12_7 = Drop.New({
		type = arg1_7:getConfig("commodity_type"),
		id = arg1_7:getConfig("commodity_id"),
		count = arg1_7:getConfig("num")
	})

	updateDrop(var1_7, var12_7)

	local var13_7 = var12_7:getConfig("name") or "??"

	var6_7.text = arg1_7:getConfig("resource_num")

	if string.match(var13_7, "(%d+)") then
		setText(var2_7, shortenString(var13_7, 5))
	else
		setText(var2_7, shortenString(var13_7, 6))
	end

	var3_7.sprite = GetSpriteFromAtlas(Drop.New({
		type = arg1_7:getConfig("resource_category"),
		id = arg1_7:getConfig("resource_type")
	}):getIcon(), "")

	if arg1_7:getConfig("num_limit") == 0 then
		var8_7.text = i18n("common_no_limit")
	else
		local var14_7 = arg1_7:getConfig("num_limit")

		if var12_7.type == DROP_TYPE_SKIN and not var10_7 then
			var8_7.text = "0/" .. var14_7
		else
			var8_7.text = var14_7 - arg1_7.buyCount .. "/" .. var14_7
		end
	end

	local var15_7 = var0_0.Color[arg2_7] or var0_0.DefaultColor

	var8_7.color = arg3_7 or Color.New(var15_7[1], var15_7[2], var15_7[3], 1)
	var9_7.color = arg3_7 or Color.New(var15_7[1], var15_7[2], var15_7[3], 1)

	if arg1_7:getConfig("num_limit") >= 99 then
		var9_7.text = i18n("shop_label_unlimt_cnt")
		var8_7.text = ""
	end
end

function var0_0.OnDispose(arg0_8)
	arg0_8.goodsVO = nil
end

return var0_0
