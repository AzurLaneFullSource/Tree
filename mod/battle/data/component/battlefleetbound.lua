ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = class("BattleFleetBound")

var0_0.Battle.BattleFleetBound = var2_0
var2_0.__name = "BattleFleetBound"

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._iff = arg1_1
end

function var2_0.Dispose(arg0_2)
	arg0_2._iff = nil
end

function var2_0.GetBound(arg0_3)
	return arg0_3._upperBound, arg0_3._lowerBound, arg0_3._absoluteLeft, arg0_3._absoluteRight, arg0_3._bufferLeft, arg0_3._bufferRight
end

function var2_0.GetAbsoluteRight(arg0_4)
	return arg0_4._absoluteRight
end

function var2_0.ConfigAreaData(arg0_5, arg1_5, arg2_5)
	arg0_5._totalArea = setmetatable({}, {
		__index = arg1_5
	})
	arg0_5._playerArea = setmetatable({}, {
		__index = arg2_5
	})
	arg0_5._totalLeftBound = arg0_5._totalArea[1]
	arg0_5._totalRightBound = arg0_5._totalArea[1] + arg0_5._totalArea[3]
	arg0_5._totalUpperBound = arg0_5._totalArea[2] + arg0_5._totalArea[4]
	arg0_5._totalLowerBound = arg0_5._totalArea[2]
	arg0_5._upperBound = arg0_5._playerArea[2] + arg0_5._playerArea[4]
	arg0_5._lowerBound = arg0_5._playerArea[2]
	arg0_5._middleLine = arg0_5._playerArea[1] + arg0_5._playerArea[3]
end

function var2_0.SwtichCommon(arg0_6)
	if arg0_6._iff == var1_0.FRIENDLY_CODE then
		arg0_6._absoluteLeft = arg0_6._playerArea[1]
		arg0_6._absoluteRight = var1_0.MaxRight
		arg0_6._bufferLeft = var1_0.MaxLeft
		arg0_6._bufferRight = arg0_6._middleLine
	elseif arg0_6._iff == var1_0.FOE_CODE then
		arg0_6._absoluteLeft = arg0_6._middleLine
		arg0_6._absoluteRight = arg0_6._totalRightBound
		arg0_6._bufferLeft = arg0_6._middleLine
		arg0_6._bufferRight = var1_0.MaxRight
	end
end

function var2_0.SwtichDuelAggressive(arg0_7)
	if arg0_7._iff == var1_0.FRIENDLY_CODE then
		arg0_7._absoluteLeft = arg0_7._middleLine
		arg0_7._absoluteRight = arg0_7._totalRightBound
		arg0_7._bufferLeft = arg0_7._middleLine
		arg0_7._bufferRight = var1_0.MaxRight
	elseif arg0_7._iff == var1_0.FOE_CODE then
		arg0_7._absoluteLeft = arg0_7._playerArea[1]
		arg0_7._absoluteRight = var1_0.MaxRight
		arg0_7._bufferLeft = var1_0.MaxLeft
		arg0_7._bufferRight = arg0_7._middleLine
	end
end

function var2_0.SwtichDBRGL(arg0_8)
	if arg0_8._iff == var1_0.FRIENDLY_CODE then
		arg0_8._absoluteLeft = arg0_8._playerArea[1]
		arg0_8._absoluteRight = arg0_8._middleLine
		arg0_8._bufferLeft = var1_0.MaxLeft
		arg0_8._bufferRight = var1_0.MaxRight
	elseif arg0_8._iff == var1_0.FOE_CODE then
		arg0_8._absoluteLeft = arg0_8._middleLine
		arg0_8._absoluteRight = arg0_8._totalRightBound
		arg0_8._bufferLeft = arg0_8._middleLine
		arg0_8._bufferRight = var1_0.MaxRight
	end
end

function var2_0.FixCardPuzzleInput(arg0_9, arg1_9)
	local var0_9 = math.clamp(arg1_9.x, arg0_9._absoluteLeft, arg0_9._absoluteRight)
	local var1_9 = math.clamp(arg1_9.z, arg0_9._lowerBound, arg0_9._upperBound)

	arg1_9:Set(var0_9, 0, var1_9)
end
