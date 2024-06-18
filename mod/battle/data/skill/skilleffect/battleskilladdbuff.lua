ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillAddBuff = class("BattleSkillAddBuff", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillAddBuff.__name = "BattleSkillAddBuff"

function var0_0.Battle.BattleSkillAddBuff.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.Battle.BattleSkillAddBuff.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._buffID = arg0_1._tempData.arg_list.buff_id
end

function var0_0.Battle.BattleSkillAddBuff.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg2_2:IsAlive() then
		local var0_2 = var0_0.Battle.BattleBuffUnit.New(arg0_2._buffID, arg0_2._level, arg1_2)

		var0_2:SetCommander(arg0_2._commander)
		arg2_2:AddBuff(var0_2)
	end
end
