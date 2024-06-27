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

function var0_0._ChangeState(arg0_4, arg1_4)
	var0_0.super._ChangeState(arg0_4, arg1_4)

	if CourtYardFurniture.STATE_TOUCH == arg0_4.state then
		arg0_4:ChangeMoveState(var2_0)
	end
end

function var0_0.ChangeState(arg0_5, arg1_5)
	var0_0.super.ChangeState(arg0_5, arg1_5)

	if CourtYardFurniture.STATE_TOUCH == arg0_5.state then
		-- block empty
	elseif arg0_5:IsMoving() then
		arg0_5:Idle()
	end
end

function var0_0.IsMoveableSlot(arg0_6, arg1_6)
	return arg1_6.id == 1
end

function var0_0.IsReadyMove(arg0_7)
	return arg0_7.moveState == var2_0
end

function var0_0.IsMoving(arg0_8)
	return arg0_8.moveState == var3_0
end

function var0_0.IsStop(arg0_9)
	return arg0_9.moveState == var4_0
end

function var0_0.SetPosition(arg0_10, arg1_10)
	if arg0_10.moveState == var3_0 then
		var0_0.super.super.SetPosition(arg0_10, arg1_10)
	else
		var0_0.super.SetPosition(arg0_10, arg1_10)
	end
end

function var0_0.GetSpeed(arg0_11)
	local var0_11 = 1

	if arg0_11.config.spine and arg0_11.config.spine[7] then
		var0_11 = arg0_11.config.spine[7]
	end

	return var0_11
end

function var0_0.GetMoveTime(arg0_12)
	return 1 / arg0_12:GetSpeed()
end

function var0_0.Move(arg0_13, arg1_13)
	arg0_13:RemoveTimer()
	arg0_13:ChangeMoveState(var3_0)

	local var0_13 = arg0_13:GetMoveTime()

	arg0_13.moveTimer = Timer.New(function()
		arg0_13:ChangeMoveState(var2_0)
	end, var0_13, 1)

	arg0_13.moveTimer:Start()
	arg0_13:DispatchEvent(CourtYardEvent.FURNITURE_MOVE, arg1_13)
end

function var0_0.Rest(arg0_15)
	arg0_15:RemoveTimer()
	arg0_15:ChangeMoveState(var1_0)

	local var0_15 = math.random(1)

	arg0_15.moveTimer = Timer.New(function()
		arg0_15:ChangeMoveState(var2_0)
	end, math.random(10, 20), 1)

	arg0_15.moveTimer:Start()
end

function var0_0.Idle(arg0_17)
	arg0_17:RemoveTimer()
	arg0_17:ChangeMoveState(var1_0)
	arg0_17:SetPosition(arg0_17:GetPosition())
	arg0_17:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0_0.Stop(arg0_18)
	arg0_18:RemoveTimer()
	arg0_18:ChangeMoveState(var4_0)
	arg0_18:SetPosition(arg0_18:GetPosition())
	arg0_18:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0_0.ReStart(arg0_19)
	arg0_19:ChangeMoveState(var2_0)
end

function var0_0.ChangeMoveState(arg0_20, arg1_20)
	arg0_20.moveState = arg1_20
end

function var0_0.IsSpineSlotAndExistPreheatAction(arg0_21, arg1_21)
	if not isa(arg1_21, CourtYardFurnitureSpineSlot) then
		return false
	end

	return arg1_21.preheatAction ~= nil
end

function var0_0.StartInteraction(arg0_22, arg1_22)
	if arg0_22:IsSpineSlotAndExistPreheatAction(arg1_22) then
		arg0_22.playPreheatAction = true

		arg0_22:_ChangeState(CourtYardFurniture.STATE_INTERACT)
		arg0_22:DispatchEvent(CourtYardEvent.FURNITURE_START_INTERACTION, arg1_22)
		arg0_22:Idle()
	else
		var0_0.super.StartInteraction(arg0_22, arg1_22)

		if arg0_22:IsMoveableSlot(arg1_22) then
			arg0_22:ChangeMoveState(var2_0)
		end
	end
end

function var0_0.OnPreheatActionEnd(arg0_23, arg1_23)
	if arg0_23:IsSpineSlotAndExistPreheatAction(arg1_23) then
		arg0_23.playPreheatAction = false

		arg0_23:ChangeMoveState(var2_0)
	end
end

function var0_0.CanInterAction(arg0_24)
	if arg0_24.playPreheatAction then
		return false
	end

	return var0_0.super.CanInterAction(arg0_24)
end

function var0_0.ClearInteraction(arg0_25, arg1_25)
	if arg0_25:IsSpineSlotAndExistPreheatAction(arg1_25) then
		if #_.select(arg0_25.slots, function(arg0_26)
			return arg0_26.id ~= arg1_25.id and arg0_26:IsUsing()
		end) == 0 then
			arg0_25:_ChangeState(CourtYardFurniture.STATE_IDLE)
			arg0_25:Idle()
		end

		arg0_25:DispatchEvent(CourtYardEvent.FURNITURE_STOP_INTERACTION, arg1_25)
	else
		var0_0.super.ClearInteraction(arg0_25, arg1_25)

		if arg0_25:IsMoveableSlot(arg1_25) then
			arg0_25:Idle()
		end
	end
end

function var0_0.RemoveTimer(arg0_27)
	if arg0_27.moveTimer then
		arg0_27.moveTimer:Stop()

		arg0_27.moveTimer = nil
	end
end

function var0_0.IsDifferentDirectionForCard(arg0_28, arg1_28)
	local var0_28 = arg0_28:GetPosition()
	local var1_28 = arg0_28.config.dir == 1 and {
		1,
		2
	} or {
		2,
		1
	}
	local var2_28

	if arg1_28.x > var0_28.x then
		var2_28 = var1_28[1]
	elseif arg1_28.y > var0_28.y then
		var2_28 = var1_28[2]
	else
		var2_28 = (arg1_28.x < var0_28.x and arg1_28.y == var0_28.y or arg1_28.y > var0_28.y and arg1_28.x == var0_28.x) and var1_28[1] or var1_28[2]
	end

	return arg0_28.dir ~= var2_28
end

function var0_0.IsDifferentDirection(arg0_29, arg1_29)
	if arg0_29:IsCar() then
		return arg0_29:IsDifferentDirectionForCard(arg1_29)
	else
		return var0_0.super.IsDifferentDirection(arg0_29, arg1_29)
	end
end

function var0_0.Dispose(arg0_30)
	var0_0.super.Dispose(arg0_30)
	arg0_30:RemoveTimer()

	arg0_30.playPreheatAction = false
end

return var0_0
