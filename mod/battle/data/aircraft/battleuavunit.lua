ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleTargetChoise
local var3_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattelUAVUnit = class("BattelUAVUnit", var0_0.Battle.BattleAircraftUnit)
var0_0.Battle.BattelUAVUnit.__name = "BattelUAVUnit"

local var4_0 = var0_0.Battle.BattelUAVUnit

var4_0.MOVE_STATE = "MOVE_STATE"
var4_0.HOVER_STATE = "HOVER_STATE"

function var4_0.Ctor(arg0_1, arg1_1)
	var4_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._dir = var0_0.Battle.BattleConst.UnitDir.LEFT
	arg0_1._type = var0_0.Battle.BattleConst.UnitType.UAV_UNIT
end

function var4_0.Update(arg0_2, arg1_2)
	arg0_2:updatePatrol(arg1_2)
end

function var4_0.SetTemplate(arg0_3, arg1_3)
	var4_0.super.SetTemplate(arg0_3, arg1_3)

	local var0_3 = arg1_3.funnel_behavior.offsetX * arg0_3:GetIFF()
	local var1_3 = arg1_3.funnel_behavior.offsetZ
	local var2_3 = var0_0.Battle.BattleDataProxy.GetInstance():GetVanguardBornCoordinate(arg0_3:GetIFF())

	arg0_3._centerPos = BuildVector3(var2_3) + Vector3(var0_3, 0, var1_3)
	arg0_3._range = arg1_3.funnel_behavior.hover_range
end

function var4_0.changePartolState(arg0_4, arg1_4)
	if arg1_4 == var4_0.MOVE_STATE then
		arg0_4:changeToMoveState()
	elseif arg1_4 == var4_0.HOVER_STATE then
		arg0_4:changeToHoverState()
	end

	arg0_4._portalState = arg1_4
end

function var4_0.AddCreateTimer(arg0_5, arg1_5, arg2_5)
	arg0_5._currentState = arg0_5.STATE_CREATE
	arg0_5._speedDir = arg1_5
	arg0_5._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(20)
	arg2_5 = arg2_5 or 1.5

	local function var0_5()
		arg0_5._existStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
		arg0_5._velocity = var0_0.Battle.BattleFormulas.ConvertAircraftSpeed(arg0_5._tmpData.speed)

		arg0_5:changePartolState(var4_0.MOVE_STATE)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_5._createTimer)

		arg0_5._createTimer = nil
	end

	arg0_5.updatePatrol = arg0_5._updateCreate
	arg0_5._createTimer = pg.TimeMgr.GetInstance():AddBattleTimer("AddCreateTimer", 0, arg2_5, var0_5)
end

function var4_0._updateCreate(arg0_7)
	arg0_7:UpdateSpeed()

	arg0_7._pos = arg0_7._pos + arg0_7._speed
end

function var4_0.changeToMoveState(arg0_8)
	arg0_8._cruiseLimit = arg0_8._centerPos.x
	arg0_8.updatePatrol = arg0_8._updateMove
end

function var4_0._updateMove(arg0_9, arg1_9)
	arg0_9:UpdateSpeed()

	arg0_9._pos = arg0_9._pos + arg0_9._speed

	if arg0_9._IFF == var1_0.FRIENDLY_CODE then
		if arg0_9._pos.x > arg0_9._cruiseLimit then
			arg0_9:changePartolState(var4_0.HOVER_STATE)
		end
	elseif arg0_9._IFF == var1_0.FOE_CODE and arg0_9._pos.x < arg0_9._cruiseLimit then
		arg0_9:changePartolState(var4_0.HOVER_STATE)
	end
end

function var4_0.changeToHoverState(arg0_10)
	arg0_10._hoverStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0_10.updatePatrol = arg0_10._updateHover
end

function var4_0._updateHover(arg0_11, arg1_11)
	local var0_11 = arg1_11 - arg0_11._hoverStartTime

	arg0_11._pos = Vector3(math.sin(var0_11) * arg0_11._range, 15, math.cos(var0_11) * arg0_11._range):Add(arg0_11._centerPos)
end

function var4_0.GetSize(arg0_12)
	if arg0_12._portalState == var4_0.HOVER_STATE then
		local var0_12 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0_12._hoverStartTime
		local var1_12 = math.cos(var0_12)

		if var1_12 > 0 and var1_12 < 0.2 then
			var1_12 = 0.2
		elseif var1_12 <= 0 and var1_12 > -0.2 then
			var1_12 = -0.2
		end

		return var1_12
	else
		var4_0.super.GetSize(arg0_12)
	end
end
