ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillTeleport", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillTeleport = var1_0
var1_0.__name = "BattleSkillTeleport"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.calcCorrdinate(arg0_2._tempData.arg_list, arg1_2, arg2_2)

	arg1_2:SetPosition(var0_2)
end

function var1_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	local var0_3 = arg0_3.calcCorrdinate(arg0_3._tempData.arg_list, arg1_3)

	arg1_3:SetPosition(var0_3)
end
