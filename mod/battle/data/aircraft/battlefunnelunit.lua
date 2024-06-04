ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleTargetChoise
local var3 = var0.Battle.BattleUnitEvent

var0.Battle.BattleFunnelUnit = class("BattleFunnelUnit", var0.Battle.BattleAircraftUnit)
var0.Battle.BattleFunnelUnit.__name = "BattleFunnelUnit"

local var4 = var0.Battle.BattleFunnelUnit

var4.STOP_STATE = "STOP_STATE"
var4.MOVE_STATE = "MOVE_STATE"
var4.CRASH_STATE = "CRASH_STATE"

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)

	arg0._dir = var0.Battle.BattleConst.UnitDir.LEFT
	arg0._type = var0.Battle.BattleConst.UnitType.FUNNEL_UNIT
end

function var4.Update(arg0, arg1)
	arg0:updateExist()
	arg0:updatePatrol(arg1)
end

function var4.updateExist(arg0)
	if not arg0._existStartTime then
		return
	end

	if arg0._existStartTime + arg0._existDuration < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0:changePartolState(var4.CRASH_STATE)
	end
end

function var4.UpdateWeapon(arg0)
	for iter0, iter1 in ipairs(arg0:GetWeapon()) do
		iter1:Update()
	end
end

function var4.SetMotherUnit(arg0, arg1)
	var4.super.SetMotherUnit(arg0, arg1)

	local var0 = arg0:GetIFF() * -1

	arg0._upperBound, arg0._lowerBound, arg0._leftBound, arg0._rightBound = var0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var0)
end

function var4.SetTemplate(arg0, arg1)
	var4.super.SetTemplate(arg0, arg1)

	arg0._existDuration = arg1.funnel_behavior.exist
	arg0._stayDuration = arg1.funnel_behavior.stay
	arg0._frontOffset = arg1.funnel_behavior.front or 0
	arg0._rearOffset = arg1.funnel_behavior.rear or 0

	if arg0:GetWeapon()[1] then
		arg0.changeToStopState = var4.stopState
	else
		arg0.changeToStopState = var4.nonWeaponStopState
	end

	if arg0:GetIFF() == var1.FRIENDLY_CODE then
		arg0._leftBound = arg0._leftBound + arg0._rearOffset
		arg0._rightBound = arg0._rightBound + arg0._frontOffset
	else
		arg0._leftBound = arg0._leftBound - arg0._frontOffset
		arg0._rightBound = arg0._rightBound - arg0._rearOffset
	end
end

function var4.changePartolState(arg0, arg1)
	if arg1 == var4.MOVE_STATE then
		arg0:changeToMoveState()
	elseif arg1 == var4.STOP_STATE then
		arg0:changeToStopState()
	elseif arg1 == var4.CRASH_STATE then
		arg0:changeToCrashState()
	end

	arg0._portalState = arg1
end

function var4.AddCreateTimer(arg0, arg1, arg2)
	arg0._currentState = arg0.STATE_CREATE
	arg0._speedDir = arg1
	arg0._velocity = var0.Battle.BattleFormulas.ConvertAircraftSpeed(20)
	arg2 = arg2 or 1.5

	local var0 = function()
		arg0._existStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0._velocity = var0.Battle.BattleFormulas.ConvertAircraftSpeed(arg0._tmpData.speed)

		arg0:changePartolState(var4.MOVE_STATE)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._createTimer)

		arg0._createTimer = nil
	end

	arg0.updatePatrol = arg0._updateCreate
	arg0._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2, var0)
end

function var4.updatePosition(arg0)
	arg0._pos = arg0._pos + arg0._speed
end

function var4._updateCreate(arg0)
	arg0:UpdateSpeed()
	arg0:updatePosition()
end

function var4.nonWeaponStopState(arg0)
	arg0._stopStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0.updatePatrol = arg0._updateStop
end

function var4.stopState(arg0)
	arg0._stopStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local var0 = var2.TargetHarmNearest(arg0)[1]
	local var1 = arg0:GetWeapon()[1]

	var1:updateMovementInfo()

	if var0 == nil then
		arg0:changePartolState(var4.CRASH_STATE)
	elseif var1:IsOutOfFireArea(var0) then
		arg0:changePartolState(var4.MOVE_STATE)
	else
		arg0.updatePatrol = arg0._updateStop
	end
end

function var4._updateStop(arg0, arg1)
	if arg0:getStopDuration() < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0:changePartolState(var4.MOVE_STATE)
	else
		arg0:UpdateWeapon()
	end
end

function var4.getStopDuration(arg0)
	return arg0._stopStartTime + arg0._stayDuration
end

function var4.changeToMoveState(arg0)
	arg0:generateMoveTargetPoint()

	arg0.updatePatrol = arg0._updateMove
end

function var4._updateMove(arg0, arg1)
	arg0._speed = arg0._direction * arg0:GetSpeedRatio()

	arg0:updatePosition()

	if Vector3.Distance(arg0:GetPosition(), arg0._moveTargetPosition) < 1 then
		arg0:changePartolState(var4.STOP_STATE)
	end
end

function var4.generateMoveTargetPoint(arg0)
	local var0 = math.random(arg0._leftBound, arg0._rightBound)
	local var1 = math.random(arg0._upperBound, arg0._lowerBound)

	arg0._moveTargetPosition = Vector3(var0, arg0:GetPosition().y, var1)

	local var2 = (arg0._moveTargetPosition - arg0._pos).normalized

	var2.y = 0

	var2:Mul(arg0._velocity)

	arg0._direction = var2
end

function var4.changeToCrashState(arg0)
	arg0._existStartTime = nil

	if arg0:GetIFF() == var1.FOE_CODE then
		arg0._speedDir = Vector3.left
	elseif arg0:GetIFF() == var1.FRIENDLY_CODE then
		arg0._speedDir = Vector3.right
	end

	arg0.updatePatrol = arg0._updateCrash
end

function var4._updateCrash(arg0)
	arg0:UpdateSpeed()
	arg0:updatePosition()
end
