ys = ys or {}

local var0 = ys

var0.Battle.BattleSkillConsumeBuff = class("BattleSkillConsumeBuff", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillConsumeBuff.__name = "BattleSkillConsumeBuff"

local var1 = var0.Battle.BattleSkillConsumeBuff

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._buffID = arg0._tempData.arg_list.buff_id
	arg0._count = arg0._tempData.arg_list.consume_count
end

function var1.DoDataEffect(arg0, arg1, arg2)
	if arg2:IsAlive() then
		arg2:ConsumeBuffStack(arg0._buffID, arg0._count)
	end
end
