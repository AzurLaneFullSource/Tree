local var0_0 = class("MedalGoodsCard", import(".BaseGoodsCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.groupMark = arg0_1.tf:Find("group_locked")
	arg0_1.limitCountLabelTF = findTF(arg0_1.tf, "count_contain/label"):GetComponent(typeof(Text))
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.goods ~= arg1_2 then
		arg0_2.goods = arg1_2

		arg0_2:Init()
	else
		arg0_2.goods = arg1_2
	end

	arg0_2.limitCountLabelTF.text = i18n("activity_shop_exchange_count") .. arg0_2.goods.count .. "/" .. arg0_2.goods:GetLimit()

	local var0_2 = arg0_2.goods:CanPurchase()

	setActive(arg0_2.mask, not var0_2)
	setActive(arg0_2.selloutTag, not var0_2)
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.goods:getConfig("goods_name")
	local var1_3 = arg0_3.goods:GetDropInfo()

	updateDrop(arg0_3.itemTF, var1_3)
	setScrollText(arg0_3.nameTxt, var0_3)
	setText(arg0_3.countTF, arg0_3.goods:getConfig("price"))
	GetImageSpriteFromAtlasAsync("props/medal", "", arg0_3.resIconTF)
	GetImageSpriteFromAtlasAsync(arg0_3.goods:getConfig("goods_icon"), "", arg0_3.itemIconTF)

	local var2_3 = arg0_3.goods:getConfig("is_ship")
	local var3_3 = arg0_3.goods:getConfig("goods")

	if arg0_3.groupMark and var2_3 == 1 and #var3_3 == 1 then
		local var4_3 = var3_3[1]
		local var5_3 = pg.ship_data_template[var4_3].group_type

		if var5_3 and var5_3 > 0 then
			setActive(arg0_3.groupMark, not getProxy(CollectionProxy):getShipGroup(var5_3))
		else
			setActive(arg0_3.groupMark, false)
		end
	else
		setActive(arg0_3.groupMark, false)
	end
end

function var0_0.OnDispose(arg0_4)
	arg0_4.goods = nil
end

return var0_0
