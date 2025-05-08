local var0_0 = class("IslandInviteShipCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.selectedTF = arg0_1._tf:Find("frame/sel")
	arg0_1.selectedDotTF = arg0_1._tf:Find("frame/sel_dot")
	arg0_1.frameTF = arg0_1._tf:Find("frame")
	arg0_1.iconTF = arg0_1.frameTF:Find("main/icon")
	arg0_1.textTF = arg0_1.frameTF:Find("main/Text")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.configId = arg1_2

	setText(arg0_2.textTF, pg.island_ship[arg1_2].name)
	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	local var0_3 = arg1_3 == arg0_3.configId

	SetCompomentEnabled(arg0_3.frameTF, "EventTriggerListener", var0_3)
	setActive(arg0_3.selectedTF, var0_3)
	setActive(arg0_3.selectedDotTF, var0_3)

	local var1_3 = var0_3 and 1 or 0.8

	setLocalScale(arg0_3.frameTF, {
		x = var1_3,
		y = var1_3,
		z = var1_3
	})
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
