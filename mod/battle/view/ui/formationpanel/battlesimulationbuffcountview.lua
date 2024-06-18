ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleConfig
local var3_0 = class("BattleSimulationBuffCountView")

var0_0.Battle.BattleSimulationBuffCountView = var3_0
var3_0.__name = "BattleSimulationBuffCountView"

function var3_0.Ctor(arg0_1, arg1_1)
	var0_0.EventListener.AttachEventListener(arg0_1)

	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1._timer = arg0_1._tf:Find("buff_count/Text")
	arg0_1._text = arg0_1._timer:GetComponent(typeof(Text))
end

function var3_0.SetActive(arg0_2, arg1_2)
	setActive(arg0_2._go, arg1_2)
end

function var3_0.SetCountDownText(arg0_3, arg1_3)
	arg0_3._text.text = i18n("simulation_advantage_counting", math.floor(arg1_3))
end

function var3_0.SetEnhancedText(arg0_4)
	arg0_4._text.text = i18n("simulation_enhanced")
end

function var3_0.Dispose(arg0_5)
	arg0_5._rateBarList = nil
	arg0_5._progressList = nil
end
