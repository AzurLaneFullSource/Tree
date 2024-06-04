local var0 = class("CourtYardOtherPlayerShipModule", import(".CourtYardShipModule"))

function var0.Emit(arg0, arg1, ...)
	if arg1 == "TouchShip" or arg1 == "ShipAnimtionFinish" then
		var0.super.Emit(arg0, arg1, ...)
	end
end

function var0.OnBeginDrag(arg0)
	return
end

function var0.OnDragging(arg0, arg1)
	return
end

function var0.OnDragEnd(arg0, arg1)
	return
end

return var0
