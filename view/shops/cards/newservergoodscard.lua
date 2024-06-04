local var0 = class("NewServerGoodsCard")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._tr = arg1.transform
	arg0.itemTF = arg0._tr:Find("item")
	arg0.itemIconBgTF = arg0.itemTF:Find("icon_bg")
	arg0.itemIconFrameTF = arg0.itemTF:Find("icon_bg/frame")
	arg0.itemIconTF = arg0.itemTF:Find("icon_bg/icon")
	arg0.itemCountTF = arg0.itemTF:Find("icon_bg/count"):GetComponent(typeof(Text))
	arg0.discountTF = arg0._tr:Find("item/discount")
	arg0.nameTF = arg0._tr:Find("item/name_mask/name"):GetComponent(typeof(Text))
	arg0.consumeIconTF = arg0._tr:Find("item/consume/contain/icon")
	arg0.consumeTxtTF = arg0._tr:Find("item/consume/contain/Text"):GetComponent(typeof(Text))
	arg0.sellOutMaskTF = arg0._tr:Find("selloutmask")
	arg0.levelMaskTF = arg0._tr:Find("levelmask")
	arg0.cntTxt = arg0._tr:Find("item/count_contain/count"):GetComponent(typeof(Text))

	setActive(arg0.discountTF, false)
	setText(arg0.sellOutMaskTF:Find("ch"), i18n("word_sell_out"))
	setText(arg0.levelMaskTF:Find("ch"), i18n("word_sell_lock"))
	setText(arg0._tr:Find("item/count_contain/label"), i18n("activity_shop_exchange_count"))
end

function var0.Update(arg0, arg1, arg2)
	arg0.shop = arg2

	if arg1 ~= arg0.commodity then
		arg0.commodity = arg1

		arg0:Init()
		arg0:Flush()
	else
		arg0.commodity = arg1

		arg0:Flush()
	end
end

function var0.Flush(arg0)
	arg0.cntTxt.text = arg0.commodity:GetCanPurchaseCnt() .. "/" .. arg0.commodity:GetCanPurchaseMaxCnt()

	setActive(arg0.sellOutMaskTF, not arg0.commodity:CanPurchase())
	setActive(arg0.levelMaskTF, not arg0.commodity:IsOpening(arg0.shop:GetStartTime()))
end

function var0.Init(arg0)
	local var0 = arg0.commodity:GetDesc()
	local var1 = var0.name

	if string.match(var1, "(%d+)") then
		setText(arg0.nameTF, shortenString(var1, 5))
	else
		setText(arg0.nameTF, shortenString(var1, 6))
	end

	local var2 = arg0.commodity:GetConsume()

	arg0.consumeTxtTF.text = var2.count

	GetImageSpriteFromAtlasAsync(var2:getConfig("icon"), "", arg0.consumeIconTF)

	arg0.itemCountTF.text = arg0.commodity:GetDropCnt()

	GetImageSpriteFromAtlasAsync(var0.icon, "", arg0.itemIconTF)

	local var3 = var0.rarity or ItemRarity.Gray

	setImageSprite(arg0.itemIconBgTF, GetSpriteFromAtlas("weaponframes", "bg" .. ItemRarity.Rarity2Print(var3)))
	setImageColor(arg0.itemIconFrameTF, Color.NewHex(ItemRarity.Rarity2FrameHexColor(var3)))
end

function var0.Dispose(arg0)
	return
end

return var0
