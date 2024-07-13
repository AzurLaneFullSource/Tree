local var0_0 = class("CourtYardFeastShip", import(".CourtYardShip"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.bubble = arg2_1.bubble or 0
	arg0_1.isSpecial = arg2_1.isSpecial

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_FEAST)

	arg0_1.interActionConfig = {}

	if var0_1 and not var0_1:isEnd() then
		arg0_1.interActionConfig = var0_1:getConfig("config_client")
	end
end

function var0_0.GetShipType(arg0_2)
	return CourtYardConst.SHIP_TYPE_FEAST
end

function var0_0.IsSpecial(arg0_3)
	return arg0_3.isSpecial
end

function var0_0.GetIsSpecialValue(arg0_4)
	return arg0_4.isSpecial and 1 or 0
end

function var0_0.UpdateBubble(arg0_5, arg1_5)
	arg0_5.bubble = arg1_5 or 0

	arg0_5:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_CHANGE, arg1_5)
end

function var0_0.ExistBubble(arg0_6)
	return arg0_6.bubble > 0
end

function var0_0.UpdateChatBubble(arg0_7, arg1_7)
	arg0_7:DispatchEvent(CourtYardEvent.FEAST_SHIP_CHAT_CHANGE, arg1_7)
end

function var0_0.EnterFeast(arg0_8)
	if arg0_8:IsSpecial() then
		arg0_8:DispatchEvent(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, 1)
	end
end

function var0_0.OnInterAction(arg0_9, arg1_9)
	var0_0.super.OnInterAction(arg0_9, arg1_9)

	local var0_9 = arg1_9:GetOwner()

	if isa(var0_9, CourtYardFurniture) and arg0_9:ExistBubble() and arg0_9:IsSameInterAction(var0_9, arg0_9.bubble) then
		arg0_9:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0_9.bubble)

		if not arg0_9:IsSpecial() then
			local var1_9 = arg0_9:GetInterActionExpress(var0_9)

			arg0_9:DispatchEvent(CourtYardEvent.FEAST_SHIP_SHOW_EXPRESS, var1_9)
		end
	end
end

function var0_0.GetInterActionExpress(arg0_10, arg1_10)
	local var0_10 = arg0_10.interActionConfig[7] or {}

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var1_10 = iter1_10[1]
		local var2_10 = iter1_10[2]

		if var1_10 == arg1_10.configId and #var2_10 > 0 then
			return var2_10[math.random(1, #var2_10)]
		end
	end
end

function var0_0.IsSameInterAction(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.interActionConfig[arg2_11] or {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if arg1_11.configId == iter1_11 then
			return true
		end
	end

	return false
end

function var0_0._ChangeState(arg0_12, arg1_12, arg2_12)
	var0_0.super._ChangeState(arg0_12, arg1_12, arg2_12)

	if arg1_12 == CourtYardShip.STATE_TOUCH and arg0_12.bubble == FeastShip.BUBBLE_TYPE_GREET then
		arg0_12:DispatchEvent(CourtYardEvent.FEAST_SHIP_BUBBLE_INTERACTION, arg0_12.bubble)
	end
end

return var0_0
