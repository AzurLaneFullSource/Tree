ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr

var0_0.Battle.BattleBuffCastSkillDamageCount = class("BattleBuffCastSkillDamageCount", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffCastSkillDamageCount.__name = "BattleBuffCastSkillDamageCount"

local var2_0 = var0_0.Battle.BattleBuffCastSkillDamageCount

var2_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TYPE_CASTER

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._level = arg2_2:GetLv()
	arg0_2._skillTable = arg0_2._tempData.arg_list.damage_attr_list
	arg0_2._attrTable = {}
end

function var2_0.onTakeDamage(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3.damageAttr

	if var0_3 then
		local var1_3 = (arg0_3._attrTable[var0_3] or 0) + arg3_3.damage

		arg0_3._attrTable[var0_3] = var1_3
	end
end

function var2_0.onRemove(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = 0
	local var1_4

	for iter0_4, iter1_4 in pairs(arg0_4._attrTable) do
		if var0_4 <= iter1_4 then
			var0_4 = iter1_4
			var1_4 = iter0_4
		end
	end

	if not var1_4 then
		return
	end

	local var2_4 = arg0_4._skillTable[var1_4]

	arg0_4._skill = var0_0.Battle.BattleSkillUnit.GenerateSpell(var2_4, arg0_4._level, arg1_4, arg3_4)

	if arg3_4 and arg3_4.target then
		arg0_4._skill:SetTarget({
			arg3_4.target
		})
	end

	arg0_4._skill:Cast(arg1_4, arg0_4._commander)
end

function var2_0.Interrupt(arg0_5)
	var2_0.super.Interrupt(arg0_5)

	if arg0_5._skill then
		arg0_5._skill:Interrupt()
	end
end

function var2_0.Clear(arg0_6)
	var2_0.super.Clear(arg0_6)

	if arg0_6._skill then
		arg0_6._skill:Clear()

		arg0_6._skill = nil
	end
end
