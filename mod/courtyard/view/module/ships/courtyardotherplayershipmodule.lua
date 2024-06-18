local var0_0 = class("CourtYardOtherPlayerShipModule", import(".CourtYardShipModule"))

function var0_0.Emit(arg0_1, arg1_1, ...)
	if arg1_1 == "TouchShip" or arg1_1 == "ShipAnimtionFinish" then
		var0_0.super.Emit(arg0_1, arg1_1, ...)
	end
end

function var0_0.OnBeginDrag(arg0_2)
	return
end

function var0_0.OnDragging(arg0_3, arg1_3)
	return
end

function var0_0.OnDragEnd(arg0_4, arg1_4)
	return
end

return var0_0
