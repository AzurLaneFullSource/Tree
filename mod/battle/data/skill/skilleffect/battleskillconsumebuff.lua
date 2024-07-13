ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSkillConsumeBuff = class("BattleSkillConsumeBuff", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillConsumeBuff.__name = "BattleSkillConsumeBuff"

local var1_0 = var0_0.Battle.BattleSkillConsumeBuff

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._buffID = arg0_1._tempData.arg_list.buff_id
	arg0_1._count = arg0_1._tempData.arg_list.consume_count
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg2_2:IsAlive() then
		arg2_2:ConsumeBuffStack(arg0_2._buffID, arg0_2._count)
	end
end
