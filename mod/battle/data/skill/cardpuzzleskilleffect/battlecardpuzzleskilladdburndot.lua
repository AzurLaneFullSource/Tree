ys = ys or {}

local var0 = ys
local var1 = "BattleCardPuzzleSkillAddBurnDot"
local var2 = class(var1, var0.Battle.BattleCardPuzzleSkillAddBuff)

var0.Battle[var1] = var2
var2.__name = var1

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)

	arg0._buffID = arg0._tempData.arg_list.buff_id
	arg0._stack_count = arg0._tempData.arg_list.stack_count or 0
	arg0._stack_ratio = arg0._tempData.arg_list.stack_ratio or 0
end

function var2.SkillEffectHandler(arg0)
	local var0 = arg0:GetTarget()

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsAlive() then
			local var1 = arg0._stack_count
			local var2 = iter1:GetBuff(arg0._buffID)
			local var3 = var2 and var2:GetStack() or 0
			local var4 = var1 + math.floor(var3 * arg0._stack_ratio)
			local var5 = var0.Battle.BattleStackableBuffUnit.New(arg0._buffID, 1, arg0._caster, var4)
			local var6 = arg0:GetCardPuzzleComponent():GetAttrManager()

			var5:SetStackCount(var6:GetCurrent("BurnStackCount"))
			var5:SetUnstackCount(var6:GetCurrent("BurnUnStackCount"))
			iter1:AddBuff(var5)
		end
	end

	arg0:Finale()
end
