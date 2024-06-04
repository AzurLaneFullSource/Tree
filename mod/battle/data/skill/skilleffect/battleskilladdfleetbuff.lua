ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.BattleSkillAddFleetBuff = class("BattleSkillAddFleetBuff", var0.Battle.BattleSkillEffect)
var0.Battle.BattleSkillAddFleetBuff.__name = "BattleSkillAddFleetBuff"

local var2 = var0.Battle.BattleSkillAddFleetBuff

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)

	arg0._fleetBuffID = arg0._tempData.arg_list.fleet_buff_id
end

function var2.DoDataEffect(arg0, arg1, arg2)
	if arg2:IsAlive() and arg2:GetUnitType() == var1.UnitType.PLAYER_UNIT then
		local var0 = var0.Battle.BattleFleetBuffUnit.New(arg0._fleetBuffID)

		arg2:GetFleetVO():AttachFleetBuff(var0)
	end
end
