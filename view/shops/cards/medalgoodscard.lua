local var0 = class("MedalGoodsCard", import(".BaseGoodsCard"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0._go = arg1
	arg0._tr = tf(arg1)
	arg0.itemTF = arg0._tr:Find("item")
	arg0.itemIconBgTF = arg0.itemTF:Find("icon_bg")
	arg0.itemIconFrameTF = arg0.itemTF:Find("icon_bg/frame")
	arg0.itemIconTF = arg0.itemTF:Find("icon_bg/icon")
	arg0.itemCountTF = arg0.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0.discountTF = arg0._tr:Find("item/discount")
	arg0.nameTF = arg0._tr:Find("item/name_mask/name"):GetComponent(typeof(Text))
	arg0.consumeIconTF = arg0._tr:Find("item/consume/contain/icon")
	arg0.consumeTxtTF = arg0._tr:Find("item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0.maskTF = arg0._tr:Find("mask")
	arg0.cntTxt = arg0._tr:Find("item/count_contain/count"):GetComponent(typeof(Text))
	arg0.groupMark = arg0._tr:Find("item/group_locked")
	arg0.limitCountLabelTF = findTF(arg0._tr, "item/count_contain/label"):GetComponent(typeof(Text))
	arg0.limitCountLabelTF.text = i18n("activity_shop_exchange_count")

	setActive(arg0.discountTF, false)

	arg0.selloutTag = arg0._tr:Find("mask/tag/sellout_tag")
end

function var0.update(arg0, arg1)
	if arg0.goods ~= arg1 then
		arg0.goods = arg1

		arg0:Init()
	else
		arg0.goods = arg1
	end

	arg0.cntTxt.text = arg0.goods.count .. "/" .. arg0.goods:GetLimit()

	local var0 = arg0.goods:CanPurchase()

	setActive(arg0.maskTF, not var0)
	setActive(arg0.selloutTag, not var0)
end

function var0.Init(arg0)
	local var0 = arg0.goods:getConfig("goods_name")

	if string.match(var0, "(%d+)") then
		setText(arg0.nameTF, shortenString(var0, 5))
	else
		setText(arg0.nameTF, shortenString(var0, 6))
	end

	arg0.consumeTxtTF.text = arg0.goods:getConfig("price")

	GetImageSpriteFromAtlasAsync("props/medal", "", arg0.consumeIconTF)
	GetImageSpriteFromAtlasAsync(arg0.goods:getConfig("goods_icon"), "", arg0.itemIconTF)

	arg0.itemCountTF.text = arg0.goods:getConfig("num")

	local var1 = arg0.goods:getConfig("goods_rarity") or ItemRarity.Gray

	setImageSprite(arg0.itemIconBgTF, GetSpriteFromAtlas("weaponframes", "bg" .. ItemRarity.Rarity2Print(var1)))
	setImageColor(arg0.itemIconFrameTF, Color.NewHex(ItemRarity.Rarity2FrameHexColor(var1)))

	local var2 = arg0.goods:getConfig("is_ship")
	local var3 = arg0.goods:getConfig("goods")

	if arg0.groupMark and var2 == 1 and #var3 == 1 then
		local var4 = var3[1]
		local var5 = pg.ship_data_template[var4].group_type

		if var5 and var5 > 0 then
			setActive(arg0.groupMark, not getProxy(CollectionProxy):getShipGroup(var5))
		else
			setActive(arg0.groupMark, false)
		end
	else
		setActive(arg0.groupMark, false)
	end
end

function var0.OnDispose(arg0)
	arg0.goods = nil
end

return var0
