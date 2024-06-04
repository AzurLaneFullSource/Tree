ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr

var0.Battle.BattleBuffCastSkillDamageCount = class("BattleBuffCastSkillDamageCount", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffCastSkillDamageCount.__name = "BattleBuffCastSkillDamageCount"

local var2 = var0.Battle.BattleBuffCastSkillDamageCount

var2.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TYPE_CASTER

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._level = arg2:GetLv()
	arg0._skillTable = arg0._tempData.arg_list.damage_attr_list
	arg0._attrTable = {}
end

function var2.onTakeDamage(arg0, arg1, arg2, arg3)
	local var0 = arg3.damageAttr

	if var0 then
		local var1 = (arg0._attrTable[var0] or 0) + arg3.damage

		arg0._attrTable[var0] = var1
	end
end

function var2.onRemove(arg0, arg1, arg2, arg3)
	local var0 = 0
	local var1

	for iter0, iter1 in pairs(arg0._attrTable) do
		if var0 <= iter1 then
			var0 = iter1
			var1 = iter0
		end
	end

	if not var1 then
		return
	end

	local var2 = arg0._skillTable[var1]

	arg0._skill = var0.Battle.BattleSkillUnit.GenerateSpell(var2, arg0._level, arg1, arg3)

	if arg3 and arg3.target then
		arg0._skill:SetTarget({
			arg3.target
		})
	end

	arg0._skill:Cast(arg1, arg0._commander)
end

function var2.Interrupt(arg0)
	var2.super.Interrupt(arg0)

	if arg0._skill then
		arg0._skill:Interrupt()
	end
end

function var2.Clear(arg0)
	var2.super.Clear(arg0)

	if arg0._skill then
		arg0._skill:Clear()

		arg0._skill = nil
	end
end
