ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleJoyStickBotBaseStrategy = class("BattleJoyStickBotBaseStrategy")

local var1_0 = var0_0.Battle.BattleJoyStickBotBaseStrategy

var1_0.__name = "BattleJoyStickBotBaseStrategy"

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._hrz = 0
	arg0_1._vtc = 0
	arg0_1._fleetVO = arg1_1
	arg0_1._motionVO = arg1_1:GetMotion()
end

function var1_0.GetStrategyType(arg0_2)
	return nil
end

function var1_0.SetBoardBound(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3._upperBound = arg1_3
	arg0_3._lowerBound = arg2_3
	arg0_3._leftBound = arg3_3
	arg0_3._rightBound = arg4_3
	arg0_3._totalWidth = arg4_3 - arg3_3
	arg0_3._totalHeight = arg1_3 - arg2_3
end

function var1_0.Input(arg0_4, arg1_4, arg2_4)
	arg0_4._foeShipList = arg1_4
	arg0_4._foeAircraftList = arg2_4
end

function var1_0.Output(arg0_5)
	arg0_5:analysis()

	return arg0_5._hrz, arg0_5._vtc
end

function var1_0.Dispose(arg0_6)
	arg0_6._foeShipList = nil
	arg0_6._foeAircraftList = nil
	arg0_6._motionVO = nil
end

function var1_0.analysis(arg0_7)
	return
end

function var1_0.getDirection(arg0_8, arg1_8)
	local var0_8 = (arg1_8 - arg0_8).normalized

	return var0_8.x, var0_8.z
end
