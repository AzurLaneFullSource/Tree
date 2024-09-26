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
	if arg1_2:Selectable() then
		arg0_2:updateSelectable(arg1_2, arg2_2, arg3_2, arg4_2)
	else
		arg0_2:updateSingle(arg1_2, arg2_2, arg3_2, arg4_2)
	end
end

function var0_0.updateSingle(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.goodsVO = arg1_3

	local var0_3 = arg0_3.goodsVO:CheckCntLimit()
	local var1_3 = var0_3 and not arg0_3.goodsVO:CheckArgLimit()

	setActive(arg0_3.mask, not var0_3 or var1_3)
	setActive(arg0_3.selloutTag, not var0_3)

	if arg0_3.limitPassTag then
		setActive(arg0_3.limitPassTag, false)
	end

	removeOnButton(arg0_3.mask)

	if var1_3 then
		local var2_3, var3_3, var4_3 = arg0_3.goodsVO:CheckArgLimit()

		if var3_3 == "pass" then
			setActive(arg0_3.limitPassTag, true)
			setText(findTF(arg0_3.limitPassTag, "Text"), i18n("eventshop_unlock_info", var4_3))
			onButton(arg0_3, arg0_3.mask, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("eventshop_unlock_hint", var4_3))
			end, SFX_PANEL)
		elseif var3_3 == 1 or var3_3 == 2 or var3_3 == ShopArgs.LIMIT_ARGS_UNIQUE_SHIP then
			setText(arg0_3.unexchangeTag, var4_3)

			local var5_3 = ""

			if var3_3 == 1 or var3_3 == ShopArgs.LIMIT_ARGS_UNIQUE_SHIP then
				var5_3 = "LIMIT"
			end

			if var3_3 == 2 then
				var5_3 = "LOCK"
			end

			setText(arg0_3.unexchangeTag:Find("sellout_tag_en"), var5_3)
			setActive(arg0_3.unexchangeTag, true)
		end
	end

	local var6_3 = Drop.New({
		type = arg1_3:getConfig("commodity_type"),
		id = arg1_3:getConfig("commodity_id"),
		count = arg1_3:getConfig("num")
	})

	updateDrop(arg0_3.itemTF, var6_3)
	setActive(arg0_3.limitTimeSellTF, false)

	if var0_3 then
		local var7_3, var8_3, var9_3 = arg0_3.goodsVO:CheckTimeLimit()

		setActive(arg0_3.limitTimeSellTF, var7_3 and var8_3)

		if var7_3 and not var8_3 then
			setActive(arg0_3.mask, true)
			setActive(arg0_3.sellEndTag, true)
			removeOnButton(arg0_3.mask)
			onButton(arg0_3, arg0_3.mask, function()
				if var9_3 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var6_3:getName()))
				end
			end, SFX_PANEL)
		end
	end

	GetSpriteFromAtlasAsync(Drop.New({
		type = arg1_3:getConfig("resource_category"),
		id = arg1_3:getConfig("resource_type")
	}):getIcon(), "", function(arg0_6)
		arg0_3.resIconTF.sprite = arg0_6
	end)

	arg0_3.countTF.text = arg1_3:getConfig("resource_num")

	local var10_3 = var6_3:getName() or "??"

	if string.match(var10_3, "(%d+)") then
		setText(arg0_3.nameTxt, shortenString(var10_3, 5))
	else
		setText(arg0_3.nameTxt, shortenString(var10_3, 6))
	end

	local var11_3 = arg1_3:getConfig("num_limit")

	if var11_3 == 0 then
		arg0_3.limitCountTF.text = i18n("common_no_limit")
	else
		local var12_3 = arg1_3:GetPurchasableCnt()

		arg0_3.limitCountTF.text = math.max(var12_3, 0) .. "/" .. var11_3
	end

	local var13_3 = var0_0.Color[arg2_3] or var0_0.DefaultColor

	arg0_3.limitCountTF.color = arg3_3 or Color.New(unpack(var13_3))
	arg0_3.limitCountLabelTF.color = arg3_3 or Color.New(unpack(var13_3))
	arg4_3 = arg4_3 or Color.New(0, 0, 0, 1)

	if GetComponent(arg0_3.limitCountTF, typeof(Outline)) then
		setOutlineColor(arg0_3.limitCountTF, arg4_3)
	end

	if GetComponent(arg0_3.limitCountLabelTF, typeof(Outline)) then
		setOutlineColor(arg0_3.limitCountLabelTF, arg4_3)
	end
end

