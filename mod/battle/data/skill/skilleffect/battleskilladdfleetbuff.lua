ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.BattleSkillAddFleetBuff = class("BattleSkillAddFleetBuff", var0_0.Battle.BattleSkillEffect)
var0_0.Battle.BattleSkillAddFleetBuff.__name = "BattleSkillAddFleetBuff"

local var2_0 = var0_0.Battle.BattleSkillAddFleetBuff

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._fleetBuffID = arg0_1._tempData.arg_list.fleet_buff_id
end

function var2_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg2_2:IsAlive() and arg2_2:GetUnitType() == var1_0.UnitType.PLAYER_UNIT then
		local var0_2 = var0_0.Battle.BattleFleetBuffUnit.New(arg0_2._fleetBuffID)

		arg2_2:GetFleetVO():AttachFleetBuff(var0_2)
	end
end
