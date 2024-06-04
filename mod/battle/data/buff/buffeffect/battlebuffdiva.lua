ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffDiva", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffDiva = var1
var1.__name = "BattleBuffDiva"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.onInitGame(arg0, arg1, arg2)
	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetBGMList()
	local var1 = var0[math.random(#var0)]

	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, var1)
end

function var1.onTrigger(arg0)
	local var0 = var0.Battle.BattleDataProxy.GetInstance():GetBGMList(true)
	local var1 = var0[math.random(#var0)]

	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, var1)
end
