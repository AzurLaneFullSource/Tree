local var0 = class("ActivityGoodsCard", import(".BaseGoodsCard"))

var0.Color = {}
var0.DefaultColor = {
	0.874509803921569,
	0.929411764705882,
	1
}

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.go = arg1
	arg0.tr = tf(arg1)
	arg0.itemTF = findTF(arg0.tr, "item")
	arg0.nameTxt = findTF(arg0.tr, "item/name_mask/name")
	arg0.resIconTF = findTF(arg0.tr, "item/consume/contain/icon"):GetComponent(typeof(Image))
	arg0.mask = arg0.tr:Find("mask")
	arg0.selloutTag = arg0.tr:Find("mask/tag/sellout_tag")
	arg0.sellEndTag = arg0.tr:Find("mask/tag/sellend_tag")

	setActive(arg0.sellEndTag, false)

	arg0.unexchangeTag = arg0.tr:Find("mask/tag/unexchange_tag")
	arg0.countTF = findTF(arg0.tr, "item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0.discountTF = findTF(arg0.tr, "item/discount")

	setActive(arg0.discountTF, false)

	arg0.limitTimeSellTF = findTF(arg0.tr, "item/limit_time_sell")

	setActive(arg0.limitTimeSellTF, false)

	arg0.limitCountTF = findTF(arg0.tr, "item/count_contain/count"):GetComponent(typeof(Text))
	arg0.limitCountLabelTF = findTF(arg0.tr, "item/count_contain/label"):GetComponent(typeof(Text))
	arg0.limitCountLabelTF.text = i18n("activity_shop_exchange_count")
	arg0.tagImg = arg0.tr:Find("mask/tag"):GetComponent(typeof(Image))
	arg0.limitPassTag = arg0.tr:Find("mask/tag/pass_tag")
end

function var0.update(arg0, arg1, arg2, arg3, arg4)
	arg0.goodsVO = arg1

	local var0 = arg0.goodsVO:CheckCntLimit()
	local var1 = var0 and not arg0.goodsVO:CheckArgLimit()

	setActive(arg0.mask, not var0 or var1)
	setActive(arg0.selloutTag, not var0)

	if arg0.limitPassTag then
		setActive(arg0.limitPassTag, false)
	end

	removeOnButton(arg0.mask)

	if var1 then
		local var2, var3, var4 = arg0.goodsVO:CheckArgLimit()

		if var3 == "pass" then
			setActive(arg0.limitPassTag, true)
			setText(findTF(arg0.limitPassTag, "Text"), i18n("eventshop_unlock_info", var4))
			onButton(arg0, arg0.mask, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("eventshop_unlock_hint", var4))
			end, SFX_PANEL)
		elseif var3 == 1 or var3 == 2 then
			setText(arg0.unexchangeTag, var4)

			local var5 = ""

			if var3 == 1 then
				var5 = "LIMIT"
			end

			if var3 == 2 then
				var5 = "LOCK"
			end

			setText(arg0.unexchangeTag:Find("sellout_tag_en"), var5)
			setActive(arg0.unexchangeTag, true)
		end
	end

	local var6 = Drop.New({
		type = arg1:getConfig("commodity_type"),
		id = arg1:getConfig("commodity_id"),
		count = arg1:getConfig("num")
	})

	updateDrop(arg0.itemTF, var6)
	setActive(arg0.limitTimeSellTF, false)

	if var0 then
		local var7, var8, var9 = arg0.goodsVO:CheckTimeLimit()

		setActive(arg0.limitTimeSellTF, var7 and var8)

		if var7 and not var8 then
			setActive(arg0.mask, true)
			setActive(arg0.sellEndTag, true)
			removeOnButton(arg0.mask)
			onButton(arg0, arg0.mask, function()
				if var9 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var6:getName()))
				end
			end, SFX_PANEL)
		end
	end

	GetSpriteFromAtlasAsync(Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getIcon(), "", function(arg0)
		arg0.resIconTF.sprite = arg0
	end)

	arg0.countTF.text = arg1:getConfig("resource_num")

	local var10 = var6:getName() or "??"

	if string.match(var10, "(%d+)") then
		setText(arg0.nameTxt, shortenString(var10, 5))
	else
		setText(arg0.nameTxt, shortenString(var10, 6))
	end

	local var11 = arg1:getConfig("num_limit")

	if var11 == 0 then
		arg0.limitCountTF.text = i18n("common_no_limit")
	else
		local var12 = arg1:GetPurchasableCnt()

		arg0.limitCountTF.text = math.max(var12, 0) .. "/" .. var11
	end

	local var13 = var0.Color[arg2] or var0.DefaultColor

	arg0.limitCountTF.color = arg3 or Color.New(unpack(var13))
	arg0.limitCountLabelTF.color = arg3 or Color.New(unpack(var13))
	arg4 = arg4 or Color.New(0, 0, 0, 1)

	if GetComponent(arg0.limitCountTF, typeof(Outline)) then
		setOutlineColor(arg0.limitCountTF, arg4)
	end

	if GetComponent(arg0.limitCountLabelTF, typeof(Outline)) then
		setOutlineColor(arg0.limitCountLabelTF, arg4)
	end
end

function var0.setAsLastSibling(arg0)
	arg0.tr:SetAsLastSibling()
end

function var0.StaticUpdate(arg0, arg1, arg2, arg3)
	local var0 = tf(arg0)
	local var1 = findTF(var0, "item")
	local var2 = findTF(var0, "item/name_mask/name")
	local var3 = findTF(var0, "item/consume/contain/icon"):GetComponent(typeof(Image))
	local var4 = var0:Find("mask")
	local var5 = var0:Find("mask/tag/sellout_tag")
	local var6 = findTF(var0, "item/consume/contain/Text"):GetComponent(typeof(Text))
	local var7 = findTF(var0, "item/discount")

	setActive(var7, false)

	local var8 = findTF(var0, "item/count_contain/count"):GetComponent(typeof(Text))
	local var9 = findTF(var0, "item/count_contain/label"):GetComponent(typeof(Text))
	local var10, var11 = arg1:canPurchase()

	setActive(var4, not var10)
	setActive(var5, not var10)

	local var12 = Drop.New({
		type = arg1:getConfig("commodity_type"),
		id = arg1:getConfig("commodity_id"),
		count = arg1:getConfig("num")
	})

	updateDrop(var1, var12)

	local var13 = var12:getConfig("name") or "??"

	var6.text = arg1:getConfig("resource_num")

	if string.match(var13, "(%d+)") then
		setText(var2, shortenString(var13, 5))
	else
		setText(var2, shortenString(var13, 6))
	end

	var3.sprite = GetSpriteFromAtlas(Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getIcon(), "")

	if arg1:getConfig("num_limit") == 0 then
		var8.text = i18n("common_no_limit")
	else
		local var14 = arg1:getConfig("num_limit")

		if var12.type == DROP_TYPE_SKIN and not var10 then
			var8.text = "0/" .. var14
		else
			var8.text = var14 - arg1.buyCount .. "/" .. var14
		end
	end

	local var15 = var0.Color[arg2] or var0.DefaultColor

	var8.color = arg3 or Color.New(var15[1], var15[2], var15[3], 1)
	var9.color = arg3 or Color.New(var15[1], var15[2], var15[3], 1)

	if arg1:getConfig("num_limit") >= 99 then
		var9.text = i18n("shop_label_unlimt_cnt")
		var8.text = ""
	end
end

function var0.OnDispose(arg0)
	arg0.goodsVO = nil
end

return var0
