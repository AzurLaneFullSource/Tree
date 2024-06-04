local var0 = class("CourtYardMoveableFurniture", import(".CourtYardFurniture"))
local var1 = 0
local var2 = 1
local var3 = 2
local var4 = 3

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.moveState = var1
end

function var0.IsCar(arg0)
	if arg0.config.spine then
		local var0 = arg0.config.spine[1]

		return var0 and var0[4] ~= nil
	end

	return false
end

function var0.GetAroundPositions(arg0)
	local var0 = var0.super.GetAroundPositions(arg0)

	if not arg0:IsCar() then
		return var0
	end

	local var1 = arg0.config.spine[1][4]

	if type(var1) == "table" then
		local var2 = {}

		for iter0, iter1 in ipairs(var0) do
			if table.contains(var1, iter0) then
				table.insert(var2, iter1)
			end
		end

		return var2
	else
		return var0
	end
end

function var0.ChangeState(arg0, arg1)
	var0.super.ChangeState(arg0, arg1)

	if arg0:IsTouchState() then
		arg0:ChangeMoveState(var2)
	elseif arg0:IsMoving() then
		arg0:Idle()
	end
end

function var0.IsMoveableSlot(arg0, arg1)
	return arg1.id == 1
end

function var0.IsReadyMove(arg0)
	return arg0.moveState == var2
end

function var0.IsMoving(arg0)
	return arg0.moveState == var3
end

function var0.IsStop(arg0)
	return arg0.moveState == var4
end

function var0.SetPosition(arg0, arg1)
	if arg0.moveState == var3 then
		var0.super.super.SetPosition(arg0, arg1)
	else
		var0.super.SetPosition(arg0, arg1)
	end
end

function var0.GetSpeed(arg0)
	local var0 = 1

	if arg0.config.spine and arg0.config.spine[7] then
		var0 = arg0.config.spine[7]
	end

	return var0
end

function var0.GetMoveTime(arg0)
	return 1 / arg0:GetSpeed()
end

function var0.Move(arg0, arg1)
	arg0:RemoveTimer()
	arg0:ChangeMoveState(var3)

	local var0 = arg0:GetMoveTime()

	arg0.moveTimer = Timer.New(function()
		arg0:ChangeMoveState(var2)
	end, var0, 1)

	arg0.moveTimer:Start()
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_MOVE, arg1)
end

function var0.Rest(arg0)
	arg0:RemoveTimer()
	arg0:ChangeMoveState(var1)

	local var0 = math.random(1)

	arg0.moveTimer = Timer.New(function()
		arg0:ChangeMoveState(var2)
	end, math.random(10, 20), 1)

	arg0.moveTimer:Start()
end

function var0.Idle(arg0)
	arg0:RemoveTimer()
	arg0:ChangeMoveState(var1)
	arg0:SetPosition(arg0:GetPosition())
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0.Stop(arg0)
	arg0:RemoveTimer()
	arg0:ChangeMoveState(var4)
	arg0:SetPosition(arg0:GetPosition())
	arg0:DispatchEvent(CourtYardEvent.FURNITURE_STOP_MOVE)
end

function var0.ReStart(arg0)
	arg0:ChangeMoveState(var2)
end

function var0.ChangeMoveState(arg0, arg1)
	arg0.moveState = arg1
end

function var0.StartInteraction(arg0, arg1)
	var0.super.StartInteraction(arg0, arg1)

	if arg0:IsMoveableSlot(arg1) then
		arg0:ChangeMoveState(var2)
	end
end

function var0.ClearInteraction(arg0, arg1)
	var0.super.ClearInteraction(arg0, arg1)

	if arg0:IsMoveableSlot(arg1) then
		arg0:Idle()
	end
end

function var0.RemoveTimer(arg0)
	if arg0.moveTimer then
		arg0.moveTimer:Stop()

		arg0.moveTimer = nil
	end
end

function var0.IsDifferentDirectionForCard(arg0, arg1)
	local var0 = arg0:GetPosition()
	local var1 = arg0.config.dir == 1 and {
		1,
		2
	} or {
		2,
		1
	}
	local var2

	if arg1.x > var0.x then
		var2 = var1[1]
	elseif arg1.y > var0.y then
		var2 = var1[2]
	else
		var2 = (arg1.x < var0.x and arg1.y == var0.y or arg1.y > var0.y and arg1.x == var0.x) and var1[1] or var1[2]
	end

	return arg0.dir ~= var2
end

function var0.IsDifferentDirection(arg0, arg1)
	if arg0:IsCar() then
		return arg0:IsDifferentDirectionForCard(arg1)
	else
		return var0.super.IsDifferentDirection(arg0, arg1)
	end
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:RemoveTimer()
end

return var0
