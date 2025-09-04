local var0_0 = class("IslandFirmUrgencyOrder", import(".IslandUrgencyOrder"))

function var0_0.IsFirm(arg0_1)
	return true
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_order
end

function var0_0.GetDisappearTime(arg0_3)
	return arg0_3.startTime + arg0_3:getConfig("effective_time")
end

function var0_0.GetAwardItemAndExp(arg0_4)
	local var0_4 = arg0_4:getConfig("award")

	return arg0_4:GenAwards(var0_4)
end

return var0_0
