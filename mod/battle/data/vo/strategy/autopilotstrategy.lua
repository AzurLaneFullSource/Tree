ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.AutoPilotStrategy = class("AutoPilotStrategy", var0_0.Battle.BattleJoyStickBotBaseStrategy)

local var3_0 = var0_0.Battle.AutoPilotStrategy

var3_0.__name = "AutoPilotStrategy"
var3_0.FIX_FRONT = 0.5

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)

	local var0_1 = arg1_1:GetMotionReferenceUnit()
	local var1_1 = arg1_1:GetAutoBotAIID()
	local var2_1 = var0_0.Battle.BattleDataFunction.GetAITmpDataFromID(var1_1)

	arg0_1._autoPilot = var0_0.Battle.AutoPilot.New(var0_1, var2_1)
end

function var3_0.GetStrategyType(arg0_2)
	return var0_0.Battle.BattleJoyStickAutoBot.AUTO_PILOT
end

function var3_0.analysis(arg0_3)
	local var0_3 = arg0_3._autoPilot:GetDirection()

	arg0_3._hrz = var0_3.x
	arg0_3._vtc = var0_3.z
end
