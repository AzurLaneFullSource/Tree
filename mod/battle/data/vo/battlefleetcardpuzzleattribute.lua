ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleUnitEvent
local var2_0 = var0_0.Battle.BattleEvent
local var3_0 = var0_0.Battle.BattleCardPuzzleEvent
local var4_0 = var0_0.Battle.BattleFormulas
local var5_0 = var0_0.Battle.BattleConst
local var6_0 = var0_0.Battle.BattleConfig
local var7_0 = var0_0.Battle.BattleCardPuzzleConfig
local var8_0 = var0_0.Battle.BattleAttr
local var9_0 = var0_0.Battle.BattleDataFunction
local var10_0 = var0_0.Battle.BattleAttr
local var11_0 = class("BattleFleetCardPuzzleAttribute")

var0_0.Battle.BattleFleetCardPuzzleAttribute = var11_0
var11_0.__name = "BattleFleetCardPuzzleAttribute"

function var11_0.Ctor(arg0_1, arg1_1)
	arg0_1:init()

	arg0_1._client = arg1_1
end

function var11_0.init(arg0_2)
	arg0_2._buffAttr = {}
	arg0_2._attrList = {}
	arg0_2._clampList = {}
end

function var11_0.AddBaseAttr(arg0_3, arg1_3, arg2_3)
	arg0_3._attrList[arg1_3] = math.max(0, arg2_3 + (arg0_3._attrList[arg1_3] or 0))
	arg0_3._attrList[arg1_3] = arg0_3:checkClamp(arg1_3)

	arg0_3._client:DispatchUpdateAttr(arg1_3)
	arg0_3:specificAttrUpdate(arg1_3)
end

function var11_0.SetAttr(arg0_4, arg1_4, arg2_4)
	arg0_4._attrList[arg1_4] = arg2_4
	arg0_4._attrList[arg1_4] = arg0_4:checkClamp(arg1_4)

	arg0_4._client:DispatchUpdateAttr(arg1_4)
	arg0_4:specificAttrUpdate(arg1_4)
end

function var11_0.specificAttrUpdate(arg0_5, arg1_5)
	if arg1_5 == "BaseEnergyBoostRate" or arg1_5 == "BaseEnergyBoostExtra" then
		arg0_5._client:FlushHandOverheat()
	end
end

function var11_0.checkClamp(arg0_6, arg1_6)
	if arg0_6._attrList[arg1_6] == nil then
		return
	end

	local var0_6 = arg0_6._attrList[arg1_6]
	local var1_6 = var7_0.FleetAttrClamp[arg1_6]

	if var1_6 then
		local var2_6 = arg0_6._attrList[var1_6.max]
		local var3_6 = arg0_6._attrList[var1_6.min] or 0

		var0_6 = math.max(var0_6, var3_6)
		var0_6 = var2_6 and math.min(var0_6, var2_6) or var0_6
	end

	return var0_6
end

function var11_0.GetCurrent(arg0_7, arg1_7)
	return arg0_7._attrList[arg1_7] or 0
end
