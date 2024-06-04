ys = ys or {}

local var0 = ys
local var1 = class("BattleCardPuzzleFleetBuffAddBuff", var0.Battle.BattleFleetBuffEffect)

var0.Battle.BattleCardPuzzleFleetBuffAddBuff = var1
var1.__name = "BattleCardPuzzleFleetBuffAddBuff"

function var1.Ctor(arg0, arg1)
	arg0._tempData = Clone(arg1)

	arg0:SetActive()
end

function var1.SetArgs(arg0, arg1, arg2)
	var1.super.SetArgs(arg0, arg1, arg2)

	arg0._buffID = arg0._tempData.arg_list.buff_id
	arg0._targetFilter = arg0._tempData.arg_list.target
	arg0._targetParam = arg0._tempData.arg_list.target_param

	local var0 = arg0._tempData.arg_list.caster or TeamType.TeamPos.LEADER

	arg0._caster = var0.Battle.BattleTargetChoise.TargetFleetIndex(nil, {
		fleetPos = var0
	})[1]
end

function var1.onTrigger(arg0)
	local var0 = {}
	local var1 = arg0._targetParam

	for iter0, iter1 in ipairs(arg0._targetFilter) do
		var0 = var0.Battle.BattleTargetChoise[iter1](arg0._caster, var1, var0)
	end

	for iter2, iter3 in ipairs(var0) do
		local var2 = var0.Battle.BattleBuffUnit.New(arg0._buffID)

		iter3:AddBuff(var2)
	end
end
