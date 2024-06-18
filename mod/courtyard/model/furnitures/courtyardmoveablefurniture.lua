local var0_0 = class("CourtYardMoveableFurniture", import(".CourtYardFurniture"))
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.moveState = var1_0
	arg0_1.playPreheatAction = false
end

function var0_0.IsCar(arg0_2)
	if arg0_2.config.spine then
		local var0_2 = arg0_2.config.spine[1]

		return var0_2 and var0_2[4] ~= nil
	end

	return false
end

function var0_0.GetAroundPositions(arg0_3)
	local var0_3 = var0_0.super.GetAroundPositions(arg0_3)

	if not arg0_3:IsCar() then
		return var0_3
	end

	local var1_3 = arg0_3.config.spine[1][4]

	if type(var1_3) == "table" then
		local var2_3 = {}

		for iter0_3, iter1_3 in ipairs(var0_3) do
			if table.contains(var1_3, iter0_3) then
				table.insert(var2_3, iter1_3)
			end
		end

		return var2_3
	else
		return var0_3
	end
end

function var0_0.ChangeState(arg0_4, arg1_4)
	var0_0.super.ChangeState(arg0_4, arg1_4)

	if arg0_4:IsTouchState() then
		arg0_4:ChangeMoveState(var2_0)
	elseif arg0_4:IsMoving() then
		arg0_4:Idle()
	end
end

function var0_0.IsMoveableSlot(arg0_5, arg1_5)
	return arg1_5.id == 1
end

function var0_0.IsReadyMove(arg0_6)
	return arg0_6.moveState == var2_0
end

function var0_0.IsMoving(arg0_7)
	return arg0_7.moveState == var3_0
end

function var0_0.IsStop(arg0_8)
	return arg0_8.moveState == var4_0
end

function var0_0.SetPosition(arg0_9, arg1_9)
	if arg0_9.moveState == var3_0 then
		var0_0.super.super.SetPosition(arg0_9, arg1_9)
	else
		var0_0.super.SetPosition(arg0_9, arg1_9)
	end
end

function var0_0.GetSpeed(arg0_10)
	local var0_10 = 1

	if arg0_10.config.spine and arg0_10.config.spine[7] then
		var0_10 = arg0_10.config.spine[7]
	end

	return var0_10
end

function var0_0.GetMoveTime(arg0_11)
	return 1 / arg0_11:GetSpeed()
end

function var0_0.Move(arg0_12, arg1_12)
	arg0_12:RemoveTimer()
	arg0_12:ChangeMoveState(var3_0)

	local var0_12 = arg0_12:GetMoveTime()

	arg0_12.moveTimer = Timer.New(function()
		arg0_12:ChangeMoveState(var2_0)
	end, var0_12, 1)

	arg0_12.moveTimer:Start()
	arg0_12:DispatchEvent(CourtYardEvent.FURNITURE_MOVE, arg1_12)
end

function var0_0.Rest(arg0_14)
	arg0_14:RemoveTimer()
	arg0_14:ChangeMoveState(var1_0)

	local var0_14 = math.random(1)

	arg0_14.moveTimer = Timer.New(function()
		arg0_14:ChangeMoveState(var2_0)
	end, math.random(10, 20), 1)

	arg0_14.moveTimer:Start()
end

function var0_0.Idle(arg0_16)
	arg0_16:RemoveTimer()
	arg0_16:ChangeMoveState(var1_0)
	arg0_16:SetPosition(arg0_16:GetPosition())
	arg0_16:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0_0.Stop(arg0_17)
	arg0_17:RemoveTimer()
	arg0_17:ChangeMoveState(var4_0)
	arg0_17:SetPosition(arg0_17:GetPosition())
	arg0_17:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0_0.ReStart(arg0_18)
	arg0_18:ChangeMoveState(var2_0)
end

function var0_0.ChangeMoveState(arg0_19, arg1_19)
	arg0_19.moveState = arg1_19
end

function var0_0.IsSpineSlotAndExistPreheatAction(arg0_20, arg1_20)
	if not isa(arg1_20, CourtYardFurnitureSpineSlot) then
		return false
	end

	return arg1_20.preheatAction ~= nil
end

function var0_0.StartInteraction(arg0_21, arg1_21)
	if arg0_21:IsSpineSlotAndExistPreheatAction(arg1_21) then
		arg0_21.playPreheatAction = true

		arg0_21:_ChangeState(CourtYardFurniture.STATE_INTERACT)
		arg0_21:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, arg1_21)
		arg0_21:Idle()
	else
		var0_0.super.StartInteraction(arg0_21, arg1_21)

		if arg0_21:IsMoveableSlot(arg1_21) then
			arg0_21:ChangeMoveState(var2_0)
		end
	end
end

function var0_0.OnPreheatActionEnd(arg0_22, arg1_22)
	if arg0_22:IsSpineSlotAndExistPreheatAction(arg1_22) then
		arg0_22.playPreheatAction = false

		arg0_22:ChangeMoveState(var2_0)
	end
end

function var0_0.CanInterAction(arg0_23)
	if arg0_23.playPreheatAction then
		return false
	end

	return var0_0.super.CanInterAction(arg0_23)
end

function var0_0.ClearInteraction(arg0_24, arg1_24)
	if arg0_24:IsSpineSlotAndExistPreheatAction(arg1_24) then
		if #_.select(arg0_24.slots, function(arg0_25)
			return arg0_25.id ~= arg1_24.id and arg0_25:IsUsing()
		end) == 0 then
			arg0_24:_ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_24:Idle()
		end

		arg0_24:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg1_24)
	else
		var0_0.super.ClearInteraction(arg0_24, arg1_24)

		if arg0_24:IsMoveableSlot(arg1_24) then
			arg0_24:Idle()
		end
	end
end

function var0_0.RemoveTimer(arg0_26)
	if arg0_26.moveTimer then
		arg0_26.moveTimer:Stop()

		arg0_26.moveTimer = nil
	end
end

function var0_0.IsDifferentDirectionForCard(arg0_27, arg1_27)
	local var0_27 = arg0_27:GetPosition()
	local var1_27 = arg0_27.config.dir == 1 and {
		1,
		2
	} or {
		2,
		1
	}
	local var2_27

	if arg1_27.x > var0_27.x then
		var2_27 = var1_27[1]
	elseif arg1_27.y > var0_27.y then
		var2_27 = var1_27[2]
	else
		var2_27 = (arg1_27.x < var0_27.x and arg1_27.y == var0_27.y or arg1_27.y > var0_27.y and arg1_27.x == var0_27.x) and var1_27[1] or var1_27[2]
	end

	return arg0_27.dir ~= var2_27
end

function var0_0.IsDifferentDirection(arg0_28, arg1_28)
	if arg0_28:IsCar() then
		return arg0_28:IsDifferentDirectionForCard(arg1_28)
	else
		return var0_0.super.IsDifferentDirection(arg0_28, arg1_28)
	end
end

function var0_0.Dispose(arg0_29)
	var0_0.super.Dispose(arg0_29)
	arg0_29:RemoveTimer()

	arg0_29.playPreheatAction = false
end

return var0_0
