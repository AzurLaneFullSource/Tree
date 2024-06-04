ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = class("BattleDisposableTorpedoUnit", var0.Battle.BattleManualTorpedoUnit)

var0.Battle.BattleDisposableTorpedoUnit = var2
var2.__name = "BattleDisposableTorpedoUnit"

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.EnterCoolDown(arg0)
	return
end

function var2.Fire(arg0)
	var2.super.Fire(arg0)
	arg0._playerTorpedoVO:Deduct(arg0)
	arg0._playerTorpedoVO:DispatchOverLoadChange()

	return true
end

function var2.OverHeat(arg0)
	arg0._currentState = arg0.STATE_OVER_HEAT
end

function var2.GetType(arg0)
	return var0.Battle.BattleConst.EquipmentType.DISPOSABLE_TORPEDO
end

function var2.createMajorEmitter(arg0, arg1, arg2, arg3, arg4, arg5)
	return var2.super.createMajorEmitter(arg0, 1, arg2, arg3, arg4, arg5)
end
