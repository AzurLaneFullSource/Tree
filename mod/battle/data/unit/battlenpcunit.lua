ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = var0.Battle.BattleFormulas
local var4 = var0.Battle.BattleAttr
local var5 = var0.Battle.BattleUnitEvent

var0.Battle.BattleNPCUnit = class("BattleNPCUnit", var0.Battle.BattleEnemyUnit)

local var6 = var0.Battle.BattleNPCUnit

function var6.SetTemplate(arg0, arg1, arg2)
	var6.super.SetTemplate(arg0, arg1)

	arg0._tmpData = setmetatable({}, {
		__index = var0.Battle.BattleDataFunction.GetMonsterTmpDataFromID(arg0._tmpID)
	})

	if arg2.template then
		for iter0, iter1 in pairs(arg2.template) do
			arg0._tmpData[iter0] = iter1
		end

		arg0._tmpData.id = arg1
	end

	if arg2.attr then
		var4.SetAttr(arg0, arg2.attr)
	else
		arg0:SetAttr()
	end

	local var0 = arg2.currentHP or arg0:GetMaxHP()

	arg0:SetCurrentHP(var0)
	arg0:InitCldComponent()
end
