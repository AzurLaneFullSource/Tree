local var0_0 = class("IslandExchangeItemCard", import(".IslandItemCard"))

function var0_0.Update(arg0_1, arg1_1, arg2_1)
	arg0_1.item = arg1_1
	arg0_1.nameTxt.text = arg0_1:ShortenString(arg1_1:GetName(), 6)

	updateCustomDrop(arg0_1._tf, Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg1_1.id,
		count = arg1_1:GetCount()
	}))
	arg0_1:UpdateValue(arg2_1)
end

return var0_0
