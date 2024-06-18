local var0_0 = class("CourtYardFeastController", import(".CourtYardController"))

function var0_0.ShipBubbleInterActionFinish(arg0_1, arg1_1)
	local var0_1 = arg0_1.storey:GetShip(arg1_1)

	if var0_1 then
		local var1_1 = var0_1:GetIsSpecialValue()

		arg0_1:SendNotification(CourtYardEvent._FEAST_INTERACTION, {
			groupId = arg1_1,
			special = var1_1
		})
	end
end

function var0_0.UpdateBubble(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.storey:GetShip(arg1_2)

	assert(var0_2, arg1_2)

	if var0_2 then
		var0_2:UpdateBubble(arg2_2)
	end
end

function var0_0.UpdateChatBubble(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg0_3.storey:GetShip(arg1_3)

	assert(var0_3, arg1_3)

	if var0_3 then
		var0_3:UpdateChatBubble(arg2_3)
	end
end

function var0_0.ExitAllShip(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4.storey.ships) do
		arg0_4.storey:ExitShip(iter0_4)
	end
end

function var0_0.AddShipWithSpecialPosition(arg0_5, arg1_5)
	if not arg0_5.storey then
		return
	end

	local var0_5 = arg0_5:DataToShip(arg1_5)

	var0_5:SetPosition(Vector2(25, 11))

	local var1_5 = arg0_5.storey:GetAroundEmptyPosition(var0_5)

	if var1_5 then
		var0_5:SetPosition(var1_5)
		arg0_5.storey:AddShip(var0_5)
	else
		arg0_5:SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, var0_5.id)
	end
end

function var0_0.ShipEnterFeast(arg0_6, arg1_6)
	local var0_6 = arg0_6.storey:GetShip(arg1_6)

	if var0_6 then
		var0_6:EnterFeast()
	end
end

return var0_0
