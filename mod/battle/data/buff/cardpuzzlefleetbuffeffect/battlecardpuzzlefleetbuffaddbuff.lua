ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleCardPuzzleFleetBuffAddBuff", var0_0.Battle.BattleFleetBuffEffect)

var0_0.Battle.BattleCardPuzzleFleetBuffAddBuff = var1_0
var1_0.__name = "BattleCardPuzzleFleetBuffAddBuff"

function var1_0.Ctor(arg0_1, arg1_1)
	arg0_1._tempData = Clone(arg1_1)

	arg0_1:SetActive()
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	var1_0.super.SetArgs(arg0_2, arg1_2, arg2_2)

	arg0_2._buffID = arg0_2._tempData.arg_list.buff_id
	arg0_2._targetFilter = arg0_2._tempData.arg_list.target
	arg0_2._targetParam = arg0_2._tempData.arg_list.target_param

	local var0_2 = arg0_2._tempData.arg_list.caster or TeamType.TeamPos.LEADER

	arg0_2._caster = var0_0.Battle.BattleTargetChoise.TargetFleetIndex(nil, {
		fleetPos = var0_2
	})[1]
end

function var1_0.onTrigger(arg0_3)
	local var0_3 = {}
	local var1_3 = arg0_3._targetParam

	for iter0_3, iter1_3 in ipairs(arg0_3._targetFilter) do
		var0_3 = var0_0.Battle.BattleTargetChoise[iter1_3](arg0_3._caster, var1_3, var0_3)
	end

	for iter2_3, iter3_3 in ipairs(var0_3) do
		local var2_3 = var0_0.Battle.BattleBuffUnit.New(arg0_3._buffID)

		iter3_3:AddBuff(var2_3)
	end
end
