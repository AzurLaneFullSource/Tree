local var0_0 = class("IslandFoodCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.iconTF = arg0_1._tf:Find("bg/icon")
	arg0_1.barTF = arg0_1._tf:Find("bg/silder/bar")
	arg0_1.countTF = arg0_1._tf:Find("count/Text")
	arg0_1.eventTF = arg0_1._tf:Find("event")
	arg0_1.selectedTF = arg0_1._tf:Find("selected")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.item = arg1_2

	GetImageSpriteFromAtlasAsync("island/" .. arg0_2.item:GetIcon(), "", arg0_2.iconTF)
	arg0_2:UpdateSelectedCnt(arg2_2)
	setActive(arg0_2.eventTF, arg3_2)
	setFillAmount(arg0_2.barTF, arg4_2)
end

function var0_0.UpdateSelectedCnt(arg0_3, arg1_3)
	setText(arg0_3.countTF, arg0_3.item:GetCount() - arg1_3)
	setActive(arg0_3.selectedTF, arg1_3 > 0)
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
