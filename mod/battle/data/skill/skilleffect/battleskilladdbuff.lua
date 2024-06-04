ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillAddBuff = class("BattleSkillAddBuff", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillAddBuff.__name = "BattleSkillAddBuff"

function var0.Battle.BattleSkillAddBuff.Ctor(arg0, arg1, arg2)
	var0.Battle.BattleSkillAddBuff.super.Ctor(arg0, arg1, arg2)

	arg0._buffID = arg0._tempData.arg_list.buff_id
end

function var0.Battle.BattleSkillAddBuff.DoDataEffect(arg0, arg1, arg2)
	if arg2:IsAlive() then
		local var0 = var0.Battle.BattleBuffUnit.New(arg0._buffID, arg0._level, arg1)

		var0:SetCommander(arg0._commander)
		arg2:AddBuff(var0)
	end
end
