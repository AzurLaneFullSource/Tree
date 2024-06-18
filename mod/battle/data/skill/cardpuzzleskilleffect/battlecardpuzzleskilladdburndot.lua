ys = ys or {}

local var0_0 = ys
local var1_0 = "BattleCardPuzzleSkillAddBurnDot"
local var2_0 = class(var1_0, var0_0.Battle.BattleCardPuzzleSkillAddBuff)

var0_0.Battle[var1_0] = var2_0
var2_0.__name = var1_0

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._buffID = arg0_1._tempData.arg_list.buff_id
	arg0_1._stack_count = arg0_1._tempData.arg_list.stack_count or 0
	arg0_1._stack_ratio = arg0_1._tempData.arg_list.stack_ratio or 0
end

function var2_0.SkillEffectHandler(arg0_2)
	local var0_2 = arg0_2:GetTarget()

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if iter1_2:IsAlive() then
			local var1_2 = arg0_2._stack_count
			local var2_2 = iter1_2:GetBuff(arg0_2._buffID)
			local var3_2 = var2_2 and var2_2:GetStack() or 0
			local var4_2 = var1_2 + math.floor(var3_2 * arg0_2._stack_ratio)
			local var5_2 = var0_0.Battle.BattleStackableBuffUnit.New(arg0_2._buffID, 1, arg0_2._caster, var4_2)
			local var6_2 = arg0_2:GetCardPuzzleComponent():GetAttrManager()

			var5_2:SetStackCount(var6_2:GetCurrent("BurnStackCount"))
			var5_2:SetUnstackCount(var6_2:GetCurrent("BurnUnStackCount"))
			iter1_2:AddBuff(var5_2)
		end
	end

	arg0_2:Finale()
end
