ys = ys or {}

local var0 = ys
local var1 = class("BattleAntiAirUnit", var0.Battle.BattleWeaponUnit)

var0.Battle.BattleAntiAirUnit = var1
var1.__name = "BattleAntiAirUnit"

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.TriggerBuffOnFire(arg0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_FIRE_NEAR, {})
end

function var1.FilterTarget(arg0)
	local var0 = arg0._dataProxy:GetAircraftList()
	local var1 = {}
	local var2 = arg0._host:GetIFF()
	local var3 = 1

	for iter0, iter1 in pairs(var0) do
		if iter1:GetIFF() ~= var2 and iter1:IsVisitable() then
			var1[var3] = iter1
			var3 = var3 + 1
		end
	end

	return var1
end

function var1.Spawn(arg0, arg1, arg2)
	local var0 = var1.super.Spawn(arg0, arg1, arg2)

	var0:SetDirectHitUnit(arg2)

	return var0
end

function var1.TriggerBuffWhenSpawn(arg0, arg1)
	local var0 = {
		_bullet = arg1,
		bulletTag = arg1:GetExtraTag()
	}

	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_BULLET_CREATE, var0)
	arg0._host:TriggerBuff(var0.Battle.BattleConst.BuffEffectType.ON_ANTIAIR_BULLET_CREATE, var0)
end
