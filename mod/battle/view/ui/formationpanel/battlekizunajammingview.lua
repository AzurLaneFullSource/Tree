ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = class("BattleKizunaJammingView")

var0.Battle.BattleKizunaJammingView = var2
var2.__name = "BattleKizunaJammingView"
var2.COUNT = 3
var2.EXPAND_DURATION = 5

function var2.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._hitCount = 0
end

function var2.ConfigCallback(arg0, arg1)
	arg0._callback = arg1

	arg0:init()
end

function var2.init(arg0)
	arg0.eventTriggers = {}
	arg0._blocker = arg0._tf:Find("KizunaAiBlocker")

	local var0 = GetOrAddComponent(arg0._blocker, "EventTriggerListener")

	arg0.eventTriggers[var0] = true

	var0:AddPointDownFunc(function()
		arg0._hitCount = arg0._hitCount + 1

		if arg0._hitCount >= var2.COUNT then
			arg0:Eliminate(true)
		else
			setActive(arg0._blocker:Find("normal"), false)
			setActive(arg0._blocker:Find("hitted"), true)
			LeanTween.cancel(go(arg0._blocker))
			arg0:ClickEase()
		end
	end)
	var0:AddPointUpFunc(function()
		if arg0._hitCount < var2.COUNT then
			setActive(arg0._blocker:Find("normal"), true)
			setActive(arg0._blocker:Find("hitted"), false)
		end
	end)
end

function var2.Active(arg0)
	local var0 = (1 - arg0._blocker.localScale.x) * var2.EXPAND_DURATION

	LeanTween.scale(arg0._blocker, Vector3(1, 1, 0), var0)
end

function var2.Puase(arg0)
	LeanTween.cancel(go(arg0._blocker))
end

function var2.ClickEase(arg0)
	local var0 = arg0._blocker.localScale.x - 0.05

	LeanTween.scale(arg0._blocker, Vector3(var0, var0, 0), 0.03):setOnComplete(System.Action(function()
		arg0:Active()
	end))
end

function var2.Eliminate(arg0, arg1)
	LeanTween.cancel(go(arg0._blocker))
	setActive(arg0._blocker:Find("normal"), not arg1)
	setActive(arg0._blocker:Find("hitted"), arg1)
	LeanTween.scale(arg0._blocker, Vector3(0, 0, 0), 0.1):setOnComplete(System.Action(function()
		arg0._callback()
	end))
end

function var2.Dispose(arg0)
	if arg0.eventTriggers then
		for iter0, iter1 in pairs(arg0.eventTriggers) do
			ClearEventTrigger(iter0)
		end

		arg0.eventTriggers = nil
	end

	LeanTween.cancel(go(arg0._blocker))
end
