local var0_0 = class("ActivityGoodsCard", import(".BaseGoodsCard"))

var0_0.Color = {}
var0_0.DefaultColor = {
	0.874509803921569,
	0.929411764705882,
	1
}

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.limitPassTag = arg0_1.tf:Find("mask/tag/pass_tag")
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
	local var2_3 = false

	setActive(arg0_3.mask, not var0_3 or var1_3)
	setActive(arg0_3.selloutTag, false)

	if arg0_3.limitPassTag then
		setActive(arg0_3.limitPassTag, false)
	end

	setActive(arg0_3.unexchangeTag, false)
	removeOnButton(arg0_3.mask)

	if var1_3 then
		local var3_3, var4_3, var5_3 = arg0_3.goodsVO:CheckArgLimit()

		if var4_3 == "pass" then
			setActive(arg0_3.limitPassTag, true)
			setScrollText(findTF(arg0_3.limitPassTag, "TextGo/Text"), i18n("eventshop_unlock_info", var5_3))
			onButton(arg0_3, arg0_3.mask, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("eventshop_unlock_hint", var5_3))
			end, SFX_PANEL)
		else
			setScrollText(arg0_3.unexchangeTag:Find("TextGo/Text"), var5_3)

			var2_3 = true
		end
	end

	if not var0_3 then
		setActive(arg0_3.selloutTag, true)
	elseif var2_3 then
		setActive(arg0_3.unexchangeTag, true)
	end

	local var6_3 = Drop.New({
		type = arg1_3:getConfig("commodity_type"),
		id = arg1_3:getConfig("commodity_id"),
		count = arg1_3:getConfig("num")
	})

	updateDrop(arg0_3.itemTF, var6_3)

	if var0_3 then
		local var7_3, var8_3, var9_3 = arg0_3.goodsVO:CheckTimeLimit()

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
	setText(arg0_3.countTF, arg1_3:getConfig("resource_num"))

	local var10_3 = var6_3:getName() or "??"

	setScrollText(arg0_3.nameTxt, var10_3)

	local var11_3 = arg1_3:getConfig("num_limit")

	if var11_3 == 0 then
		setText(arg0_3.limitCountLabelTF, i18n("common_no_limit"))
	else
		local var12_3 = arg1_3:GetPurchasableCnt()

		setText(arg0_3.limitCountLabelTF, i18n("activity_shop_exchange_count") .. math.max(var12_3, 0) .. "/" .. var11_3)
	end

	setActive(arg0_3.limitCountLabelTF, true)
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
	setActive(arg0_7.selloutTag, false)

	if arg0_7.limitPassTag then
		setActive(arg0_7.limitPassTag, false)
	end

	removeOnButton(arg0_7.mask)
	GetSpriteFromAtlasAsync(Drop.New({
		type = arg1_7:getConfig("resource_category"),
		id = arg1_7:getConfig("resource_type")
	}):getIcon(), "", function(arg0_8)
		arg0_7.resIconTF.sprite = arg0_8
	end)
	setText(arg0_7.countTF, arg1_7:getConfig("resource_num"))

	local var1_7 = var0_7:getName() or "??"

	setScrollText(arg0_7.nameTxt, var1_7)

	local var2_7 = arg1_7:getConfig("num_limit")

	if var2_7 == 0 then
		setText(arg0_7.limitCountLabelTF, i18n("common_no_limit"))
	else
		local var3_7 = arg1_7:GetPurchasableCnt()

		setText(arg0_7.limitCountLabelTF, i18n("activity_shop_exchange_count") .. math.max(var3_7, 0) .. "/" .. var2_7)
	end
end

function var0_0.setAsLastSibling(arg0_9)
	arg0_9.tf:SetAsLastSibling()
end

function var0_0.StaticUpdate(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = tf(arg0_10)
	local var1_10 = findTF(var0_10, "itemBg/item")
	local var2_10 = findTF(var0_10, "name_mask/name")
	local var3_10 = findTF(var0_10, "consume/contain/icon"):GetComponent(typeof(Image))
	local var4_10 = var0_10:Find("mask")
	local var5_10 = var0_10:Find("mask/tag/sellout_tag")
	local var6_10 = findTF(var0_10, "consume/contain/Text"):GetComponent(typeof(Text))
	local var7_10 = findTF(var0_10, "discount")

	setActive(var7_10, false)

	local var8_10 = findTF(var0_10, "count_contain/label"):GetComponent(typeof(Text))
	local var9_10, var10_10 = arg1_10:canPurchase()

	setActive(var4_10, not var9_10)
	setActive(var5_10, not var9_10)

	local var11_10 = Drop.New({
		type = arg1_10:getConfig("commodity_type"),
		id = arg1_10:getConfig("commodity_id"),
		count = arg1_10:getConfig("num")
	})

	updateDrop(var1_10, var11_10)

	local var12_10 = var11_10:getConfig("name") or "??"

	var6_10.text = arg1_10:getConfig("resource_num")

	setScrollText(var2_10, var12_10)

	local var13_10 = Drop.New({
		type = arg1_10:getConfig("resource_category"),
		id = arg1_10:getConfig("resource_type")
	}):getIcon()

	GetImageSpriteFromAtlasAsync(var13_10, "", var3_10)

	if arg1_10:getConfig("num_limit") == 0 then
		setText(var8_10, i18n("common_no_limit"))
	else
		local var14_10 = arg1_10:getConfig("num_limit")

		if var11_10.type == DROP_TYPE_SKIN and not var9_10 then
			setText(var8_10, i18n("activity_shop_exchange_count") .. "0/" .. var14_10)
		else
			setText(var8_10, i18n("activity_shop_exchange_count") .. var14_10 - arg1_10.buyCount .. "/" .. var14_10)
		end
	end

	if arg1_10:getConfig("num_limit") >= 99 then
		setText(var8_10, i18n("shop_label_unlimt_cnt"))
	end
end

function var0_0.OnDispose(arg0_11)
	arg0_11.goodsVO = nil
end

return var0_0
