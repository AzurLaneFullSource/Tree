ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillPhaseJump", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillPhaseJump = var1
var1.__name = "BattleSkillPhaseJump"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1, lv)

	arg0._phaseIndex = arg0._tempData.arg_list.index or 0
end

function var1.DoDataEffect(arg0, arg1)
	arg0:doJump(arg1)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	arg0:doJump(arg1)
end

function var1.doJump(arg0, arg1)
	local var0 = arg1:GetPhaseSwitcher()

	if var0 then
		var0:ForceSwitch(arg0._phaseIndex)
	end
end
