ys = ys or {}

local var0 = ys
local var1 = class("BattleCardPuzzleSkillAddBuff", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillAddBuff = var1
var1.__name = "BattleCardPuzzleSkillAddBuff"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._buffID = arg0._tempData.arg_list.buff_id
end

function var1.SkillEffectHandler(arg0, arg1)
	local var0 = arg0:GetTarget()

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsAlive() then
			local var1 = var0.Battle.BattleBuffUnit.New(arg0._buffID, 1, arg0._caster)

			iter1:AddBuff(var1)
		end
	end

	arg0:Finale()
end
