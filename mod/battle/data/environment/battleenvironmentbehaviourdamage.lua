ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourDamage", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourDamage = var3
var3.__name = "BattleEnvironmentBehaviourDamage"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._rate = arg0._tmpData.hp_rate or 0
	arg0._damage = arg0._tmpData.damage or 0
	arg0._offset = arg0._tmpData.offset or 0
end

function var3.doBehaviour(arg0)
	for iter0, iter1 in ipairs(arg0._cldUnitList) do
		local var0 = {
			isMiss = false,
			isCri = false,
			isHeal = false
		}
		local var1, var2 = iter1:GetHP()
		local var3 = math.max(0, math.floor(var2 * arg0._rate) + arg0._damage + math.random(-arg0._offset, arg0._offset))

		iter1:UpdateHP(-var3, var0)

		if not iter1:IsAlive() then
			var0.Battle.BattleAttr.Spirit(iter1)
			var0.Battle.BattleAttr.AppendInvincible(iter1)
		end
	end

	var3.super.doBehaviour(arg0)
end
