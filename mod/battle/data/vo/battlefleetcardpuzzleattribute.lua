ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleUnitEvent
local var2 = var0.Battle.BattleEvent
local var3 = var0.Battle.BattleCardPuzzleEvent
local var4 = var0.Battle.BattleFormulas
local var5 = var0.Battle.BattleConst
local var6 = var0.Battle.BattleConfig
local var7 = var0.Battle.BattleCardPuzzleConfig
local var8 = var0.Battle.BattleAttr
local var9 = var0.Battle.BattleDataFunction
local var10 = var0.Battle.BattleAttr
local var11 = class("BattleFleetCardPuzzleAttribute")

var0.Battle.BattleFleetCardPuzzleAttribute = var11
var11.__name = "BattleFleetCardPuzzleAttribute"

function var11.Ctor(arg0, arg1)
	arg0:init()

	arg0._client = arg1
end

function var11.init(arg0)
	arg0._buffAttr = {}
	arg0._attrList = {}
	arg0._clampList = {}
end

function var11.AddBaseAttr(arg0, arg1, arg2)
	arg0._attrList[arg1] = math.max(0, arg2 + (arg0._attrList[arg1] or 0))
	arg0._attrList[arg1] = arg0:checkClamp(arg1)

	arg0._client:DispatchUpdateAttr(arg1)
	arg0:specificAttrUpdate(arg1)
end

function var11.SetAttr(arg0, arg1, arg2)
	arg0._attrList[arg1] = arg2
	arg0._attrList[arg1] = arg0:checkClamp(arg1)

	arg0._client:DispatchUpdateAttr(arg1)
	arg0:specificAttrUpdate(arg1)
end

function var11.specificAttrUpdate(arg0, arg1)
	if arg1 == "BaseEnergyBoostRate" or arg1 == "BaseEnergyBoostExtra" then
		arg0._client:FlushHandOverheat()
	end
end

function var11.checkClamp(arg0, arg1)
	if arg0._attrList[arg1] == nil then
		return
	end

	local var0 = arg0._attrList[arg1]
	local var1 = var7.FleetAttrClamp[arg1]

	if var1 then
		local var2 = arg0._attrList[var1.max]
		local var3 = arg0._attrList[var1.min] or 0

		var0 = math.max(var0, var3)
		var0 = var2 and math.min(var0, var2) or var0
	end

	return var0
end

function var11.GetCurrent(arg0, arg1)
	return arg0._attrList[arg1] or 0
end
