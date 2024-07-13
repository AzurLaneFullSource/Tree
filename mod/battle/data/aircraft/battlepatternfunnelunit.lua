ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleTargetChoise
local var3_0 = var0_0.Battle.BattleDataFunction
local var4_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattlePatternFunnelUnit = class("BattlePatternFunnelUnit", var0_0.Battle.BattleAircraftUnit)
var0_0.Battle.BattlePatternFunnelUnit.__name = "BattlePatternFunnelUnit"

local var5_0 = var0_0.Battle.BattlePatternFunnelUnit

var5_0.STOP_STATE = "STOP_STATE"
var5_0.MOVE_STATE = "MOVE_STATE"
var5_0.CRASH_STATE = "CRASH_STATE"

function var5_0.Ctor(arg0_1, arg1_1)
	var5_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._untDir = var0_0.Battle.BattleConst.UnitDir.LEFT
	arg0_1._type = var0_0.Battle.BattleConst.UnitType.FUNNEL_UNIT
	arg0_1._move = var0_0.Battle.MoveComponent.New()
end

function var5_0.Update(arg0_2, arg1_2)
	arg0_2:updatePatrol(arg1_2)
	arg0_2:UpdateWeapon()
	arg0_2:updatePosition()
end

function var5_0.OnMotherDead(arg0_3)
	arg0_3:onDead()
end

function var5_0.updateExist(arg0_4)
	if not arg0_4._existStartTime then
		return
	end

	if arg0_4._existStartTime + arg0_4._existDuration < pg.TimeMgr.GetInstance():GetCombatTime() then
		arg0_4:changePartolState(var5_0.CRASH_STATE)
	end
end

function var5_0.UpdateWeapon(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5:GetWeapon()) do
		iter1_5:Update()
	end
end

function var5_0.SetMotherUnit(arg0_6, arg1_6)
	var5_0.super.SetMotherUnit(arg0_6, arg1_6)

	local var0_6 = arg0_6:GetIFF() * -1

	arg0_6._upperBound, arg0_6._lowerBound, arg0_6._leftBound, arg0_6._rightBound = var0_0.Battle.BattleDataProxy.GetInstance():GetFleetBoundByIFF(var0_6)
end

function var5_0.SetTemplate(arg0_7, arg1_7)
	var5_0.super.SetTemplate(arg0_7, arg1_7)

	arg0_7._existDuration = arg1_7.funnel_behavior.exist
end

function var5_0.changePartolState(arg0_8, arg1_8)
	if arg1_8 == var5_0.MOVE_STATE then
		arg0_8:changeToMoveState()
	end

	arg0_8._portalState = arg1_8
end

function var5_0.AddCreateTimer(arg0_9, arg1_9, arg2_9)
	arg0_9._currentState = arg0_9.STATE_CREATE
	arg0_9._speedDir = arg1_9
	arg0_9._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(30)

	local function var0_9()
		arg0_9._existStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_9._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(arg0_9._tmpData.speed)

		arg0_9:changePartolState(var5_0.MOVE_STATE)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_9._createTimer)

		arg0_9._createTimer = nil
	end

	arg0_9.updatePatrol = arg0_9._updateCreate
	arg0_9._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, 0.5, var0_9)
end

function var5_0.updatePosition(arg0_11)
	arg0_11._pos = arg0_11._pos + arg0_11._speed
end

function var5_0._updateCreate(arg0_12)
	arg0_12:UpdateSpeed()
	arg0_12:updatePosition()
end

function var5_0.changeToMoveState(arg0_13)
	arg0_13._currentState = var5_0.MOVE_STATE

	local var0_13 = var3_0.GetAITmpDataFromID(arg0_13._tmpData.funnel_behavior.AI)
	local var1_13 = var0_0.Battle.AutoPilot.New(arg0_13, var0_13)

	arg0_13._move:ImmuneMaxAreaLimit(true)
	arg0_13._move:CancelFormationCtrl()

	arg0_13._autoPilotAI = var1_13

	arg0_13._autoPilotAI:SetHiveUnit(arg0_13._motherUnit)

	arg0_13.updatePatrol = arg0_13._updateMove
end

function var5_0._updateMove(arg0_14, arg1_14)
	arg0_14._move:Update()
	arg0_14._speed:Copy(arg0_14._move:GetSpeed())
	arg0_14._speed:Mul(arg0_14._velocity * arg0_14:GetSpeedRatio())
	arg0_14:updatePosition()
end
