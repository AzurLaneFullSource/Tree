local var0_0 = class("IslandCardSetLabelCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.nameTF = arg0_1._tf:Find("name")
	arg0_1.valueTF = arg0_1._tf:Find("value")
	arg0_1.selectedTF = arg0_1._tf:Find("sel")
	arg0_1.unSelectedTF = arg0_1._tf:Find("unsel")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.id = arg1_2
	arg0_2.value = arg2_2

	local var0_2 = pg.island_card_label[arg0_2.id].name

	setText(arg0_2.nameTF, var0_2)
	setText(arg0_2.valueTF, arg2_2)
	arg0_2:UpdateSelected(arg3_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	local var0_3 = arg1_3 and arg1_3 == arg0_3.id

	setActive(arg0_3.selectedTF, var0_3)
	setActive(arg0_3.unSelectedTF, not var0_3)
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
