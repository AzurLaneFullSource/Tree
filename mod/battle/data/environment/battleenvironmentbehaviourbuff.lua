ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleEnvironmentBehaviourBuff", var0_0.Battle.BattleEnvironmentBehaviour)

var0_0.Battle.BattleEnvironmentBehaviourBuff = var3_0
var3_0.__name = "BattleEnvironmentBehaviourBuff"

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.SetTemplate(arg0_2, arg1_2)
	var3_0.super.SetTemplate(arg0_2, arg1_2)

	arg0_2._buffID = arg0_2._tmpData.buff_id
	arg0_2._buffLevel = arg0_2._tmpData.level or 1
end

function var3_0.doBehaviour(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3._cldUnitList) do
		if iter1_3:IsAlive() then
			local var0_3 = var0_0.Battle.BattleBuffUnit.New(arg0_3._buffID, arg0_3._buffLevel)

			iter1_3:AddBuff(var0_3)
		end
	end

	var3_0.super.doBehaviour(arg0_3)
end
