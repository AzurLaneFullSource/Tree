local var0_0 = class("ChargeGoodsCard", import("...shops.cards.GoodsCard"))

function var0_0.update(arg0_1, arg1_1)
	arg0_1.goodsVO = arg1_1

	local var0_1 = arg0_1.goodsVO:canPurchase()

	setActive(arg0_1.mask, not var0_1)
	setActive(arg0_1.stars, false)

	local var1_1 = arg1_1:getDropInfo()

	updateDrop(arg0_1.itemTF, var1_1)

	local var2_1 = var1_1:getConfig("name") or ""

	setScrollText(arg0_1.nameTxt, var2_1)

	local var3_1 = arg1_1:GetPrice()
	local var4_1 = arg1_1:getConfig("discount")

	setActive(arg0_1.discountTF, arg1_1:isDisCount())
	setText(arg0_1.discountTextTF, var4_1 .. "%OFF")
	setText(arg0_1.countTF, math.ceil(var3_1))
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = arg1_1:getConfig("resource_type")
	}):getIcon(), "", tf(arg0_1.resIconTF), false)
end

return var0_0
