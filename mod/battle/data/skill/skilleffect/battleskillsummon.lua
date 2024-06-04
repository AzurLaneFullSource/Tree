ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleSkillSummon = class("BattleSkillSummon", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillSummon.__name = "BattleSkillSummon"

local var2 = var0.Battle.BattleSkillSummon

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1, lv)

	arg0._spawnData = arg0._tempData.arg_list.spawnData
end

function var2.DoDataEffectWithoutTarget(arg0, arg1, arg2)
	arg0:DoSummon(arg1, arg2)
end

function var2.DoDataEffect(arg0, arg1, arg2, arg3)
	arg0:DoSummon(arg1, arg3)
end

function var2.DoSummon(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleDataProxy.GetInstance()
	local var1 = arg1:GetIFF()

	if arg1:GetUnitType() == var1.UnitType.PLAYER_UNIT then
		local var2 = var0:SpawnNPC(arg0._spawnData, arg1)
	else
		local var3 = arg1:GetWaveIndex()

		var0:SpawnMonster(arg0._spawnData, var3, var1.UnitType.ENEMY_UNIT, var1):SetMaster(arg1)
	end
end
