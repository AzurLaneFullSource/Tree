local var0 = class("ChargeGoodsCard", import("...shops.cards.GoodsCard"))

function var0.update(arg0, arg1)
	arg0.goodsVO = arg1

	local var0 = arg0.goodsVO:canPurchase()

	setActive(arg0.mask, not var0)
	setActive(arg0.stars, false)

	local var1 = arg1:getDropInfo()

	updateDrop(arg0.itemTF, var1)

	local var2 = var1:getConfig("name") or ""

	setText(arg0.nameTxt, shortenString(var2, 6))

	local var3 = arg1:GetPrice()

	arg0.discountTextTF = findTF(arg0.discountTF, "Text"):GetComponent(typeof(Text))

	local var4 = arg1:getConfig("discount")

	setActive(arg0.discountTF, arg1:isDisCount())

	arg0.discountTextTF.text = var4 .. "%OFF"
	arg0.countTF.text = math.ceil(var3)

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg1:getConfig("resource_type")
	}):getIcon(), "", tf(arg0.resIconTF))
end

return var0
