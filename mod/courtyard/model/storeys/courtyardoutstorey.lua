local var0_0 = class("CourtYardOutStorey", import(".CourtYardStorey"))

function var0_0.CanAddFurniture(arg0_1, arg1_1)
	return arg1_1.config.belong == 1
end

return var0_0
