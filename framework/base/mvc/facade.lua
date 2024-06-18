ys = ys or {}

local var0_0 = ys
local var1_0 = pg

var0_0.MVC = var0_0.MVC or {}
var0_0.MVC.Facade = singletonClass("MVC.Facade")
var0_0.MVC.Facade.__name = "MVC.Facade"

function var0_0.MVC.Facade.Ctor(arg0_1)
	arg0_1:Initialize()
end

function var0_0.MVC.Facade.AddDataProxy(arg0_2, arg1_2)
	assert(arg1_2.__name ~= nil and type(arg1_2.__name) == "string", arg0_2.__name .. ".AddDataProxy: dataProxy.__name expected a string value")
	assert(arg0_2._proxyList[arg1_2.__name] == nil, arg0_2.__name .. ".AddDataProxy: same dataProxy exist")

	arg1_2._state = arg0_2

	arg1_2:ActiveProxy()

	arg0_2._proxyList[arg1_2.__name] = arg1_2

	return arg1_2
end

function var0_0.MVC.Facade.AddMediator(arg0_3, arg1_3)
	if arg1_3.__name == nil or type(arg1_3.__name) ~= "string" then
		assert(false, arg0_3.__name .. ".AddMediator: mediator.__name expected a string value")
	end

	assert(arg0_3._mediatorList[arg1_3.__name] == nil, arg0_3.__name .. ".AddMediator: same mediator exist")

	arg0_3._mediatorList[arg1_3.__name] = arg1_3
	arg1_3._state = arg0_3

	arg1_3:Initialize()

	return arg1_3
end

function var0_0.MVC.Facade.AddCommand(arg0_4, arg1_4)
	if arg1_4.__name == nil or type(arg1_4.__name) ~= "string" then
		assert(false, arg0_4.__name .. ".AddCommand: command.__name expected a string value")
	end

	assert(arg0_4._commandList[arg1_4.__name] == nil, arg0_4.__name .. ".AddCommand: same command exist")

	arg0_4._commandList[arg1_4.__name] = arg1_4
	arg1_4._state = arg0_4

	arg1_4:Initialize()

	return arg1_4
end

function var0_0.MVC.Facade.GetProxyByName(arg0_5, arg1_5)
	assert(type(arg1_5) == "string", arg0_5.__name .. ".GetProxyByName: expect a string value")

	return arg0_5._proxyList[arg1_5]
end

function var0_0.MVC.Facade.GetMediatorByName(arg0_6, arg1_6)
	assert(type(arg1_6) == "string", arg0_6.__name .. ".GetMediatorByName: expect a string value")

	return arg0_6._mediatorList[arg1_6]
end

function var0_0.MVC.Facade.GetCommandByName(arg0_7, arg1_7)
	assert(type(arg1_7) == "string", arg0_7.__name .. ".GetCommandByName: expect a string value")

	return arg0_7._commandList[arg1_7]
end

function var0_0.MVC.Facade.RemoveMediator(arg0_8, arg1_8)
	if type(arg1_8) == "string" then
		arg1_8 = arg0_8._mediatorList[arg1_8]
	end

	assert(arg1_8 ~= nil, arg0_8.__name .. ".RemoveMediator: try to remove a nil mediator")
	arg1_8:Dispose()

	arg0_8._mediatorList[arg1_8.__name] = nil
end

function var0_0.MVC.Facade.RemoveCommand(arg0_9, arg1_9)
	if type(arg1_9) == "string" then
		arg1_9 = arg0_9._commandList[arg1_9]
	end

	assert(arg1_9 ~= nil, arg0_9.__name .. ".RemoveCommand: try to remove a nil command")
	arg1_9:Dispose()

	arg0_9._commandList[arg1_9.__name] = nil
end

function var0_0.MVC.Facade.RemoveProxy(arg0_10, arg1_10)
	if type(arg1_10) == "string" then
		arg1_10 = arg0_10._proxyList[arg1_10]
	end

	assert(arg1_10 ~= nil, arg0_10.__name .. ".RemoveProxy: try to remove a nil proxy")
	arg1_10:DeactiveProxy()

	arg0_10._proxyList[arg1_10.__name] = nil
end

function var0_0.MVC.Facade.Initialize(arg0_11)
	arg0_11._proxyList = {}
	arg0_11._commandList = {}
	arg0_11._mediatorList = {}
end

function var0_0.MVC.Facade.Active(arg0_12)
	if not arg0_12._isPause then
		return
	end

	arg0_12._isPause = false

	var1_0.TimeMgr.GetInstance():ResumeBattleTimer()
end

function var0_0.MVC.Facade.Deactive(arg0_13)
	if arg0_13._isPause then
		return
	end

	arg0_13._isPause = true

	var1_0.TimeMgr.GetInstance():PauseBattleTimer()
end

function var0_0.MVC.Facade.ActiveEscape(arg0_14)
	arg0_14._escapeAITimer = var1_0.TimeMgr.GetInstance():AddTimer("escapeTimer", 0, var0_0.Battle.BattleConfig.viewInterval, function()
		arg0_14:escapeUpdate()
	end)
end

function var0_0.MVC.Facade.DeactiveEscape(arg0_16)
	var1_0.TimeMgr.GetInstance():RemoveTimer(arg0_16._escapeAITimer)
end

function var0_0.MVC.Facade.RemoveAllTimer(arg0_17)
	var1_0.TimeMgr.GetInstance():RemoveAllBattleTimer()

	arg0_17._calcTimer = nil
	arg0_17._AITimer = nil
end

function var0_0.MVC.Facade.ResetTimer(arg0_18)
	local var0_18 = var1_0.TimeMgr.GetInstance()

	var0_18:ResetCombatTime()
	var0_18:RemoveBattleTimer(arg0_18._calcTimer)
	var0_18:RemoveBattleTimer(arg0_18._AITimer)

	arg0_18._calcTimer = var0_18:AddBattleTimer("calcTimer", -1, var0_0.Battle.BattleConfig.calcInterval, function()
		arg0_18:calcUpdate()
	end)
end

function var0_0.MVC.Facade.ActiveAutoComponentTimer(arg0_20)
	arg0_20._AITimer = var1_0.TimeMgr.GetInstance():AddBattleTimer("aiTimer", -1, var0_0.Battle.BattleConfig.AIInterval, function()
		arg0_20:aiUpdate()
	end)
end

function var0_0.MVC.Facade.calcUpdate(arg0_22)
	local var0_22 = var1_0.TimeMgr.GetInstance():GetCombatTime()

	for iter0_22, iter1_22 in pairs(arg0_22._proxyList) do
		iter1_22:Update(var0_22)
	end

	for iter2_22, iter3_22 in pairs(arg0_22._commandList) do
		iter3_22:Update(var0_22)
	end
end

function var0_0.MVC.Facade.aiUpdate(arg0_23)
	arg0_23:GetProxyByName(var0_0.Battle.BattleDataProxy.__name):UpdateAutoComponent(var1_0.TimeMgr.GetInstance():GetCombatTime())
end

function var0_0.MVC.Facade.escapeUpdate(arg0_24)
	local var0_24 = arg0_24:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	local var1_24 = var1_0.TimeMgr.GetInstance():GetCombatTime()

	var0_24:UpdateEscapeOnly(var1_24)
	arg0_24:GetMediatorByName(var0_0.Battle.BattleSceneMediator.__name):UpdateEscapeOnly(var1_24)
end
