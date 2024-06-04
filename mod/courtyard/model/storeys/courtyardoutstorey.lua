local var0 = class("CourtYardOutStorey", import(".CourtYardStorey"))

function var0.CanAddFurniture(arg0, arg1)
	return arg1.config.belong == 1
end

return var0
