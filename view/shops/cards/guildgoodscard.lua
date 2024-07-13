local var0_0 = class("GuildGoodsCard", import(".BaseGoodsCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._go = arg1_1
	arg0_1._tr = tf(arg1_1)
	arg0_1.itemTF = arg0_1._tr:Find("item")
	arg0_1.itemIconBgTF = arg0_1.itemTF:Find("icon_bg")
	arg0_1.itemIconFrameTF = arg0_1.itemTF:Find("icon_bg/frame")
	arg0_1.itemIconTF = arg0_1.itemTF:Find("icon_bg/icon")
	arg0_1.itemCountTF = arg0_1.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0_1.discountTF = arg0_1._tr:Find("item/discount")
	arg0_1.nameTF = arg0_1._tr:Find("item/name_mask/name"):GetComponent(typeof(Text))
	arg0_1.consumeIconTF = arg0_1._tr:Find("item/consume/contain/icon")
	arg0_1.consumeTxtTF = arg0_1._tr:Find("item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0_1.maskTF = arg0_1._tr:Find("mask")
	arg0_1.selloutTag = arg0_1._tr:Find("mask/tag/sellout_tag")
	arg0_1.cntTxt = arg0_1._tr:Find("item/count_contain/count"):GetComponent(typeof(Text))
	arg0_1.limitCountLabelTF = findTF(arg0_1.tf, "item/count_contain/label"):GetComponent(typeof(Text))
	arg0_1.limitCountLabelTF.text = i18n("activity_shop_exchange_count")

	setActive(arg0_1.discountTF, false)
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.goods ~= arg1_2 then
		arg0_2.goods = arg1_2

		arg0_2:Init()
	else
		arg0_2.goods = arg1_2
	end

	arg0_2.cntTxt.text = arg0_2.goods.count .. "/" .. arg0_2.goods:GetLimit()

	local var0_2 = arg0_2.goods:CanPurchase()

	setActive(arg0_2.maskTF, not var0_2)
	setActive(arg0_2.selloutTag, not var0_2)
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.goods:getConfig("goods_name")

	if string.match(var0_3, "(%d+)") then
		setText(arg0_3.nameTF, shortenString(var0_3, 5))
	else
		setText(arg0_3.nameTF, shortenString(var0_3, 6))
	end

	arg0_3.consumeTxtTF.text = arg0_3.goods:getConfig("price")

	GetImageSpriteFromAtlasAsync("ui/share/msgbox_atlas", "res_guildicon", arg0_3.consumeIconTF)
	GetImageSpriteFromAtlasAsync(arg0_3.goods:getConfig("goods_icon"), "", arg0_3.itemIconTF)

	arg0_3.itemCountTF.text = arg0_3.goods:getConfig("num")

	local var1_3 = arg0_3.goods:getConfig("goods_rarity") or ItemRarity.Gray

	setImageSprite(arg0_3.itemIconBgTF, GetSpriteFromAtlas("weaponframes", "bg" .. ItemRarity.Rarity2Print(var1_3)))
	setImageColor(arg0_3.itemIconFrameTF, Color.NewHex(ItemRarity.Rarity2FrameHexColor(var1_3)))
end

function var0_0.OnDispose(arg0_4)
	arg0_4.goods = nil
end

return var0_0
