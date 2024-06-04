ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleAttr
local var5 = var0.Battle.BattleConfig
local var6 = var0.Battle.BattleUnitEvent
local var7 = class("BattleBossUnit", var0.Battle.BattleEnemyUnit)

var0.Battle.BattleBossUnit = var7
var7.__name = "BattleBossUnit"

function var7.Ctor(arg0, arg1, arg2)
	var7.super.Ctor(arg0, arg1, arg2)

	arg0._isBoss = true
end

function var7.IsBoss(arg0)
	return true
end

function var7.BarrierStateChange(arg0, arg1, arg2)
	local var0 = {
		barrierDurability = arg1,
		barrierDuration = arg2
	}

	arg0:DispatchEvent(var0.Event.New(var6.BARRIER_STATE_CHANGE, var0))
end

function var7.UpdateHP(arg0, arg1, arg2, arg3, arg4)
	local var0 = var7.super.UpdateHP(arg0, arg1, arg2, arg3, arg4) or 0

	if var0 < 0 then
		for iter0, iter1 in ipairs(arg0._autoWeaponList) do
			iter1:UpdatePrecastArmor(var0)
		end
	end

	return var0
end
