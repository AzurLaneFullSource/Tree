ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleAttr
local var8_0 = var0_0.Battle.BattleDataFunction
local var9_0 = var0_0.Battle.BattleAttr
local var10_0 = class("BattleFleetCardPuzzleFleetBuffManager")

var0_0.Battle.BattleFleetCardPuzzleFleetBuffManager = var10_0
var10_0.__name = "BattleFleetCardPuzzleFleetBuffManager"

function var10_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1

	arg0_1:init()
end

function var10_0.Trigger(arg0_2, arg1_2, arg2_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in pairs(arg0_2._buffList) do
		if iter1_2:IsResponTo(arg1_2) then
			table.insert(var0_2, iter1_2)
		end
	end

	for iter2_2, iter3_2 in ipairs(var0_2) do
		iter3_2:onTrigger(arg1_2, arg2_2)
	end
end

function var10_0.Update(arg0_3, arg1_3)
	local var0_3 = arg0_3._buffList

	for iter0_3, iter1_3 in pairs(var0_3) do
		iter1_3:Update(arg1_3)
	end
end

function var10_0.AttachCardPuzzleBuff(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetID()
	local var1_4 = arg0_4:GetCardPuzzleBuff(var0_4)

	if var1_4 then
		var1_4:Stack()
	else
		arg0_4._buffList[var0_4] = arg1_4

		arg1_4:Attach(arg0_4._client)
	end
end

function var10_0.GetCardPuzzleBuff(arg0_5, arg1_5)
	return arg0_5._buffList[arg1_5]
end

function var10_0.GetCardPuzzleBuffList(arg0_6)
	return arg0_6._buffList
end

function var10_0.init(arg0_7)
	arg0_7._buffList = {}
end
