ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleEnvironmentBehaviourBuff", var0.Battle.BattleEnvironmentBehaviour)

var0.Battle.BattleEnvironmentBehaviourBuff = var3
var3.__name = "BattleEnvironmentBehaviourBuff"

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.SetTemplate(arg0, arg1)
	var3.super.SetTemplate(arg0, arg1)

	arg0._buffID = arg0._tmpData.buff_id
	arg0._buffLevel = arg0._tmpData.level or 1
end

function var3.doBehaviour(arg0)
	for iter0, iter1 in ipairs(arg0._cldUnitList) do
		if iter1:IsAlive() then
			local var0 = var0.Battle.BattleBuffUnit.New(arg0._buffID, arg0._buffLevel)

			iter1:AddBuff(var0)
		end
	end

	var3.super.doBehaviour(arg0)
end
