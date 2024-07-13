ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillEditCustomWarning", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillEditCustomWarning = var1_0
var1_0.__name = "BattleSkillEditCustomWarning"
var1_0.OP_ADD = 1
var1_0.OP_REMOVE = 0
var1_0.OP_REMOVE_PERMANENT = -1
var1_0.OP_REMOVE_TEMPLATE = -2

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._labelData = {
		op = arg0_1._tempData.arg_list.op,
		key = arg0_1._tempData.arg_list.key,
		x = arg0_1._tempData.arg_list.x,
		y = arg0_1._tempData.arg_list.y,
		dialogue = arg0_1._tempData.arg_list.dialogue,
		duration = arg0_1._tempData.arg_list.duration
	}
end

function var1_0.DoDataEffect(arg0_2)
	arg0_2:doEditWarning()
end

function var1_0.DoDataEffectWithoutTarget(arg0_3)
	arg0_3:doEditWarning()
end

function var1_0.doEditWarning(arg0_4)
	var0_0.Battle.BattleDataProxy.GetInstance():DispatchCustomWarning(arg0_4._labelData)
end
