ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.IdleStrategy = class("IdleStrategy", var0_0.Battle.BattleJoyStickBotBaseStrategy)

local var3_0 = var0_0.Battle.IdleStrategy

var3_0.__name = "IdleStrategy"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.GetStrategyType(arg0_2)
	return var0_0.Battle.BattleJoyStickAutoBot.IDLE
end

function var3_0.analysis(arg0_3)
	arg0_3._hrz = 0
	arg0_3._vtc = 0
end
