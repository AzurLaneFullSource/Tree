local var0_0 = class("IslandFirmOrder", import(".IslandOrder"))

function var0_0.IsFirm(arg0_1)
	return true
end

function var0_0.CanReplace(arg0_2)
	return false
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_order
end

function var0_0.IsEmpty(arg0_4)
	return arg0_4.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW
end

function var0_0.GetAwardItemAndExp(arg0_5)
	local var0_5 = arg0_5:getConfig("award")

	return arg0_5:GenAwards(var0_5)
end

return var0_0
