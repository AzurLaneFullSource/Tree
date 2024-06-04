ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = class("BattleFleetBound")

var0.Battle.BattleFleetBound = var2
var2.__name = "BattleFleetBound"

function var2.Ctor(arg0, arg1)
	arg0._iff = arg1
end

function var2.Dispose(arg0)
	arg0._iff = nil
end

function var2.GetBound(arg0)
	return arg0._upperBound, arg0._lowerBound, arg0._absoluteLeft, arg0._absoluteRight, arg0._bufferLeft, arg0._bufferRight
end

function var2.GetAbsoluteRight(arg0)
	return arg0._absoluteRight
end

function var2.ConfigAreaData(arg0, arg1, arg2)
	arg0._totalArea = setmetatable({}, {
		__index = arg1
	})
	arg0._playerArea = setmetatable({}, {
		__index = arg2
	})
	arg0._totalLeftBound = arg0._totalArea[1]
	arg0._totalRightBound = arg0._totalArea[1] + arg0._totalArea[3]
	arg0._totalUpperBound = arg0._totalArea[2] + arg0._totalArea[4]
	arg0._totalLowerBound = arg0._totalArea[2]
	arg0._upperBound = arg0._playerArea[2] + arg0._playerArea[4]
	arg0._lowerBound = arg0._playerArea[2]
	arg0._middleLine = arg0._playerArea[1] + arg0._playerArea[3]
end

function var2.SwtichCommon(arg0)
	if arg0._iff == var1.FRIENDLY_CODE then
		arg0._absoluteLeft = arg0._playerArea[1]
		arg0._absoluteRight = var1.MaxRight
		arg0._bufferLeft = var1.MaxLeft
		arg0._bufferRight = arg0._middleLine
	elseif arg0._iff == var1.FOE_CODE then
		arg0._absoluteLeft = arg0._middleLine
		arg0._absoluteRight = arg0._totalRightBound
		arg0._bufferLeft = arg0._middleLine
		arg0._bufferRight = var1.MaxRight
	end
end

function var2.SwtichDuelAggressive(arg0)
	if arg0._iff == var1.FRIENDLY_CODE then
		arg0._absoluteLeft = arg0._middleLine
		arg0._absoluteRight = arg0._totalRightBound
		arg0._bufferLeft = arg0._middleLine
		arg0._bufferRight = var1.MaxRight
	elseif arg0._iff == var1.FOE_CODE then
		arg0._absoluteLeft = arg0._playerArea[1]
		arg0._absoluteRight = var1.MaxRight
		arg0._bufferLeft = var1.MaxLeft
		arg0._bufferRight = arg0._middleLine
	end
end

function var2.SwtichDBRGL(arg0)
	if arg0._iff == var1.FRIENDLY_CODE then
		arg0._absoluteLeft = arg0._playerArea[1]
		arg0._absoluteRight = arg0._middleLine
		arg0._bufferLeft = var1.MaxLeft
		arg0._bufferRight = var1.MaxRight
	elseif arg0._iff == var1.FOE_CODE then
		arg0._absoluteLeft = arg0._middleLine
		arg0._absoluteRight = arg0._totalRightBound
		arg0._bufferLeft = arg0._middleLine
		arg0._bufferRight = var1.MaxRight
	end
end

function var2.FixCardPuzzleInput(arg0, arg1)
	local var0 = math.clamp(arg1.x, arg0._absoluteLeft, arg0._absoluteRight)
	local var1 = math.clamp(arg1.z, arg0._lowerBound, arg0._upperBound)

	arg1:Set(var0, 0, var1)
end
