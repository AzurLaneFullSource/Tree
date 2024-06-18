ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = var0_0.Battle.BattleConst
local var3_0 = class("BattleCardPuzzleSkillMoveTo", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillMoveTo = var3_0
var3_0.__name = "BattleCardPuzzleSkillMoveTo"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
end

function var3_0.HoldForInput(arg0_2)
	return false
end

function var3_0.SkillEffectHandler(arg0_3)
	local var0_3 = arg0_3._card:GetInputPoint()
	local var1_3 = arg0_3:GetCardPuzzleComponent():TakeoverMovecontroller(var0_3, function()
		arg0_3:Finale()
	end)
end

function var3_0.Finale(arg0_5)
	var3_0.super.Finale(arg0_5)
	arg0_5:GetCardPuzzleComponent():ReturnMovecontroller()
end
