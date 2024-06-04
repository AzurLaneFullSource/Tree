ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillTeleport", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillTeleport = var1
var1.__name = "BattleSkillTeleport"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)
end

function var1.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg0.calcCorrdinate(arg0._tempData.arg_list, arg1, arg2)

	arg1:SetPosition(var0)
end

function var1.DoDataEffectWithoutTarget(arg0, arg1)
	local var0 = arg0.calcCorrdinate(arg0._tempData.arg_list, arg1)

	arg1:SetPosition(var0)
end
