ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleTargetChoise
local var3 = var0.Battle.BattleUnitEvent

var0.Battle.BattelUAVUnit = class("BattelUAVUnit", var0.Battle.BattleAircraftUnit)
var0.Battle.BattelUAVUnit.__name = "BattelUAVUnit"

local var4 = var0.Battle.BattelUAVUnit

var4.MOVE_STATE = "MOVE_STATE"
var4.HOVER_STATE = "HOVER_STATE"

function var4.Ctor(arg0, arg1)
	var4.super.Ctor(arg0, arg1)

	arg0._dir = var0.Battle.BattleConst.UnitDir.LEFT
	arg0._type = var0.Battle.BattleConst.UnitType.UAV_UNIT
end

function var4.Update(arg0, arg1)
	arg0:updatePatrol(arg1)
end

function var4.SetTemplate(arg0, arg1)
	var4.super.SetTemplate(arg0, arg1)

	local var0 = arg1.funnel_behavior.offsetX * arg0:GetIFF()
	local var1 = arg1.funnel_behavior.offsetZ
	local var2 = var0.Battle.BattleDataProxy.GetInstance():GetVanguardBornCoordinate(arg0:GetIFF())

	arg0._centerPos = BuildVector3(var2) + Vector3(var0, 0, var1)
	arg0._range = arg1.funnel_behavior.hover_range
end

function var4.changePartolState(arg0, arg1)
	if arg1 == var4.MOVE_STATE then
		arg0:changeToMoveState()
	elseif arg1 == var4.HOVER_STATE then
		arg0:changeToHoverState()
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

function var4._updateCreate(arg0)
	arg0:UpdateSpeed()

	arg0._pos = arg0._pos + arg0._speed
end

function var4.changeToMoveState(arg0)
	arg0._cruiseLimit = arg0._centerPos.x
	arg0.updatePatrol = arg0._updateMove
end

function var4._updateMove(arg0, arg1)
	arg0:UpdateSpeed()

	arg0._pos = arg0._pos + arg0._speed

	if arg0._IFF == var1.FRIENDLY_CODE then
		if arg0._pos.x > arg0._cruiseLimit then
			arg0:changePartolState(var4.HOVER_STATE)
		end
	elseif arg0._IFF == var1.FOE_CODE and arg0._pos.x < arg0._cruiseLimit then
		arg0:changePartolState(var4.HOVER_STATE)
	end
end

function var4.changeToHoverState(arg0)
	arg0._hoverStartTime = pg.TimeMgr.GetInstance():GetCombatTime()
	arg0.updatePatrol = arg0._updateHover
end

function var4._updateHover(arg0, arg1)
	local var0 = arg1 - arg0._hoverStartTime

	arg0._pos = Vector3(math.sin(var0) * arg0._range, 15, math.cos(var0) * arg0._range):Add(arg0._centerPos)
end

function var4.GetSize(arg0)
	if arg0._portalState == var4.HOVER_STATE then
		local var0 = pg.TimeMgr.GetInstance():GetCombatTime() - arg0._hoverStartTime
		local var1 = math.cos(var0)

		if var1 > 0 and var1 < 0.2 then
			var1 = 0.2
		elseif var1 <= 0 and var1 > -0.2 then
			var1 = -0.2
		end

		return var1
	else
		var4.super.GetSize(arg0)
	end
end
