ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAntiSubMine", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAntiSubMine = var1_0
var1_0.__name = "BattleBuffAntiSubMine"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.onAttach(arg0_2, arg1_2)
	arg1_2:InitOxygen()
	arg1_2:ChangeOxygenState(var0_0.Battle.OxyState.STATE_DEEP_MINE)
end
