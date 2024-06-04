ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffCoverSpine = class("BattleBuffCoverSpine", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffCoverSpine.__name = "BattleBuffCoverSpine"

local var1 = var0.Battle.BattleBuffCoverSpine

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._skin = arg0._tempData.arg_list.ship_skin_id
	arg0._hpbarOffset = arg0._tempData.arg_list.hp_bar_offset or 0
end

function var1.onAttach(arg0, arg1, arg2, arg3)
	arg1:SwitchSpine(arg0._skin, arg0._hpbarOffset)
end

function var1.onRemove(arg0, arg1, arg2, arg3)
	arg1:SwitchSpine(nil, arg0._hpbarOffset * -1)
end
