local var0_0 = class("CourtYardReversePacmanShip", import(".CourtYardShip"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)

	arg0_1.roleID = arg2_1.roleID
end

function var0_0.GetShipType(arg0_2)
	return CourtYardConst.SHIP_TYPE_REVERSE_PACMAN
end

function var0_0.ShowChatBubble(arg0_3)
	arg0_3:DispatchEvent(CourtYardEvent.REVERSE_PACMAN_CHAT_BUBBLE, roleID)
end

return var0_0
