ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = var0_0.Battle.BattleFormulas
local var4_0 = var0_0.Battle.BattleAttr
local var5_0 = var0_0.Battle.BattleUnitEvent

var0_0.Battle.BattleNPCUnit = class("BattleNPCUnit", var0_0.Battle.BattleEnemyUnit)

local var6_0 = var0_0.Battle.BattleNPCUnit

function var6_0.SetTemplate(arg0_1, arg1_1, arg2_1)
	var6_0.super.SetTemplate(arg0_1, arg1_1)

	arg0_1._tmpData = setmetatable({}, {
		__index = var0_0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0_1._tmpID)
	})

	if arg2_1.template then
		for iter0_1, iter1_1 in pairs(arg2_1.template) do
			arg0_1._tmpData[iter0_1] = iter1_1
		end

		arg0_1._tmpData.id = arg1_1
	end

	if arg2_1.attr then
		var4_0.SetAttr(arg0_1, arg2_1.attr)
	else
		arg0_1:SetAttr()
	end

	local var0_1 = arg2_1.currentHP or arg0_1:GetMaxHP()

	arg0_1:SetCurrentHP(var0_1)
	arg0_1:InitCldComponent()
end
