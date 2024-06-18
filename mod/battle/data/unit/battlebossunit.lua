ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleAttr
local var5_0 = var0_0.Battle.BattleConfig
local var6_0 = var0_0.Battle.BattleUnitEvent
local var7_0 = class("BattleBossUnit", var0_0.Battle.BattleEnemyUnit)

var0_0.Battle.BattleBossUnit = var7_0
var7_0.__name = "BattleBossUnit"

function var7_0.Ctor(arg0_1, arg1_1, arg2_1)
	var7_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._isBoss = true
end

function var7_0.IsBoss(arg0_2)
	return true
end

function var7_0.BarrierStateChange(arg0_3, arg1_3, arg2_3)
	local var0_3 = {
		barrierDurability = arg1_3,
		barrierDuration = arg2_3
	}

	arg0_3:DispatchEvent(var0_0.Event.New(var6_0.BARRIER_STATE_CHANGE, var0_3))
end

function var7_0.UpdateHP(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	local var0_4 = var7_0.super.UpdateHP(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4) or 0

	if var0_4 < 0 then
		for iter0_4, iter1_4 in ipairs(arg0_4._autoWeaponList) do
			iter1_4:UpdatePrecastArmor(var0_4)
		end
	end

	return var0_4
end
