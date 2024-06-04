ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleConst
local var3 = class("BattleCardPuzzleSkillMoveTo", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillMoveTo = var3
var3.__name = "BattleCardPuzzleSkillMoveTo"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
end

function var3.HoldForInput(arg0)
	return false
end

function var3.SkillEffectHandler(arg0)
	local var0 = arg0._card:GetInputPoint()
	local var1 = arg0:GetCardPuzzleComponent():TakeoverMovecontroller(var0, function()
		arg0:Finale()
	end)
end

function var3.Finale(arg0)
	var3.super.Finale(arg0)
	arg0:GetCardPuzzleComponent():ReturnMovecontroller()
end
