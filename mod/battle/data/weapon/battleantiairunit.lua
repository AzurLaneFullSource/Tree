ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleAntiAirUnit", var0_0.Battle.BattleWeaponUnit)

var0_0.Battle.BattleAntiAirUnit = var1_0
var1_0.__name = "BattleAntiAirUnit"

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.TriggerBuffOnFire(arg0_2)
	arg0_2._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_FIRE_NEAR, {})
end

function var1_0.FilterTarget(arg0_3)
	local var0_3 = arg0_3._dataProxy:GetAircraftList()
	local var1_3 = {}
	local var2_3 = arg0_3._host:GetIFF()
	local var3_3 = 1

	for iter0_3, iter1_3 in pairs(var0_3) do
		if iter1_3:GetIFF() ~= var2_3 and iter1_3:IsVisitable() then
			var1_3[var3_3] = iter1_3
			var3_3 = var3_3 + 1
		end
	end

	return var1_3
end

function var1_0.Spawn(arg0_4, arg1_4, arg2_4)
	local var0_4 = var1_0.super.Spawn(arg0_4, arg1_4, arg2_4)

	var0_4:SetDirectHitUnit(arg2_4)

	return var0_4
end

function var1_0.TriggerBuffWhenSpawn(arg0_5, arg1_5)
	local var0_5 = {
		_bullet = arg1_5,
		bulletTag = arg1_5:GetExtraTag()
	}

	arg0_5._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_BULLET_CREATE, var0_5)
	arg0_5._host:TriggerBuff(var0_0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_BULLET_CREATE, var0_5)
end
