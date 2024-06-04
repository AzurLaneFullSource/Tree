local var0 = class("ShipViewShareData")

function var0.Ctor(arg0)
	arg0.shipVO = nil
end

function var0.SetShipVO(arg0, arg1)
	arg0.shipVO = arg1
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.HasFashion(arg0)
	return getProxy(ShipSkinProxy):HasFashion(arg0.shipVO)
end

function var0.GetCurGroupSkinList(arg0)
	return arg0:GetGroupSkinList(arg0.shipVO.groupId)
end

function var0.GetGroupSkinList(arg0, arg1)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(arg0.shipVO)
end

return var0
