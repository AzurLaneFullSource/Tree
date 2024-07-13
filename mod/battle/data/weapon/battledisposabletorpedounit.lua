ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = class("BattleDisposableTorpedoUnit", var0_0.Battle.BattleManualTorpedoUnit)

var0_0.Battle.BattleDisposableTorpedoUnit = var2_0
var2_0.__name = "BattleDisposableTorpedoUnit"

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.EnterCoolDown(arg0_2)
	return
end

function var2_0.Fire(arg0_3)
	var2_0.super.Fire(arg0_3)
	arg0_3._playerTorpedoVO:Deduct(arg0_3)
	arg0_3._playerTorpedoVO:DispatchOverLoadChange()

	return true
end

function var2_0.OverHeat(arg0_4)
	arg0_4._currentState = arg0_4.STATE_OVER_HEAT
end

function var2_0.GetType(arg0_5)
	return var0_0.Battle.BattleConst.EquipmentType.DISPOSABLE_TORPEDO
end

function var2_0.createMajorEmitter(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6, arg5_6)
	return var2_0.super.createMajorEmitter(arg0_6, 1, arg2_6, arg3_6, arg4_6, arg5_6)
end
