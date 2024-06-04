ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleConfig
local var3 = class("BattleSimulationBuffCountView")

var0.Battle.BattleSimulationBuffCountView = var3
var3.__name = "BattleSimulationBuffCountView"

function var3.Ctor(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._timer = arg0._tf:Find("buff_count/Text")
	arg0._text = arg0._timer:GetComponent(typeof(Text))
end

function var3.SetActive(arg0, arg1)
	setActive(arg0._go, arg1)
end

function var3.SetCountDownText(arg0, arg1)
	arg0._text.text = i18n("simulation_advantage_counting", math.floor(arg1))
end

function var3.SetEnhancedText(arg0)
	arg0._text.text = i18n("simulation_enhanced")
end

function var3.Dispose(arg0)
	arg0._rateBarList = nil
	arg0._progressList = nil
end
