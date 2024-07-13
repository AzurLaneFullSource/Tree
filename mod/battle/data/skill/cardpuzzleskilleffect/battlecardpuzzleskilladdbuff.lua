ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCardPuzzleSkillAddBuff", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillAddBuff = var1_0
var1_0.__name = "BattleCardPuzzleSkillAddBuff"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._buffID = arg0_1._tempData.arg_list.buff_id
end

function var1_0.SkillEffectHandler(arg0_2, arg1_2)
	local var0_2 = arg0_2:GetTarget()

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if iter1_2:IsAlive() then
			local var1_2 = var0_0.Battle.BattleBuffUnit.New(arg0_2._buffID, 1, arg0_2._caster)

			iter1_2:AddBuff(var1_2)
		end
	end

	arg0_2:Finale()
end
