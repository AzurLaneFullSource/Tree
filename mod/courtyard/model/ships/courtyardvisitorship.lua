local var0 = class("CourtYardVisitorShip", import(".CourtYardShip"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.name = arg2.name
	arg0.inimacy = 0
	arg0.coin = 0
end

function var0.GetName(arg0)
	return arg0.name
end

function var0.GetShipType(arg0)
	return CourtYardConst.SHIP_TYPE_OTHER
end

return var0
