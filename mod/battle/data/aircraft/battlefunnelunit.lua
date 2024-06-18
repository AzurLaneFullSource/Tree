ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleTargetChoise
local var3_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleFunnelUnit = class("BattleFunnelUnit", var0_0.Battle.BattleAircraftUnit)
var0_0.Battle.BattleFunnelUnit.__name = "BattleFunnelUnit"

local var4_0 = var0_0.Battle.BattleFunnelUnit

var4_0.STOP_STATE = "STOP_STATE"
var4_0.MOVE_STATE = "MOVE_STATE"
var4_0.CRASH_STATE = "CRASH_STATE"

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._dir = var0_0.Battle.BattleConst.UnitDir.LEFT
	arg0_1._type = var0_0.Battle.BattleConst.UnitType.FUNNEL_UNIT
end

function var4_0.Update(arg0_2, arg1_2)
	arg0_2:updateExist()
	arg0_2:updatePatrol(arg1_2)
end

function var4_0.updateExist(arg0_3)
	if not arg0_3._existStartTime then
		return
	end

	if arg0_3._existStartTime + arg0_3._existDuration < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0_3:changePartolState(var4_0.CRASH_STATE)
	end
end

function var4_0.UpdateWeapon(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4:GetWeapon()) do
		iter1_4:Update()
	end
end

function var4_0.SetMotherUnit(arg0_5, arg1_5)
	var4_0.super.SetMotherUnit(arg0_5, arg1_5)

	local var0_5 = arg0_5:GetIFF() * -1

	arg0_5._upperBound, arg0_5._lowerBound, arg0_5._leftBound, arg0_5._rightBound = var0_0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var0_5)
end

function var4_0.SetTemplate(arg0_6, arg1_6)
	var4_0.super.SetTemplate(arg0_6, arg1_6)

	arg0_6._existDuration = arg1_6.funnel_behavior.exist
	arg0_6._stayDuration = arg1_6.funnel_behavior.stay
	arg0_6._frontOffset = arg1_6.funnel_behavior.front or 0
	arg0_6._rearOffset = arg1_6.funnel_behavior.rear or 0

	if arg0_6:GetWeapon()[1] then
		arg0_6.changeToStopState = var4_0.stopState
	else
		arg0_6.changeToStopState = var4_0.nonWeaponStopState
	end

	if arg0_6:GetIFF() == var1_0.FRIENDLY_CODE then
		arg0_6._leftBound = arg0_6._leftBound + arg0_6._rearOffset
		arg0_6._rightBound = arg0_6._rightBound + arg0_6._frontOffset
	else
		arg0_6._leftBound = arg0_6._leftBound - arg0_6._frontOffset
		arg0_6._rightBound = arg0_6._rightBound - arg0_6._rearOffset
	end
end

function var4_0.changePartolState(arg0_7, arg1_7)
	if arg1_7 == var4_0.MOVE_STATE then
		arg0_7:changeToMoveState()
	elseif arg1_7 == var4_0.STOP_STATE then
		arg0_7:changeToStopState()
	elseif arg1_7 == var4_0.CRASH_STATE then
		arg0_7:changeToCrashState()
	end

	arg0_7._portalState = arg1_7
end

function var4_0.AddCreateTimer(arg0_8, arg1_8, arg2_8)
	arg0_8._currentState = arg0_8.STATE_CREATE
	arg0_8._speedDir = arg1_8
	arg0_8._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(20)
	arg2_8 = arg2_8 or 1.5

	local function var0_8()
		arg0_8._existStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_8._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(arg0_8._tmpData.speed)

		arg0_8:changePartolState(var4_0.MOVE_STATE)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_8._createTimer)

		arg0_8._createTimer = nil
	end

	arg0_8.updatePatrol = arg0_8._updateCreate
	arg0_8._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2_8, var0_8)
end

function var4_0.updatePosition(arg0_10)
	arg0_10._pos = arg0_10._pos + arg0_10._speed
end

function var4_0._updateCreate(arg0_11)
	arg0_11:UpdateSpeed()
	arg0_11:updatePosition()
end

function var4_0.nonWeaponStopState(arg0_12)
	arg0_12._stopStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_12.updatePatrol = arg0_12._updateStop
end

function var4_0.stopState(arg0_13)
	arg0_13._stopStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	local var0_13 = var2_0.TargetHarmNearest(arg0_13)[1]
	local var1_13 = arg0_13:GetWeapon()[1]

	var1_13:updateMovementInfo()

	if var0_13 == nil then
		arg0_13:changePartolState(var4_0.CRASH_STATE)
	elseif var1_13:IsOutOfFireArea(var0_13) then
		arg0_13:changePartolState(var4_0.MOVE_STATE)
	else
		arg0_13.updatePatrol = arg0_13._updateStop
	end
end

function var4_0._updateStop(arg0_14, arg1_14)
	if arg0_14:getStopDuration() < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0_14:changePartolState(var4_0.MOVE_STATE)
	else
		arg0_14:UpdateWeapon()
	end
end

function var4_0.getStopDuration(arg0_15)
	return arg0_15._stopStartTime + arg0_15._stayDuration
end

function var4_0.changeToMoveState(arg0_16)
	arg0_16:generateMoveTargetPoint()

	arg0_16.updatePatrol = arg0_16._updateMove
end

function var4_0._updateMove(arg0_17, arg1_17)
	arg0_17._speed = arg0_17._direction * arg0_17:GetSpeedRatio()

	arg0_17:updatePosition()

	if Vector3.Distance(arg0_17:GetPosition(), arg0_17._moveTargetPosition) < 1 then
		arg0_17:changePartolState(var4_0.STOP_STATE)
	end
end

function var4_0.generateMoveTargetPoint(arg0_18)
	local var0_18 = math.random(arg0_18._leftBound, arg0_18._rightBound)
	local var1_18 = math.random(arg0_18._upperBound, arg0_18._lowerBound)

	arg0_18._moveTargetPosition = Vector3(var0_18, arg0_18:GetPosition().y, var1_18)

	local var2_18 = (arg0_18._moveTargetPosition - arg0_18._pos).normalized

	var2_18.y = 0

	var2_18:Mul(arg0_18._velocity)

	arg0_18._direction = var2_18
end

function var4_0.changeToCrashState(arg0_19)
	arg0_19._existStartTime = nil

	if arg0_19:GetIFF() == var1_0.FOE_CODE then
		arg0_19._speedDir = Vector3.left
	elseif arg0_19:GetIFF() == var1_0.FRIENDLY_CODE then
		arg0_19._speedDir = Vector3.right
	end

	arg0_19.updatePatrol = arg0_19._updateCrash
end

function var4_0._updateCrash(arg0_20)
	arg0_20:UpdateSpeed()
	arg0_20:updatePosition()
end
