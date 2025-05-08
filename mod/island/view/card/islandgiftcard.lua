local var0_0 = class("IslandGiftCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.itemTr = findTF(arg0_1._tf, "IslandItemTpl")
	arg0_1.nameTxt = findTF(arg0_1._tf, "name/Text"):GetComponent(typeof(Text))
	arg0_1.selected = findTF(arg0_1._tf, "selected")
	arg0_1.heart = findTF(arg0_1._tf, "heart")
	arg0_1.countTxt = findTF(arg0_1._tf, "IslandItemTpl/icon_bg/count"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_2):GetFavoriteGift()

	arg0_2.itemId = arg2_2.id
	arg0_2.item = arg2_2

	local var1_2 = Drop.New({
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg2_2.id,
		count = arg2_2:GetCount()
	})

	updateDrop(arg0_2.itemTr, var1_2)

	arg0_2.countTxt.text = var1_2.count
	arg0_2.nameTxt.text = arg2_2:GetName()

	arg0_2:UpdateSelected(arg3_2)
	setActive(arg0_2.heart, table.contains(var0_2, arg0_2.itemId))
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	setActive(arg0_3.selected, arg1_3 == arg0_3.itemId)
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
