ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillPhaseJump", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillPhaseJump = var1_0
var1_0.__name = "BattleSkillPhaseJump"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._phaseIndex = arg0_1._tempData.arg_list.index or 0
end

function var1_0.DoDataEffect(arg0_2, arg1_2)
	arg0_2:doJump(arg1_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	arg0_3:doJump(arg1_3)
end

function var1_0.doJump(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetPhaseSwitcher()

	if var0_4 then
		var0_4:ForceSwitch(arg0_4._phaseIndex)
	end
end
