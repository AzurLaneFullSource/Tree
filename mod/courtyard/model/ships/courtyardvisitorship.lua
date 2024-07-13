local var0_0 = class("CourtYardVisitorShip", import(".CourtYardShip"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.name = arg2_1.name
	arg0_1.inimacy = 0
	arg0_1.coin = 0
end

function var0_0.GetName(arg0_2)
	return arg0_2.name
end

function var0_0.GetShipType(arg0_3)
	return CourtYardConst.SHIP_TYPE_OTHER
end

return var0_0
