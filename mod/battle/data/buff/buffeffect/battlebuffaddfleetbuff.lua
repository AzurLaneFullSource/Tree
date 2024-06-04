ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleBuffAddFleetBuff", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddFleetBuff = var2
var2.__name = "BattleBuffAddFleetBuff"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1)
end

function var2.SetArgs(arg0, arg1, arg2)
	arg0._level = arg2:GetLv()
	arg0._fleetBuffID = arg0._tempData.arg_list.fleet_buff_id
end

function var2.onAttach(arg0, arg1, arg2)
	if arg1:GetUnitType() ~= var1.UnitType.PLAYER_UNIT then
		return
	end

	local var0 = var0.Battle.BattleFleetBuffUnit.New(arg0._fleetBuffID)

	arg1:GetFleetVO():AttachFleetBuff(var0)
end

function var2.onRemove(arg0, arg1, arg2)
	if arg1:GetUnitType() ~= var1.UnitType.PLAYER_UNIT then
		return
	end

	arg1:GetFleetVO():RemoveFleetBuff(arg0._fleetBuffID)
end
