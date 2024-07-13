ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.RandomStrategy = class("RandomStrategy", var0_0.Battle.BattleJoyStickBotBaseStrategy)

local var3_0 = var0_0.Battle.RandomStrategy

var3_0.__name = "RandomStrategy"
var3_0.STOP_DURATION_MAX = 20
var3_0.STOP_DURATION_MIN = 10
var3_0.MOVE_DURATION_MAX = 60
var3_0.MOVE_DURATION_MIN = 20

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)

	arg0_1._stopCount = 0
	arg0_1._moveCount = 0
	arg0_1._speed = Vector3.zero
	arg0_1._speedCross = Vector3.zero
end

function var3_0.GetStrategyType(arg0_2)
	return var0_0.Battle.BattleJoyStickAutoBot.RANDOM
end

function var3_0.Input(arg0_3, arg1_3, arg2_3)
	var3_0.super.Input(arg0_3, arg1_3, arg2_3)
	arg0_3:shiftTick(0, 10)
end

local var4_0 = Vector3.up

function var3_0._moveTick(arg0_4)
	if arg0_4._moveCount <= 0 then
		arg0_4:shiftTick(-1)
	else
		arg0_4._moveCount = arg0_4._moveCount - 1

		local var0_4 = arg0_4._speed:Magnitude()

		arg0_4._speedCross = arg0_4._speedCross:Copy(var4_0):Cross2(arg0_4._speed):Mul(arg0_4._crossAcc / var0_4)
		arg0_4._speed = arg0_4._speed:Add(arg0_4._speedCross)
		arg0_4._hrz = arg0_4._speed.x
		arg0_4._vtc = arg0_4._speed.z
	end
end

function var3_0._stopTick(arg0_5)
	if arg0_5._stopCount <= 0 then
		arg0_5:shiftTick(0, 10)
	else
		arg0_5._stopCount = arg0_5._stopCount - 1
	end
end

function var3_0.shiftTick(arg0_6, arg1_6, arg2_6)
	arg0_6._stopWeight = arg1_6 or arg0_6._stopWeight
	arg0_6._moveWeight = arg2_6 or arg0_6._moveWeight

	if math.random(arg0_6._stopWeight, arg0_6._moveWeight) >= 0 then
		arg0_6._moveWeight = arg0_6._moveWeight - 1
		arg0_6._moveCount = math.random(var3_0.MOVE_DURATION_MIN, var3_0.MOVE_DURATION_MAX)
		arg0_6._targetPoint = arg0_6:generateTargetPoint()

		local var0_6 = arg0_6._motionVO:GetPos()
		local var1_6, var2_6 = arg0_6.getDirection(var0_6, arg0_6._targetPoint)

		arg0_6._speed.x = var1_6
		arg0_6._speed.z = var2_6
		arg0_6._crossAcc = math.random(-100, 100) / 10000
		arg0_6.analysis = arg0_6._moveTick
	else
		arg0_6._stopCount = math.random(var3_0.STOP_DURATION_MIN, var3_0.STOP_DURATION_MAX)
		arg0_6.analysis = var3_0._stopTick
		arg0_6._hrz = 0
		arg0_6._vtc = 0
	end
end

function var3_0.generateTargetPoint(arg0_7)
	local var0_7 = arg0_7._fleetVO:GetLeaderPersonality()
	local var1_7 = var0_7.front_rate
	local var2_7 = var0_7.rear_rate

	if arg0_7._fleetVO:GetIFF() == var2_0.FRIENDLY_CODE then
		var1_7 = 1 - var1_7
		var2_7 = 1 - var2_7
	end

	local var3_7 = arg0_7._totalWidth * var1_7 + arg0_7._leftBound
	local var4_7 = arg0_7._totalWidth * var2_7 + arg0_7._leftBound
	local var5_7 = arg0_7._totalHeight * var0_7.upper_rate + arg0_7._lowerBound
	local var6_7 = arg0_7._totalHeight * var0_7.lower_rate + arg0_7._lowerBound
	local var7_7
	local var8_7 = math.random(var4_7, var3_7)
	local var9_7 = math.random(var6_7, var5_7)

	return (Vector3(var8_7, 0, var9_7))
end
