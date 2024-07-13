ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = class("BattleKizunaJammingView")

var0_0.Battle.BattleKizunaJammingView = var2_0
var2_0.__name = "BattleKizunaJammingView"
var2_0.COUNT = 3
var2_0.EXPAND_DURATION = 5

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._hitCount = 0
end

function var2_0.ConfigCallback(arg0_2, arg1_2)
	arg0_2._callback = arg1_2

	arg0_2:init()
end

function var2_0.init(arg0_3)
	arg0_3.eventTriggers = {}
	arg0_3._blocker = arg0_3._tf:Find("KizunaAiBlocker")

	local var0_3 = GetOrAddComponent(arg0_3._blocker, "EventTriggerListener")

	arg0_3.eventTriggers[var0_3] = true

	var0_3:AddPointDownFunc(function()
		arg0_3._hitCount = arg0_3._hitCount + 1

		if arg0_3._hitCount >= var2_0.COUNT then
			arg0_3:Eliminate(true)
		else
			setActive(arg0_3._blocker:Find("normal"), false)
			setActive(arg0_3._blocker:Find("hitted"), true)
			LeanTween.cancel(go(arg0_3._blocker))
			arg0_3:ClickEase()
		end
	end)
	var0_3:AddPointUpFunc(function()
		if arg0_3._hitCount < var2_0.COUNT then
			setActive(arg0_3._blocker:Find("normal"), true)
			setActive(arg0_3._blocker:Find("hitted"), false)
		end
	end)
end

function var2_0.Active(arg0_6)
	local var0_6 = (1 - arg0_6._blocker.localScale.x) * var2_0.EXPAND_DURATION

	LeanTween.scale(arg0_6._blocker, Vector3(1, 1, 0), var0_6)
end

function var2_0.Puase(arg0_7)
	LeanTween.cancel(go(arg0_7._blocker))
end

function var2_0.ClickEase(arg0_8)
	local var0_8 = arg0_8._blocker.localScale.x - 0.05

	LeanTween.scale(arg0_8._blocker, Vector3(var0_8, var0_8, 0), 0.03):setOnComplete(System.Action(function()
		arg0_8:Active()
	end))
end

function var2_0.Eliminate(arg0_10, arg1_10)
	LeanTween.cancel(go(arg0_10._blocker))
	setActive(arg0_10._blocker:Find("normal"), not arg1_10)
	setActive(arg0_10._blocker:Find("hitted"), arg1_10)
	LeanTween.scale(arg0_10._blocker, Vector3(0, 0, 0), 0.1):setOnComplete(System.Action(function()
		arg0_10._callback()
	end))
end

function var2_0.Dispose(arg0_12)
	if arg0_12.eventTriggers then
		for iter0_12, iter1_12 in pairs(arg0_12.eventTriggers) do
			ClearEventTrigger(iter0_12)
		end

		arg0_12.eventTriggers = nil
	end

	LeanTween.cancel(go(arg0_12._blocker))
end
