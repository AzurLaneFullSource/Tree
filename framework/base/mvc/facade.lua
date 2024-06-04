ys = ys or {}

local var0 = ys
local var1 = pg

var0.MVC = var0.MVC or {}
var0.MVC.Facade = singletonClass("MVC.Facade")
var0.MVC.Facade.__name = "MVC.Facade"

function var0.MVC.Facade.Ctor(arg0)
	arg0:Initialize()
end

function var0.MVC.Facade.AddDataProxy(arg0, arg1)
	assert(arg1.__name ~= nil and type(arg1.__name) == "string", arg0.__name .. ".AddDataProxy: dataProxy.__name expected a string value")
	assert(arg0._proxyList[arg1.__name] == nil, arg0.__name .. ".AddDataProxy: same dataProxy exist")

	arg1._state = arg0

	arg1:ActiveProxy()

	arg0._proxyList[arg1.__name] = arg1

	return arg1
end

function var0.MVC.Facade.AddMediator(arg0, arg1)
	if arg1.__name == nil or type(arg1.__name) ~= "string" then
		assert(false, arg0.__name .. ".AddMediator: mediator.__name expected a string value")
	end

	assert(arg0._mediatorList[arg1.__name] == nil, arg0.__name .. ".AddMediator: same mediator exist")

	arg0._mediatorList[arg1.__name] = arg1
	arg1._state = arg0

	arg1:Initialize()

	return arg1
end

function var0.MVC.Facade.AddCommand(arg0, arg1)
	if arg1.__name == nil or type(arg1.__name) ~= "string" then
		assert(false, arg0.__name .. ".AddCommand: command.__name expected a string value")
	end

	assert(arg0._commandList[arg1.__name] == nil, arg0.__name .. ".AddCommand: same command exist")

	arg0._commandList[arg1.__name] = arg1
	arg1._state = arg0

	arg1:Initialize()

	return arg1
end

function var0.MVC.Facade.GetProxyByName(arg0, arg1)
	assert(type(arg1) == "string", arg0.__name .. ".GetProxyByName: expect a string value")

	return arg0._proxyList[arg1]
end

function var0.MVC.Facade.GetMediatorByName(arg0, arg1)
	assert(type(arg1) == "string", arg0.__name .. ".GetMediatorByName: expect a string value")

	return arg0._mediatorList[arg1]
end

function var0.MVC.Facade.GetCommandByName(arg0, arg1)
	assert(type(arg1) == "string", arg0.__name .. ".GetCommandByName: expect a string value")

	return arg0._commandList[arg1]
end

function var0.MVC.Facade.RemoveMediator(arg0, arg1)
	if type(arg1) == "string" then
		arg1 = arg0._mediatorList[arg1]
	end

	assert(arg1 ~= nil, arg0.__name .. ".RemoveMediator: try to remove a nil mediator")
	arg1:Dispose()

	arg0._mediatorList[arg1.__name] = nil
end

function var0.MVC.Facade.RemoveCommand(arg0, arg1)
	if type(arg1) == "string" then
		arg1 = arg0._commandList[arg1]
	end

	assert(arg1 ~= nil, arg0.__name .. ".RemoveCommand: try to remove a nil command")
	arg1:Dispose()

	arg0._commandList[arg1.__name] = nil
end

function var0.MVC.Facade.RemoveProxy(arg0, arg1)
	if type(arg1) == "string" then
		arg1 = arg0._proxyList[arg1]
	end

	assert(arg1 ~= nil, arg0.__name .. ".RemoveProxy: try to remove a nil proxy")
	arg1:DeactiveProxy()

	arg0._proxyList[arg1.__name] = nil
end

function var0.MVC.Facade.Initialize(arg0)
	arg0._proxyList = {}
	arg0._commandList = {}
	arg0._mediatorList = {}
end

function var0.MVC.Facade.Active(arg0)
	if not arg0._isPause then
		return
	end

	arg0._isPause = false

	var1.TimeMgr.GetInstance():ResumeBattleTimer()
end

function var0.MVC.Facade.Deactive(arg0)
	if arg0._isPause then
		return
	end

	arg0._isPause = true

	var1.TimeMgr.GetInstance():PauseBattleTimer()
end

function var0.MVC.Facade.ActiveEscape(arg0)
	arg0._escapeAITimer = var1.TimeMgr.GetInstance():AddTimer("escapeTimer", 0, var0.Battle.BattleConfig.viewInterval, function()
		arg0:escapeUpdate()
	end)
end

function var0.MVC.Facade.DeactiveEscape(arg0)
	var1.TimeMgr.GetInstance():RemoveTimer(arg0._escapeAITimer)
end

function var0.MVC.Facade.RemoveAllTimer(arg0)
	var1.TimeMgr.GetInstance():RemoveAllBattleTimer()

	arg0._calcTimer = nil
	arg0._AITimer = nil
end

function var0.MVC.Facade.ResetTimer(arg0)
	local var0 = var1.TimeMgr.GetInstance()

	var0:ResetCombatTime()
	var0:RemoveBattleTimer(arg0._calcTimer)
	var0:RemoveBattleTimer(arg0._AITimer)

	arg0._calcTimer = var0:AddBattleTimer("calcTimer", -1, var0.Battle.BattleConfig.calcInterval, function()
		arg0:calcUpdate()
	end)
end

function var0.MVC.Facade.ActiveAutoComponentTimer(arg0)
	arg0._AITimer = var1.TimeMgr.GetInstance():AddBattleTimer("aiTimer", -1, var0.Battle.BattleConfig.AIInterval, function()
		arg0:aiUpdate()
	end)
end

function var0.MVC.Facade.calcUpdate(arg0)
	local var0 = var1.TimeMgr.GetInstance():GetCombatTime()

	for iter0, iter1 in pairs(arg0._proxyList) do
		iter1:Update(var0)
	end

	for iter2, iter3 in pairs(arg0._commandList) do
		iter3:Update(var0)
	end
end

function var0.MVC.Facade.aiUpdate(arg0)
	arg0:GetProxyByName(var0.Battle.BattleDataProxy.__name):UpdateAutoComponent(var1.TimeMgr.GetInstance():GetCombatTime())
end

function var0.MVC.Facade.escapeUpdate(arg0)
	local var0 = arg0:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	local var1 = var1.TimeMgr.GetInstance():GetCombatTime()

	var0:UpdateEscapeOnly(var1)
	arg0:GetMediatorByName(var0.Battle.BattleSceneMediator.__name):UpdateEscapeOnly(var1)
end
