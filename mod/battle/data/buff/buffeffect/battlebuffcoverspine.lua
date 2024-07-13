ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffCoverSpine = class("BattleBuffCoverSpine", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffCoverSpine.__name = "BattleBuffCoverSpine"

local var1_0 = var0_0.Battle.BattleBuffCoverSpine

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._skin = arg0_2._tempData.arg_list.ship_skin_id
	arg0_2._hpbarOffset = arg0_2._tempData.arg_list.hp_bar_offset or 0
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3, arg3_3)
	arg1_3:SwitchSpine(arg0_3._skin, arg0_3._hpbarOffset)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4, arg3_4)
	arg1_4:SwitchSpine(nil, arg0_4._hpbarOffset * -1)
end
