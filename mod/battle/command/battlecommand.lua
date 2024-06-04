ys = ys or {}

local var0 = ys

var0.Battle.BattleCommand = class("BattleCommand", var0.MVC.Command)
var0.Battle.BattleCommand.__name = "BattleCommand"

function var0.Battle.BattleCommand.Ctor(arg0)
	var0.Battle.BattleCommand.super.Ctor(arg0)
end

function var0.Battle.BattleCommand.Initialize(arg0)
	var0.Battle.BattleCommand.super.Initialize(arg0)

	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)

	arg0:InitProtocol()
	arg0:InitBattleEvent()
end

function var0.Battle.BattleCommand.StartBattle(arg0)
	arg0._state:Active()
end

function var0.Battle.BattleCommand.InitProtocol(arg0)
	return
end

function var0.Battle.BattleCommand.InitBattleEvent(arg0)
	return
end
