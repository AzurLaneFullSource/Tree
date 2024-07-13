ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffDiva", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffDiva = var1_0
var1_0.__name = "BattleBuffDiva"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.onInitGame(arg0_2, arg1_2, arg2_2)
	local var0_2 = var0_0.Battle.BattleDataProxy.GetInstance():GetBGMList()
	local var1_2 = var0_2[math.random(#var0_2)]

	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, var1_2)
end

function var1_0.onTrigger(arg0_3)
	local var0_3 = var0_0.Battle.BattleDataProxy.GetInstance():GetBGMList(true)
	local var1_3 = var0_3[math.random(#var0_3)]

	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, var1_3)
end
