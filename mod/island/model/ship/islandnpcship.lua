local var0_0 = class("IslandNpcShip", import(".IslandShip"))

function var0_0.GetState(arg0_1)
	return var0_0.STATE_NORMAL
end

function var0_0.GetEnergy(arg0_2)
	return arg0_2.maxEnerey
end

function var0_0.GetCurrentEnergy(arg0_3)
	return arg0_3.maxEnerey
end

return var0_0
