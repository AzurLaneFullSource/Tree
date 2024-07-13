ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleTimerView = class("BattleTimerView")
var0_0.Battle.BattleTimerView.__name = "BattleTimerView"

function var0_0.Battle.BattleTimerView.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._timer = arg0_1._go.transform:Find("Text")
	arg0_1._blinker = arg0_1._timer:GetComponent(typeof(Animator))
	arg0_1._isBlink = false
	arg0_1._text = arg0_1._timer:GetComponent(typeof(Text))
	arg0_1.timeStr = ""
end

function var0_0.Battle.BattleTimerView.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._go, arg1_2)
end

function var0_0.Battle.BattleTimerView.SetCountDownText(arg0_3, arg1_3)
	if arg1_3 <= 30 and not arg0_3._isBlink then
		arg0_3._blinker.enabled = true
		arg0_3._isBlink = true
	end

	local var0_3 = arg0_3.formatTime(math.floor(arg1_3))

	if var0_3 == arg0_3.timeStr then
		return
	end

	arg0_3.timeStr = var0_3
	arg0_3._text.text = var0_3
end

function var0_0.Battle.BattleTimerView.formatTime(arg0_4)
	return string.format("%02u:%02u", math.floor(arg0_4 / 60), arg0_4 % 60)
end

function var0_0.Battle.BattleTimerView.Dispose(arg0_5)
	return
end
