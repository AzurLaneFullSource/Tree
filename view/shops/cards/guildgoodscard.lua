local var0_0 = class("GuildGoodsCard", import(".BaseGoodsCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	setActive(arg0_1.limitCountLabelTF, true)
end

function var0_0.update(arg0_2, arg1_2)
	if arg0_2.goodsVO ~= arg1_2 then
		arg0_2.goodsVO = arg1_2

		arg0_2:Init()
	else
		arg0_2.goodsVO = arg1_2
	end

	setText(arg0_2.limitCountLabelTF, i18n("activity_shop_exchange_count") .. arg0_2.goodsVO.count .. "/" .. arg0_2.goodsVO:GetLimit())
	setActive(arg0_2.limitCountLabelTF, true)

	local var0_2 = arg0_2.goodsVO:CanPurchase()

	setActive(arg0_2.mask, not var0_2)
	setActive(arg0_2.selloutTag, not var0_2)
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.goodsVO:getConfig("goods_name")
	local var1_3 = arg0_3.goodsVO:GetDropInfo()

	updateDrop(arg0_3.itemTF, var1_3)
	setScrollText(arg0_3.nameTxt, var0_3)
	setText(arg0_3.countTF, arg0_3.goodsVO:getConfig("price"))
	GetImageSpriteFromAtlasAsync("ui/share/msgbox_atlas", "res_guildicon", arg0_3.resIconTF)
	GetImageSpriteFromAtlasAsync(arg0_3.goodsVO:getConfig("goods_icon"), "", arg0_3.itemIconTF)
	setText(arg0_3.itemCountTF, arg0_3.goodsVO:getConfig("num"))

	local var2_3 = arg0_3.goodsVO:getConfig("goods_rarity") or ItemRarity.Gray

	setImageSprite(arg0_3.itemIconBgTF, GetSpriteFromAtlas("weaponframes", "bg" .. ItemRarity.Rarity2Print(var2_3)))
	setImageColor(arg0_3.itemIconFrameTF, Color.NewHex(ItemRarity.Rarity2FrameHexColor(var2_3)))
end

function var0_0.OnDispose(arg0_4)
	arg0_4.goodsVO = nil
end

return var0_0
