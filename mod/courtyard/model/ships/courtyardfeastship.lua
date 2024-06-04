local var0 = class("CourtYardFeastShip", import(".CourtYardShip"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.bubble = arg2.bubble or 0
	arg0.isSpecial = arg2.isSpecial

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0.interActionConfig = {}

	if var0 and not var0:isEnd() then
		arg0.interActionConfig = var0:getConfig("config_client")
	end
end

function var0.GetShipType(arg0)
	return CourtYardConst.SHIP_TYPE_FEAST
end

function var0.IsSpecial(arg0)
	return arg0.isSpecial
end

function var0.GetIsSpecialValue(arg0)
	return arg0.isSpecial and 1 or 0
end

function var0.UpdateBubble(arg0, arg1)
	arg0.bubble = arg1 or 0

	arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg1)
end

function var0.ExistBubble(arg0)
	return arg0.bubble > 0
end

function var0.UpdateChatBubble(arg0, arg1)
	arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg1)
end

function var0.EnterFeast(arg0)
	if arg0:IsSpecial() then
		arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, 1)
	end
end

function var0.OnInterAction(arg0, arg1)
	var0.super.OnInterAction(arg0, arg1)

	local var0 = arg1:GetOwner()

	if isa(var0, CourtYardFurniture) and arg0:ExistBubble() and arg0:IsSameInterAction(var0, arg0.bubble) then
		arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0.bubble)

		if not arg0:IsSpecial() then
			local var1 = arg0:GetInterActionExpress(var0)

			arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, var1)
		end
	end
end

function var0.GetInterActionExpress(arg0, arg1)
	local var0 = arg0.interActionConfig[7] or {}

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1[1]
		local var2 = iter1[2]

		if var1 == arg1.configId and #var2 > 0 then
			return var2[math.random(1, #var2)]
		end
	end
end

function var0.IsSameInterAction(arg0, arg1, arg2)
	local var0 = arg0.interActionConfig[arg2] or {}

	for iter0, iter1 in ipairs(var0) do
		if arg1.configId == iter1 then
			return true
		end
	end

	return false
end

function var0._ChangeState(arg0, arg1, arg2)
	var0.super._ChangeState(arg0, arg1, arg2)

	if arg1 == CourtYardShip.STATE_TOUCH and arg0.bubble == FeastShip.BUBBLE_TYPE_GREET then
		arg0:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0.bubble)
	end
end

return var0
