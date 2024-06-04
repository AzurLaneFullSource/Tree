ys = ys or {}

local var0 = ys

var0.Battle.BattleJoyStickBotBaseStrategy = class("BattleJoyStickBotBaseStrategy")

local var1 = var0.Battle.BattleJoyStickBotBaseStrategy

var1.__name = "BattleJoyStickBotBaseStrategy"

function var1.Ctor(arg0, arg1)
	arg0._hrz = 0
	arg0._vtc = 0
	arg0._fleetVO = arg1
	arg0._motionVO = arg1:GetMotion()
end

function var1.GetStrategyType(arg0)
	return nil
end

function var1.SetBoardBound(arg0, arg1, arg2, arg3, arg4)
	arg0._upperBound = arg1
	arg0._lowerBound = arg2
	arg0._leftBound = arg3
	arg0._rightBound = arg4
	arg0._totalWidth = arg4 - arg3
	arg0._totalHeight = arg1 - arg2
end

function var1.Input(arg0, arg1, arg2)
	arg0._foeShipList = arg1
	arg0._foeAircraftList = arg2
end

function var1.Output(arg0)
	arg0:analysis()

	return arg0._hrz, arg0._vtc
end

function var1.Dispose(arg0)
	arg0._foeShipList = nil
	arg0._foeAircraftList = nil
	arg0._motionVO = nil
end

function var1.analysis(arg0)
	return
end

function var1.getDirection(arg0, arg1)
	local var0 = (arg1 - arg0).normalized

	return var0.x, var0.z
end
