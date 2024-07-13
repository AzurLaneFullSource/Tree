local var0_0 = class("SelectableSkin")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.skinId = arg1_1.id
	arg0_1.isTimeLimit = arg1_1.isTimeLimit
	arg0_1.own = getProxy(ShipSkinProxy):hasSkin(arg0_1.skinId)
end

function var0_0.IsTimeLimit(arg0_2)
	return arg0_2.isTimeLimit
end

function var0_0.OwnSkin(arg0_3)
	return arg0_3.own
end

function var0_0.ToShipSkin(arg0_4)
	return ShipSkin.New({
		id = arg0_4.skinId
	})
end

function var0_0.GetTimeLimitWeight(arg0_5)
	return arg0_5:IsTimeLimit() and 1 or 0
end

function var0_0.GetOwnWeight(arg0_6)
	return arg0_6:OwnSkin() and 0 or 1
end

return var0_0
