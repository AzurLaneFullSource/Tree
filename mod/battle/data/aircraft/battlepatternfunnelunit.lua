ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleTargetChoise
local var3 = var0.Battle.BattleDataFunction
local var4 = var0.Battle.BattleUnitEvent

var0.Battle.BattlePatternFunnelUnit = class("BattlePatternFunnelUnit", var0.Battle.BattleAircraftUnit)
var0.Battle.BattlePatternFunnelUnit.__name = "BattlePatternFunnelUnit"

local var5 = var0.Battle.BattlePatternFunnelUnit

var5.STOP_STATE = "STOP_STATE"
var5.MOVE_STATE = "MOVE_STATE"
var5.CRASH_STATE = "CRASH_STATE"

function var5.Ctor(arg0, arg1)
	var5.super.Ctor(arg0, arg1)

	arg0._untDir = var0.Battle.BattleConst.UnitDir.LEFT
	arg0._type = var0.Battle.BattleConst.UnitType.FUNNEL_UNIT
	arg0._move = var0.Battle.MoveComponent.New()
end

function var5.Update(arg0, arg1)
	arg0:updatePatrol(arg1)
	arg0:UpdateWeapon()
	arg0:updatePosition()
end

function var5.OnMotherDead(arg0)
	arg0:onDead()
end

function var5.updateExist(arg0)
	if not arg0._existStartTime then
		return
	end

	if arg0._existStartTime + arg0._existDuration < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0:changePartolState(var5.CRASH_STATE)
	end
end

function var5.UpdateWeapon(arg0)
	for iter0, iter1 in ipairs(arg0:GetWeapon()) do
		iter1:Update()
	end
end

function var5.SetMotherUnit(arg0, arg1)
	var5.super.SetMotherUnit(arg0, arg1)

	local var0 = arg0:GetIFF() * -1

	arg0._upperBound, arg0._lowerBound, arg0._leftBound, arg0._rightBound = var0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var0)
end

function var5.SetTemplate(arg0, arg1)
	var5.super.SetTemplate(arg0, arg1)

	arg0._existDuration = arg1.funnel_behavior.exist
end

function var5.changePartolState(arg0, arg1)
	if arg1 == var5.MOVE_STATE then
		arg0:changeToMoveState()
	end

	arg0._portalState = arg1
end

function var5.AddCreateTimer(arg0, arg1, arg2)
	arg0._currentState = arg0.STATE_CREATE
	arg0._speedDir = arg1
	arg0._velocity = var0.Battle.BattleFormulas.ConvertAircraftSpeed(30)

	local var0 = function()
		arg0._existStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0._velocity = var0.Battle.BattleFormulas.ConvertAircraftSpeed(arg0._tmpData.speed)

		arg0:changePartolState(var5.MOVE_STATE)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._createTimer)

		arg0._createTimer = nil
	end

	arg0.updatePatrol = arg0._updateCreate
	arg0._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, 0.5, var0)
end

function var5.updatePosition(arg0)
	arg0._pos = arg0._pos + arg0._speed
end

function var5._updateCreate(arg0)
	arg0:UpdateSpeed()
	arg0:updatePosition()
end

function var5.changeToMoveState(arg0)
	arg0._currentState = var5.MOVE_STATE

	local var0 = var3.GetAITmpDataFromID(arg0._tmpData.funnel_behavior.AI)
	local var1 = var0.Battle.AutoPilot.New(arg0, var0)

	arg0._move:ImmuneMaxAreaLimit(true)
	arg0._move:CancelFormationCtrl()

	arg0._autoPilotAI = var1

	arg0._autoPilotAI:SetHiveUnit(arg0._motherUnit)

	arg0.updatePatrol = arg0._updateMove
end

function var5._updateMove(arg0, arg1)
	arg0._move:Update()
	arg0._speed:Copy(arg0._move:GetSpeed())
	arg0._speed:Mul(arg0._velocity * arg0:GetSpeedRatio())
	arg0:updatePosition()
end
