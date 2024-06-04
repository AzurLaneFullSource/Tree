local var0 = class("CourtYardFeastController", import(".CourtYardController"))

function var0.ShipBubbleInterActionFinish(arg0, arg1)
	local var0 = arg0.storey:GetShip(arg1)

	if var0 then
		local var1 = var0:GetIsSpecialValue()

		arg0:SendNotification(CourtYardEvent._FEAST_INTERACTION, {
			groupId = arg1,
			special = var1
		})
	end
end

function var0.UpdateBubble(arg0, arg1, arg2)
	local var0 = arg0.storey:GetShip(arg1)

	assert(var0, arg1)

	if var0 then
		var0:UpdateBubble(arg2)
	end
end

function var0.UpdateChatBubble(arg0, arg1, arg2)
	local var0 = arg0.storey:GetShip(arg1)

	assert(var0, arg1)

	if var0 then
		var0:UpdateChatBubble(arg2)
	end
end

function var0.ExitAllShip(arg0)
	for iter0, iter1 in pairs(arg0.storey.ships) do
		arg0.storey:ExitShip(iter0)
	end
end

function var0.AddShipWithSpecialPosition(arg0, arg1)
	if not arg0.storey then
		return
	end

	local var0 = arg0:DataToShip(arg1)

	var0:SetPosition(Vector2(25, 11))

	local var1 = arg0.storey:GetAroundEmptyPosition(var0)

	if var1 then
		var0:SetPosition(var1)
		arg0.storey:AddShip(var0)
	else
		arg0:SendNotification(CourtYardEvent._NO_POS_TO_ADD_SHIP, var0.id)
	end
end

function var0.ShipEnterFeast(arg0, arg1)
	local var0 = arg0.storey:GetShip(arg1)

	if var0 then
		var0:EnterFeast()
	end
end

return var0
