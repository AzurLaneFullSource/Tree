ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillEditCustomWarning", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillEditCustomWarning = var1
var1.__name = "BattleSkillEditCustomWarning"
var1.OP_ADD = 1
var1.OP_REMOVE = 0
var1.OP_REMOVE_PERMANENT = -1
var1.OP_REMOVE_TEMPLATE = -2

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._labelData = {
		op = arg0._tempData.arg_list.op,
		key = arg0._tempData.arg_list.key,
		x = arg0._tempData.arg_list.x,
		y = arg0._tempData.arg_list.y,
		dialogue = arg0._tempData.arg_list.dialogue,
		duration = arg0._tempData.arg_list.duration
	}
end

function var1.DoDataEffect(arg0)
	arg0:doEditWarning()
end

function var1.DoDataEffectWithoutTarget(arg0)
	arg0:doEditWarning()
end

function var1.doEditWarning(arg0)
	var0.Battle.BattleDataProxy.GetInstance():DispatchCustomWarning(arg0._labelData)
end
