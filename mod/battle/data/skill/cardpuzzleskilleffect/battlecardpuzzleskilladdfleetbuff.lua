ys = ys or {}

local var0 = ys
local var1 = class("BattleCardPuzzleSkillAddFleetBuff", var0.Battle.BattleCardPuzzleSkillEffect)

var0.Battle.BattleCardPuzzleSkillAddFleetBuff = var1
var1.__name = "BattleCardPuzzleSkillAddFleetBuff"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._fleetBuffID = arg0._tempData.arg_list.fleet_buff_id
	arg0._initStack = arg0._tempData.arg_list.init_stack or 1
end

function var1.SkillEffectHandler(arg0)
	local var0 = arg0:GetCardPuzzleComponent():GetBuffManager()
	local var1 = var0.Battle.BattleFleetBuffUnit.New(arg0._fleetBuffID)

	var0:AttachCardPuzzleBuff(var1)
	arg0:Finale()
end
