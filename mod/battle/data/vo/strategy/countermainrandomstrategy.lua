ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConfig

var0.Battle.CounterMainRandomStrategy = class("CounterMainRandomStrategy", var0.Battle.RandomStrategy)

local var3 = var0.Battle.CounterMainRandomStrategy

var3.__name = "CounterMainRandomStrategy"
var3.FIX_FRONT = 0.5

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
end

function var3.GetStrategyType(arg0)
	return var0.Battle.BattleJoyStickAutoBot.COUNTER_MAIN
end

function var3.generateTargetPoint(arg0)
	local var0 = arg0._upperBound
	local var1 = arg0._lowerBound

	for iter0, iter1 in pairs(arg0._foeShipList) do
		local var2 = iter1:GetPosition().z

		var0 = math.min(var2, var0)
		var1 = math.max(var2, var1)
	end

	local var3 = arg0._fleetVO:GetLeaderPersonality()
	local var4 = var3.FIX_FRONT
	local var5 = var3.rear_rate

	if arg0._fleetVO:GetIFF() == var2.FRIENDLY_CODE then
		var4 = 1 - var4
		var5 = 1 - var5
	end

	local var6 = arg0._totalWidth * var4 + arg0._leftBound
	local var7 = arg0._totalWidth * var5 + arg0._leftBound
	local var8 = arg0._totalHeight * var3.upper_rate + arg0._lowerBound
	local var9 = arg0._totalHeight * var3.lower_rate + arg0._lowerBound
	local var10 = math.min(var0, var8)
	local var11 = math.max(var1, var9)
	local var12
	local var13 = math.random(var7, var6)
	local var14 = math.random(var11, var10)

	return (Vector3(var13, 0, var14))
end
