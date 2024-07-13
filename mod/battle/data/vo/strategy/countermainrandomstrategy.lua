ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CounterMainRandomStrategy = class("CounterMainRandomStrategy", var0_0.Battle.RandomStrategy)

local var3_0 = var0_0.Battle.CounterMainRandomStrategy

var3_0.__name = "CounterMainRandomStrategy"
var3_0.FIX_FRONT = 0.5

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.GetStrategyType(arg0_2)
	return var0_0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN
end

function var3_0.generateTargetPoint(arg0_3)
	local var0_3 = arg0_3._upperBound
	local var1_3 = arg0_3._lowerBound

	for iter0_3, iter1_3 in pairs(arg0_3._foeShipList) do
		local var2_3 = iter1_3:GetPosition().z

		var0_3 = math.min(var2_3, var0_3)
		var1_3 = math.max(var2_3, var1_3)
	end

	local var3_3 = arg0_3._fleetVO:GetLeaderPersonality()
	local var4_3 = var3_0.FIX_FRONT
	local var5_3 = var3_3.rear_rate

	if arg0_3._fleetVO:GetIFF() == var2_0.FRIENDLY_CODE then
		var4_3 = 1 - var4_3
		var5_3 = 1 - var5_3
	end

	local var6_3 = arg0_3._totalWidth * var4_3 + arg0_3._leftBound
	local var7_3 = arg0_3._totalWidth * var5_3 + arg0_3._leftBound
	local var8_3 = arg0_3._totalHeight * var3_3.upper_rate + arg0_3._lowerBound
	local var9_3 = arg0_3._totalHeight * var3_3.lower_rate + arg0_3._lowerBound
	local var10_3 = math.min(var0_3, var8_3)
	local var11_3 = math.max(var1_3, var9_3)
	local var12_3
	local var13_3 = math.random(var7_3, var6_3)
	local var14_3 = math.random(var11_3, var10_3)

	return (Vector3(var13_3, 0, var14_3))
end
