ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConfig

var0.Battle.RandomStrategy = class("RandomStrategy", var0.Battle.BattleJoyStickBotBaseStrategy)

local var3 = var0.Battle.RandomStrategy

var3.__name = "RandomStrategy"
var3.STOP_DURATION_MAX = 20
var3.STOP_DURATION_MIN = 10
var3.MOVE_DURATION_MAX = 60
var3.MOVE_DURATION_MIN = 20

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)

	arg0._stopCount = 0
	arg0._moveCount = 0
	arg0._speed = Vector3.zero
	arg0._speedCross = Vector3.zero
end

function var3.GetStrategyType(arg0)
	return var0.Battle.BattleJoyStickAutoBot.RANDOM
end

function var3.Input(arg0, arg1, arg2)
	var3.super.Input(arg0, arg1, arg2)
	arg0:shiftTick(0, 10)
end

local var4 = Vector3.up

function var3._moveTick(arg0)
	if arg0._moveCount <= 0 then
		arg0:shiftTick(-1)
	else
		arg0._moveCount = arg0._moveCount - 1

		local var0 = arg0._speed:Magnitude()

		arg0._speedCross = arg0._speedCross:Copy(var4):Cross2(arg0._speed):Mul(arg0._crossAcc / var0)
		arg0._speed = arg0._speed:Add(arg0._speedCross)
		arg0._hrz = arg0._speed.x
		arg0._vtc = arg0._speed.z
	end
end

function var3._stopTick(arg0)
	if arg0._stopCount <= 0 then
		arg0:shiftTick(0, 10)
	else
		arg0._stopCount = arg0._stopCount - 1
	end
end

function var3.shiftTick(arg0, arg1, arg2)
	arg0._stopWeight = arg1 or arg0._stopWeight
	arg0._moveWeight = arg2 or arg0._moveWeight

	if math.random(arg0._stopWeight, arg0._moveWeight) >= 0 then
		arg0._moveWeight = arg0._moveWeight - 1
		arg0._moveCount = math.random(var3.MOVE_DURATION_MIN, var3.MOVE_DURATION_MAX)
		arg0._targetPoint = arg0:generateTargetPoint()

		local var0 = arg0._motionVO:GetPos()
		local var1, var2 = arg0.getDirection(var0, arg0._targetPoint)

		arg0._speed.x = var1
		arg0._speed.z = var2
		arg0._crossAcc = math.random(-100, 100) / 10000
		arg0.analysis = arg0._moveTick
	else
		arg0._stopCount = math.random(var3.STOP_DURATION_MIN, var3.STOP_DURATION_MAX)
		arg0.analysis = var3._stopTick
		arg0._hrz = 0
		arg0._vtc = 0
	end
end

function var3.generateTargetPoint(arg0)
	local var0 = arg0._fleetVO:GetLeaderPersonality()
	local var1 = var0.front_rate
	local var2 = var0.rear_rate

	if arg0._fleetVO:GetIFF() == var2.FRIENDLY_CODE then
		var1 = 1 - var1
		var2 = 1 - var2
	end

	local var3 = arg0._totalWidth * var1 + arg0._leftBound
	local var4 = arg0._totalWidth * var2 + arg0._leftBound
	local var5 = arg0._totalHeight * var0.upper_rate + arg0._lowerBound
	local var6 = arg0._totalHeight * var0.lower_rate + arg0._lowerBound
	local var7
	local var8 = math.random(var4, var3)
	local var9 = math.random(var6, var5)

	return (Vector3(var8, 0, var9))
end
