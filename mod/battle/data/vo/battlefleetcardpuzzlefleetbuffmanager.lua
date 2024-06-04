ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleAttr
local var8 = var0.Battle.BattleDataFunction
local var9 = var0.Battle.BattleAttr
local var10 = class("BattleFleetCardPuzzleFleetBuffManager")

var0.Battle.BattleFleetCardPuzzleFleetBuffManager = var10
var10.__name = "BattleFleetCardPuzzleFleetBuffManager"

function var10.Ctor(arg0, arg1)
	arg0._client = arg1

	arg0:init()
end

function var10.Trigger(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._buffList) do
		if iter1:IsResponTo(arg1) then
			table.insert(var0, iter1)
		end
	end

	for iter2, iter3 in ipairs(var0) do
		iter3:onTrigger(arg1, arg2)
	end
end

function var10.Update(arg0, arg1)
	local var0 = arg0._buffList

	for iter0, iter1 in pairs(var0) do
		iter1:Update(arg1)
	end
end

function var10.AttachCardPuzzleBuff(arg0, arg1)
	local var0 = arg1:GetID()
	local var1 = arg0:GetCardPuzzleBuff(var0)

	if var1 then
		var1:Stack()
	else
		arg0._buffList[var0] = arg1

		arg1:Attach(arg0._client)
	end
end

function var10.GetCardPuzzleBuff(arg0, arg1)
	return arg0._buffList[arg1]
end

function var10.GetCardPuzzleBuffList(arg0)
	return arg0._buffList
end

function var10.init(arg0)
	arg0._buffList = {}
end
