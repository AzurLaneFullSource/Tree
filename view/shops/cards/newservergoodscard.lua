local var0_0 = class("NewServerGoodsCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._tr = arg1_1.transform
	arg0_1.itemTF = arg0_1._tr:Find("item")
	arg0_1.itemIconBgTF = arg0_1.itemTF:Find("icon_bg")
	arg0_1.itemIconFrameTF = arg0_1.itemTF:Find("icon_bg/frame")
	arg0_1.itemIconTF = arg0_1.itemTF:Find("icon_bg/icon")
	arg0_1.itemCountTF = arg0_1.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0_1.discountTF = arg0_1._tr:Find("item/discount")
	arg0_1.nameTF = arg0_1._tr:Find("item/name_mask/name"):GetComponent(typeof(Text))
	arg0_1.consumeIconTF = arg0_1._tr:Find("item/consume/contain/icon")
	arg0_1.consumeTxtTF = arg0_1._tr:Find("item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0_1.sellOutMaskTF = arg0_1._tr:Find("selloutmask")
	arg0_1.levelMaskTF = arg0_1._tr:Find("levelmask")
	arg0_1.cntTxt = arg0_1._tr:Find("item/count_contain/count"):GetComponent(typeof(Text))

	setActive(arg0_1.discountTF, false)
	setText(arg0_1.sellOutMaskTF:Find("ch"), i18n("word_sell_out"))
	setText(arg0_1.levelMaskTF:Find("ch"), i18n("word_sell_lock"))
	setText(arg0_1._tr:Find("item/count_contain/label"), i18n("activity_shop_exchange_count"))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.shop = arg2_2

	if arg1_2 ~= arg0_2.commodity then
		arg0_2.commodity = arg1_2

		arg0_2:Init()
		arg0_2:Flush()
	else
		arg0_2.commodity = arg1_2

		arg0_2:Flush()
	end
end

function var0_0.Flush(arg0_3)
	arg0_3.cntTxt.text = arg0_3.commodity:GetCanPurchaseCnt() .. "/" .. arg0_3.commodity:GetCanPurchaseMaxCnt()

	setActive(arg0_3.sellOutMaskTF, not arg0_3.commodity:CanPurchase())
	setActive(arg0_3.levelMaskTF, not arg0_3.commodity:IsOpening(arg0_3.shop:GetStartTime()))
end

function var0_0.Init(arg0_4)
	local var0_4 = arg0_4.commodity:GetDesc()
	local var1_4 = var0_4.name

	if string.match(var1_4, "(%d+)") then
		setText(arg0_4.nameTF, shortenString(var1_4, 5))
	else
		setText(arg0_4.nameTF, shortenString(var1_4, 6))
	end

	local var2_4 = arg0_4.commodity:GetConsume()

	arg0_4.consumeTxtTF.text = var2_4.count

	GetImageSpriteFromAtlasAsync(var2_4:getConfig("icon"), "", arg0_4.consumeIconTF)

	arg0_4.itemCountTF.text = arg0_4.commodity:GetDropCnt()

	GetImageSpriteFromAtlasAsync(var0_4.icon, "", arg0_4.itemIconTF)

	local var3_4 = var0_4.rarity or ItemRarity.Gray

	setImageSprite(arg0_4.itemIconBgTF, GetSpriteFromAtlas("weaponframes", "bg" .. ItemRarity.Rarity2Print(var3_4)))
	setImageColor(arg0_4.itemIconFrameTF, Color.NewHex(ItemRarity.Rarity2FrameHexColor(var3_4)))
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
