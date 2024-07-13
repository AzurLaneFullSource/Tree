local var0_0 = class("ShipViewShareData")

function var0_0.Ctor(arg0_1)
	arg0_1.shipVO = nil
end

function var0_0.SetShipVO(arg0_2, arg1_2)
	arg0_2.shipVO = arg1_2
end

function var0_0.SetPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3
end

function var0_0.HasFashion(arg0_4)
	return getProxy(ShipSkinProxy):HasFashion(arg0_4.shipVO)
end

function var0_0.GetCurGroupSkinList(arg0_5)
	return arg0_5:GetGroupSkinList(arg0_5.shipVO.groupId)
end

function var0_0.GetGroupSkinList(arg0_6, arg1_6)
	return getProxy(ShipSkinProxy):GetAllSkinForShip(arg0_6.shipVO)
end

return var0_0
