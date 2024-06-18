ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourDamage", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourDamage = var3_0
var3_0.__name = "BattleEnvironmentBehaviourDamage"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._rate = arg0_2._tmpData.hp_rate or 0
	arg0_2._damage = arg0_2._tmpData.damage or 0
	arg0_2._offset = arg0_2._tmpData.offset or 0
end

function var3_0.doBehaviour(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._cldUnitList) do
		local var0_3 = {
			isMiss = false,
			isCri = false,
			isHeal = false
		}
		local var1_3, var2_3 = iter1_3:GetHP()
		local var3_3 = math.max(0, math.floor(var2_3 * arg0_3._rate) + arg0_3._damage + math.random(-arg0_3._offset, arg0_3._offset))

		iter1_3:UpdateHP(-var3_3, var0_3)

		if not iter1_3:IsAlive() then
			var0_0.Battle.BattleAttr.Spirit(iter1_3)
			var0_0.Battle.BattleAttr.AppendInvincible(iter1_3)
		end
	end

	var3_0.super.doBehaviour(arg0_3)
end
