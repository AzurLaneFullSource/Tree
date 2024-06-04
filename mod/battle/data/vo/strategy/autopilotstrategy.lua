ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConfig

var0.Battle.AutoPilotStrategy = class("AutoPilotStrategy", var0.Battle.BattleJoyStickBotBaseStrategy)

local var3 = var0.Battle.AutoPilotStrategy

var3.__name = "AutoPilotStrategy"
var3.FIX_FRONT = 0.5

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)

	local var0 = arg1:GetMotionReferenceUnit()
	local var1 = arg1:GetAutoBotAIID()
	local var2 = var0.Battle.BattleDataFunction.GetAITmpDataFromID(var1)

	arg0._autoPilot = var0.Battle.AutoPilot.New(var0, var2)
end

function var3.GetStrategyType(arg0)
	return var0.Battle.BattleJoyStickAutoBot.AUTO_PILOT
end

function var3.analysis(arg0)
	local var0 = arg0._autoPilot:GetDirection()

	arg0._hrz = var0.x
	arg0._vtc = var0.z
end
