local var0 = class("SelectableSkin")

function var0.Ctor(arg0, arg1)
	arg0.skinId = arg1.id
	arg0.isTimeLimit = arg1.isTimeLimit
	arg0.own = getProxy(ShipSkinProxy):hasSkin(arg0.skinId)
end

function var0.IsTimeLimit(arg0)
	return arg0.isTimeLimit
end

function var0.OwnSkin(arg0)
	return arg0.own
end

function var0.ToShipSkin(arg0)
	return ShipSkin.New({
		id = arg0.skinId
	})
end

function var0.GetTimeLimitWeight(arg0)
	return arg0:IsTimeLimit() and 1 or 0
end

function var0.GetOwnWeight(arg0)
	return arg0:OwnSkin() and 0 or 1
end

return var0
