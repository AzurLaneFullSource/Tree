ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCardPuzzleSkillAddFleetBuff", var0_0.Battle.BattleCardPuzzleSkillEffect)

var0_0.Battle.BattleCardPuzzleSkillAddFleetBuff = var1_0
var1_0.__name = "BattleCardPuzzleSkillAddFleetBuff"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._fleetBuffID = arg0_1._tempData.arg_list.fleet_buff_id
	arg0_1._initStack = arg0_1._tempData.arg_list.init_stack or 1
end

function var1_0.SkillEffectHandler(arg0_2)
	local var0_2 = arg0_2:GetCardPuzzleComponent():GetBuffManager()
	local var1_2 = var0_0.Battle.BattleFleetBuffUnit.New(arg0_2._fleetBuffID)

	var0_2:AttachCardPuzzleBuff(var1_2)
	arg0_2:Finale()
end