function var0_0.updateSelectable(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	arg0_7.goodsVO = arg1_7

	local var0_7 = Drop.New({
		count = 1,
		type = DROP_TYPE_ITEM,
		id = arg1_7:getConfig("commodity_id_list_show")
	})

	updateDrop(arg0_7.itemTF, var0_7)
	setActive(arg0_7.mask, false)
	setActive(arg0_7.selloutTag, fasle)

	if arg0_7.limitPassTag then
		setActive(arg0_7.limitPassTag, false)
	end

	removeOnButton(arg0_7.mask)
	setActive(arg0_7.limitTimeSellTF, false)
	GetSpriteFromAtlasAsync(Drop.New({
		type = arg1_7:getConfig("resource_category"),
		id = arg1_7:getConfig("resource_type")
	}):getIcon(), "", function(arg0_8)
		arg0_7.resIconTF.sprite = arg0_8
	end)

	arg0_7.countTF.text = arg1_7:getConfig("resource_num")

	local var1_7 = var0_7:getName() or "??"

	if string.match(var1_7, "(%d+)") then
		setText(arg0_7.nameTxt, shortenString(var1_7, 5))
	else
		setText(arg0_7.nameTxt, shortenString(var1_7, 6))
	end

	local var2_7 = arg1_7:getConfig("num_limit")

	if var2_7 == 0 then
		arg0_7.limitCountTF.text = i18n("common_no_limit")
	else
		local var3_7 = arg1_7:GetPurchasableCnt()

		arg0_7.limitCountTF.text = math.max(var3_7, 0) .. "/" .. var2_7
	end

	local var4_7 = var0_0.Color[arg2_7] or var0_0.DefaultColor

	arg0_7.limitCountTF.color = arg3_7 or Color.New(unpack(var4_7))
	arg0_7.limitCountLabelTF.color = arg3_7 or Color.New(unpack(var4_7))
	arg4_7 = arg4_7 or Color.New(0, 0, 0, 1)

	if GetComponent(arg0_7.limitCountTF, typeof(Outline)) then
		setOutlineColor(arg0_7.limitCountTF, arg4_7)
	end

	if GetComponent(arg0_7.limitCountLabelTF, typeof(Outline)) then
		setOutlineColor(arg0_7.limitCountLabelTF, arg4_7)
	end
end

function var0_0.setAsLastSibling(arg0_9)
	arg0_9.tr:SetAsLastSibling()
end

function var0_0.StaticUpdate(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = tf(arg0_10)
	local var1_10 = findTF(var0_10, "item")
	local var2_10 = findTF(var0_10, "item/name_mask/name")
	local var3_10 = findTF(var0_10, "item/consume/contain/icon"):GetComponent(typeof(Image))
	local var4_10 = var0_10:Find("mask")
	local var5_10 = var0_10:Find("mask/tag/sellout_tag")
	local var6_10 = findTF(var0_10, "item/consume/contain/Text"):GetComponent(typeof(Text))
	local var7_10 = findTF(var0_10, "item/discount")

	setActive(var7_10, false)

	local var8_10 = findTF(var0_10, "item/count_contain/count"):GetComponent(typeof(Text))
	local var9_10 = findTF(var0_10, "item/count_contain/label"):GetComponent(typeof(Text))
	local var10_10, var11_10 = arg1_10:canPurchase()

	setActive(var4_10, not var10_10)
	setActive(var5_10, not var10_10)

	local var12_10 = Drop.New({
		type = arg1_10:getConfig("commodity_type"),
		id = arg1_10:getConfig("commodity_id"),
		count = arg1_10:getConfig("num")
	})

	updateDrop(var1_10, var12_10)

	local var13_10 = var12_10:getConfig("name") or "??"

	var6_10.text = arg1_10:getConfig("resource_num")

	if string.match(var13_10, "(%d+)") then
		setText(var2_10, shortenString(var13_10, 5))
	else
		setText(var2_10, shortenString(var13_10, 6))
	end

	var3_10.sprite = GetSpriteFromAtlas(Drop.New({
		type = arg1_10:getConfig("resource_category"),
		id = arg1_10:getConfig("resource_type")
	}):getIcon(), "")

	if arg1_10:getConfig("num_limit") == 0 then
		var8_10.text = i18n("common_no_limit")
	else
		local var14_10 = arg1_10:getConfig("num_limit")

		if var12_10.type == DROP_TYPE_SKIN and not var10_10 then
			var8_10.text = "0/" .. var14_10
		else
			var8_10.text = var14_10 - arg1_10.buyCount .. "/" .. var14_10
		end
	end

	local var15_10 = var0_0.Color[arg2_10] or var0_0.DefaultColor

	var8_10.color = arg3_10 or Color.New(var15_10[1], var15_10[2], var15_10[3], 1)
	var9_10.color = arg3_10 or Color.New(var15_10[1], var15_10[2], var15_10[3], 1)

	if arg1_10:getConfig("num_limit") >= 99 then
		var9_10.text = i18n("shop_label_unlimt_cnt")
		var8_10.text = ""
	end
end

function var0_0.OnDispose(arg0_11)
	arg0_11.goodsVO = nil
end

return var0_0
