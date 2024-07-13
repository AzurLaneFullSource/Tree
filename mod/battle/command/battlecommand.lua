ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleCommand = class("BattleCommand", var0_0.MVC.Command)
var0_0.Battle.BattleCommand.__name = "BattleCommand"

function var0_0.Battle.BattleCommand.Ctor(arg0_1)
	var0_0.Battle.BattleCommand.super.Ctor(arg0_1)
end

function var0_0.Battle.BattleCommand.Initialize(arg0_2)
	var0_0.Battle.BattleCommand.super.Initialize(arg0_2)

	arg0_2._dataProxy = arg0_2._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)

	arg0_2:InitProtocol()
	arg0_2:InitBattleEvent()
end

function var0_0.Battle.BattleCommand.StartBattle(arg0_3)
	arg0_3._state:Active()
end

function var0_0.Battle.BattleCommand.InitProtocol(arg0_4)
	return
end

function var0_0.Battle.BattleCommand.InitBattleEvent(arg0_5)
	return
end
