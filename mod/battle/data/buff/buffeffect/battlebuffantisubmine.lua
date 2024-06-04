ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAntiSubMine", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAntiSubMine = var1
var1.__name = "BattleBuffAntiSubMine"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onAttach(arg0, arg1)
	arg1:InitOxygen()
	arg1:ChangeOxygenState(var0.Battle.OxyState.STATE_DEEP_MINE)
end
