ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleBuffAddFleetBuff", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddFleetBuff = var2_0
var2_0.__name = "BattleBuffAddFleetBuff"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1)
end

function var2_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._level = arg2_2:GetLv()
	arg0_2._fleetBuffID = arg0_2._tempData.arg_list.fleet_buff_id
end

function var2_0.onAttach(arg0_3, arg1_3, arg2_3)
	if arg1_3:GetUnitType() ~= var1_0.UnitType.PLAYER_UNIT then
		return
	end

	local var0_3 = var0_0.Battle.BattleFleetBuffUnit.New(arg0_3._fleetBuffID)

	arg1_3:GetFleetVO():AttachFleetBuff(var0_3)
end

function var2_0.onRemove(arg0_4, arg1_4, arg2_4)
	if arg1_4:GetUnitType() ~= var1_0.UnitType.PLAYER_UNIT then
		return
	end

	arg1_4:GetFleetVO():RemoveFleetBuff(arg0_4._fleetBuffID)
end
