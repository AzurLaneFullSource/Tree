ys = ys or {}

local var0 = ys

var0.Battle.BattleTimerView = class("BattleTimerView")
var0.Battle.BattleTimerView.__name = "BattleTimerView"

function var0.Battle.BattleTimerView.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._timer = arg0._go.transform:Find("Text")
	arg0._blinker = arg0._timer:GetComponent(typeof(Animator))
	arg0._isBlink = false
	arg0._text = arg0._timer:GetComponent(typeof(Text))
	arg0.timeStr = ""
end

function var0.Battle.BattleTimerView.SetActive(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var0.Battle.BattleTimerView.SetCountDownText(arg0, arg1)
	if arg1 <= 30 and not arg0._isBlink then
		arg0._blinker.enabled = true
		arg0._isBlink = true
	end

	local var0 = arg0.formatTime(math.floor(arg1))

	if var0 == arg0.timeStr then
		return
	end

	arg0.timeStr = var0
	arg0._text.text = var0
end

function var0.Battle.BattleTimerView.formatTime(arg0)
	return string.format("%02u:%02u", math.floor(arg0 / 60), arg0 % 60)
end

function var0.Battle.BattleTimerView.Dispose(arg0)
	return
end
