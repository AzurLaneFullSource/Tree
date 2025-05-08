local var0_0 = class("IslandFirmOrder", import(".IslandOrder"))

function var0_0.IsFirm(arg0_1)
	return true
end

function var0_0.IsEmpty(arg0_2)
	return arg0_2.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW
end

return var0_0
