ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleSkillSummon = class("BattleSkillSummon", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillSummon.__name = "BattleSkillSummon"

local var2_0 = var0_0.Battle.BattleSkillSummon

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._spawnData = arg0_1._tempData.arg_list.spawnData
end

function var2_0.DoDataEffectWithoutTarget(arg0_2, arg1_2, arg2_2)
	arg0_2:DoSummon(arg1_2, arg2_2)
end

function var2_0.DoDataEffect(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3:DoSummon(arg1_3, arg3_3)
end

function var2_0.DoSummon(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var1_4 = arg1_4:GetIFF()

	if arg1_4:GetUnitType() == var1_0.UnitType.PLAYER_UNIT then
		local var2_4 = var0_4:SpawnNPC(arg0_4._spawnData, arg1_4)
	else
		local var3_4 = arg1_4:GetWaveIndex()

		var0_4:SpawnMonster(arg0_4._spawnData, var3_4, var1_0.UnitType.ENEMY_UNIT, var1_4):SetMaster(arg1_4)
	end
end
